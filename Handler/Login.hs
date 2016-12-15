{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ViewPatterns #-}




module Handler.Login where

import Handler.Import
import Module.LoginM

import Data.Text as DT
import Data.Text.Encoding (encodeUtf8)
import Yesod.Core.Handler(toTextUrl)

import Database.Persist.Sqlite
import Yesod

import Orm

{-
1.提供渲染loginWidget的逻辑
-}
loginWidget :: Maybe Text -> Widget
loginWidget mt = case mt of
        Nothing   -> do
                   (widget, enctype) <- handlerToWidget $ generateFormPost loginForm
                   people <- handlerToWidget $ runDB $ selectList [] [LimitTo 1]
                   let persons = people::[Entity Person]
                   $(widgetFile "widget/login_a")
        Just name -> do
                   (widget, enctype) <- handlerToWidget $ generateFormPost logoutForm
                   head_img <- return ("/static/img/phoenix.jpg"::Text)
                   $(widgetFile "widget/userInfo_v")
                   $(widgetFile "widget/logout_a")

{-
2.用于提供响应针对/login各种post，get请求的逻辑处理
-}

postLoginR :: Handler Html
postLoginR = do
            ((resultLogin , _),_) <- runFormPost loginForm
            ((resultLogout, _),_) <- runFormPost logoutForm
            case (resultLogin,resultLogout) of
                (FormSuccess message,_) -> do
                                         person <- runDB $ selectList  [PersonName ==. (DT.unpack (name message)),
                                                                        PersonPassword ==. (DT.unpack (password message))] []
                                         case Prelude.length person of
                                            0 -> do
                                                setMessage "用户不存在或者密码错误"
                                                redirect ((currentUrl message)::Text)
                                            _ -> do
                                                 let cookie = def { setCookieName = "login-name", setCookieValue = encodeUtf8 $  name message }
                                                 setCookie cookie
                                                 redirect ((currentUrl message)::Text)
                (_,FormSuccess message) -> do
                                      deleteCookie "login-name" "/"
                                      redirect HomeR
                (_,_) -> redirect HelpR




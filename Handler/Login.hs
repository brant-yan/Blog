{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Login where

import Handler.Import
import Module.LoginM

import Data.Text as DT
import Data.Text.Encoding (encodeUtf8)
import Yesod.Core.Handler(toTextUrl)

{-
1.用于提供响应针对/login各种post，get请求的逻辑处理
2.提供渲染loginWidget的逻辑
-}

postLoginR :: Handler Html
postLoginR = do
            ((resultLogin , _),_) <- runFormPost loginForm
            ((resultLogout, _),_) <- runFormPost logoutForm
            case (resultLogin,resultLogout) of
                (FormSuccess message,_) -> do
                                         let cookie = def { setCookieName = "login-name", setCookieValue = encodeUtf8 $  name message }
                                         setCookie cookie
                                         redirect ((currentUrl message)::Text)
                (_,FormSuccess message) -> do
                                      deleteCookie "login-name" "/"
                                      redirect HomeR
                (_,_) -> redirect HelpR


loginWidget :: Maybe Text -> Widget
loginWidget mt = case mt of
        Nothing   -> do
                   (widget, enctype) <- handlerToWidget $ generateFormPost loginForm
                   $(widgetFile "widget/login")
        Just name -> do
                   (widget, enctype) <- handlerToWidget $ generateFormPost logoutForm
                   head_img <- return ("/static/img/phoenix.jpg"::Text)
                   $(widgetFile "widget/userInfo")
                   $(widgetFile "widget/logined")

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

import Data.Text as DT
import Data.Text.Encoding (encodeUtf8)
import Yesod.Core.Handler(toTextUrl)


import Handler.Import
import Module.LoginM
import Snippet.LoginS


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




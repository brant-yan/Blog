{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Handler.Import

import Handler.Login
import Handler.Blog


getHomeR :: Handler Html
getHomeR = homepageDashboard $ do
           left <- (handlerToWidget $ leftFrame blogsWidget)
           right <- (handlerToWidget $ rightFrame userInfo)
           $(widgetFile "frame/vertical_two")
           where userInfo = do
                               maybeName <- lookupCookie "login-name"
                               loginWidget maybeName


postHomeR :: Handler Html
postHomeR = do
            deleteCookie "login-name" "/"
            redirect HomeR

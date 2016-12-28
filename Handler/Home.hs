{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Handler.Import

import Handler.Login
import Snippet.LoginS
import Snippet.BlogS
import Snippet.PageS
import Snippet.EvaluateS

getHomeR :: Handler Html
getHomeR = homepageDashboard $ do
           left <- (handlerToWidget $ leftFrame content)
           right <- (handlerToWidget $ rightFrame userInfo)
           $(widgetFile "frame/vertical_two")

           where userInfo = do
                       maybeName <- lookupCookie "login-name"
                       loginSnippet maybeName
                 content = do
                            blogsWidget
                            evaluateLevelCount
                            pageWidget 1

postHomeR :: Handler Html
postHomeR = do
            deleteCookie "login-name" "/"
            redirect HomeR

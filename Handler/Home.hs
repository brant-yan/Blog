{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Handler.Import

import Handler.HotProduct
import Handler.BestChapter
import Handler.Login
import Handler.Blog
import Web.Cookie

{-
getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    titles <- pure $ [1,2,3]
    toWidgetHead [hamlet|
        <link rel=stylesheet href=@{StaticR style_css}>
    |]
    [whamlet|
        <img src=@{StaticR logo_jpg}>
    |]
    [whamlet|
        <p>
            欢迎访问brant的图书馆
    |]
    [whamlet|
        <ul>
            $forall title <- titles
                <li .heng>
                    #{show title}
    |]
-}


-- let cookie = def { setCookieName = "login-name", setCookieValue = "cookieValue" }
--           setCookie cookie

getHomeR :: Handler Html
getHomeR = homepageLayout $ do
           maybeName <- lookupCookie "login-name"
           loginWidget maybeName
           $(widgetFile "homepage")
           blogWidget


postHomeR :: Handler Html
postHomeR = do
            deleteCookie "login-name" "/"
            redirect HomeR

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Home where

import Foundation
import Yesod.Core
import Help

import Text.Hamlet (HtmlUrl, hamlet)
import Text.Blaze.Renderer.String (renderHtml)
import Data.Text (Text,pack)


getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    man <- pure $ Person "Jack" 47
    headerClass <- newIdent
    headerClass1 <- newIdent
    req <- getRequest
    let params = reqGetParams req
    paramStyle <- lookupGetParams "style"
    setTitle "Minimal Multifile"
    [whamlet|
        <p>
            <img src=@{StaticR img_rabbit_jpg}>
        <p>
            <a href=@{AddR 5 7}>HTML addition

        <p>
            <a href=@{AddR 5 7}?_accept=application/json>JSON addition
        <p>
            <a href=@{RenderObjectR $ Data.Text.pack "I am string"}>Redirect Page

            <a href=@{HelpR 123}>help Page
        <b> #{name person} is  #{age person} old
    |]
    [whamlet|
        #{name man} is  #{age man} old

        #{head paramStyle}
        #{show params}

        $maybe p <- myself
            <p>Your name is #{name p}
        $nothing
            <p>I don't know your name.
        $if null people
            <p>No people.
        $else
            <ul>
                $forall pp <- people
                    <li>#{name pp}

    |]
    toWidget [shamlet|
        <p>
            <strong>This is shamlet message  #{name person} #{headerClass1}
    |]
    [whamlet|
            <p>
                <strong>This is hamlet message #{name person} #{headerClass}
                ^{simpleFooter}
        |]

    where
        myself = Just $ Person "myself" 456
        person = Person "brant" 123
        person1 = Person "father" 56
        person2 = Person "mother" 54
        people = [person1,person2]


data Person = Person { name :: String , age :: Int}
{-
footer = do
         toWidget [lucius| footer { font-weight: bold; text-align: center } |]
         toWidget [hamlet|
             <footer>
                <p>That's all folks!
         |]
         -}
simpleFooter = [whamlet|
                            <footer>
                               <p>That's foot!
                        |]

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

{-# LANGUAGE QuasiQuotes, TemplateHaskell, MultiParamTypeClasses, OverloadedStrings, TypeFamilies #-}

module PPerson where

import Yesod
import Yesod.Form.Jquery
import Data.Time (Day)
import Data.Text (Text)
import Control.Applicative ((<$>), (<*>))
import Foundation

{-
data PPerson = PPerson{ personName :: Text} deriving Show

personForm :: Html -> MForm App App (FormResult PPerson, Widget)
personForm = renderDivs $ PPerson
    <$> areq textField "Name" Nothing


getPersonR :: Handler Html
getPersonR = do
    ((_, widget), enctype) <- generateFormPost personForm
    defaultLayout [whamlet|
        <p>The widget generated contains only the contents of the form, not the form tag itself. So...
        <form method=get action=@{PersonR} enctype=#{enctype}>
            ^{widget}
            <p>It also doesn't include the submit button.
            <input type=submit>
    |]-}
{-
postPersonR :: Handler RepHtml
postPersonR = do
    ((result, widget), enctype) <- runFormPost personForm
    case result of
        FormSuccess person -> defaultLayout [whamlet|<p>#{show person}|]
        _ -> defaultLayout [whamlet|
                <p>Invalid input, let's try again.
                <form method=post action=@{PersonR} enctype=#{enctype}>
                    ^{widget}
                    <input type=submit>
                |]
                -}
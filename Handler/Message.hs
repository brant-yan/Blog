{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Message where

import Handler.Import

-- function import
import  Control.Applicative ((<$>), (<*>))


-- custom import
import Module.Message


postMessageR :: Handler Html
postMessageR = do
        ((result, widget), enctype) <- runFormPost messageForm
        case result of
            FormSuccess message -> defaultLayout [whamlet|<p>#{show message}|]
            _ -> defaultLayout [whamlet|
                                    <p>Invalid input, let's try again.
                                    <form method=post action=@{HomeR} enctype=#{enctype}>
                                    ^{widget} <button>Submit
                                |]



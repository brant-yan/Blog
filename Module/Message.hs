{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

{-# LANGUAGE MultiParamTypeClasses #-}
module Module.Message where

import Foundation

import  Control.Applicative ((<$>), (<*>))
import  Yesod
import  Yesod.Form.Jquery

import Data.Text (Text,pack)
import Settings

data CustomMessage = CustomMessage{     name :: Text
                                    ,   message :: Text
                                  } deriving Show

messageForm :: Html -> MForm Handler (FormResult CustomMessage, Widget)
messageForm = renderDivs $ CustomMessage
                <$> areq textField "姓名" Nothing
                <*> areq textField "留言" Nothing
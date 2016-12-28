{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

{-# LANGUAGE MultiParamTypeClasses #-}
module Module.EvaluateM where

import Foundation

import  Control.Applicative ((<$>), (<*>))
import  Yesod
import  Yesod.Form.Jquery

import Data.Text (Text,pack)
import Settings

import Data.Text.Encoding(decodeUtf8)
import Yesod.Core.Handler
import Orm

{- 提供用户写blog的页面对应项-}

data EvaluateMessage = EvaluateMessage{ blogId :: BlogId
                                      , level :: Text
                                      } deriving Show


evaluateForm :: BlogId -> Html -> MForm Handler (FormResult EvaluateMessage, Widget)
evaluateForm bId html = flip  renderDivs html $ EvaluateMessage
                            <$> areq hiddenField "" (Just bId)
                            <*> areq (radioFieldList [( pack "不喜欢",pack "l"),( "一般","m"),("喜欢","h")]) "打分" (Just ("m"))

evaluateFormT ::  Html -> MForm Handler (FormResult EvaluateMessage, Widget)
evaluateFormT = renderDivs $ EvaluateMessage
                            <$> areq hiddenField "" Nothing
                            <*> areq (radioFieldList [( pack "不喜欢",pack "l"),( "一般","m"),("喜欢","h")]) "打分" (Just ("m"))


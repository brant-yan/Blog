{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

{-# LANGUAGE MultiParamTypeClasses #-}
module Module.BlogM where

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

data BlogMessage = BlogMessage{ title :: Text
                              , content :: Text
                              , createTime :: Text
                              } deriving Show


blogForm :: Html -> MForm Handler (FormResult BlogMessage, Widget)
blogForm =  renderDivs $ BlogMessage
                    <$> areq textField "文章标题" Nothing
                    <*> areq textField "文章内容" Nothing
                    <*> areq textField "创建时间" Nothing
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}


{-# LANGUAGE MultiParamTypeClasses #-}
module Module.RegisterM where

import Foundation

import  Control.Applicative ((<$>), (<*>))
import  Yesod
import  Yesod.Form.Jquery

import Data.Text (Text,pack)
import Settings

import Data.Text.Encoding(decodeUtf8)
import Yesod.Core.Handler
import Network.Wai



{-用于生成需要提交的登录表单内容，并填充对应的项-}

data RegisterMessage = RegisterMessage{ name :: Text
                                      , password :: Text
                                      , sex::Text
                                      , hobby::[Text]
                                      , cars::[Text]
                                      } deriving Show


registerForm :: Html -> MForm Handler (FormResult RegisterMessage, Widget)
registerForm = do
            renderDivs $ RegisterMessage
                <$> areq textField "新用户名" Nothing
                <*> areq textField "用户密码" Nothing
                <*> areq (radioFieldList [( pack "1", pack "男"),( "2", "女")]) "性别" Nothing
                <*> areq (checkboxesField $ optionsPairs hobby) "兴趣" Nothing
                <*> areq (multiSelectField $ optionsPairs [(pack "宝马", pack "宝马"),( "大众",  "大众")]) "坐驾" Nothing  -- 下拉选中
             where hobby =  [( "音乐", "音乐"),("体育","体育")]::[(Text,Text)]

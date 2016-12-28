{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Evaluate where

import Data.Text as DT
import Orm

import Handler.Import
import Module.EvaluateM
import Snippet.EvaluateS


postRecordEvaluateR :: BlogId ->  Handler Html
postRecordEvaluateR bid= do
            ((evaluateMessage , _),_) <- runFormPost $ evaluateForm bid
            case evaluateMessage of
                FormSuccess message -> do
                                evaluateId <- runDB $ insert $ Evaluate bid ((level message))
                                setMessage "打分保存成功"
                                redirect HomeR
                _ -> do
                    setMessage "打分保存失败"
                    redirect HomeR


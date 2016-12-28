{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Snippet.EvaluateS where

import Handler.Import
import Module.EvaluateM

import qualified Database.Esqueleto as E

evaluateWidget :: BlogId ->  Widget
evaluateWidget bid = do
             bloglist <- handlerToWidget $ runDB $ selectList [BlogId ==. bid] []
             $(widgetFile "widget/blog_v")

evaluateLevel :: Widget
evaluateLevel = do
        evaluates <- handlerToWidget $ runDB evaluateLevel1
        $(widgetFile "widget/evaluate_v")
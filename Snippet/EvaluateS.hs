{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Snippet.EvaluateS where

import Handler.Import
import Module.EvaluateM

evaluateWidget :: BlogId ->  Widget
evaluateWidget bid = do
             bloglist <- handlerToWidget $ runDB $ selectList [BlogId ==. bid] []
             $(widgetFile "widget/blog_v")
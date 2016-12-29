{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Snippet.BlogS where

import Handler.Import
import Module.BlogM
import Module.EvaluateM



{-
1.提供渲染blogWidget的逻辑
-}

newBlogWidget :: Widget
newBlogWidget = do
        (widget, enctype) <- handlerToWidget $ generateFormPost blogForm
        $(widgetFile "widget/blog_a_write")


blogsWidget :: Widget
blogsWidget = do
             bloglist <- handlerToWidget $ runDB $ selectList [] [LimitTo 3,Desc BlogId]
             $(widgetFile "widget/blogs_v")


blogWidget :: BlogId ->  Widget
blogWidget bid = do
             bloglist <- handlerToWidget $ runDB $ selectList [BlogId ==. bid] []
             $(widgetFile "widget/blog_v")
             (widget, enctype) <- handlerToWidget $ generateFormPost $ evaluateForm bid
             let blogId=bid
             $(widgetFile "widget/evaluate_a_write")

blogListWidget :: Int ->  Widget
blogListWidget bindex = do
             bloglist <- handlerToWidget $ runDB $ selectList [] [LimitTo 3, OffsetBy (bindex * 3),Desc BlogId]
             $(widgetFile "widget/blog_v")

blogById :: BlogId -> HandlerT App IO [Entity Blog]
blogById bid = runDB $ selectList [BlogId ==. bid] []
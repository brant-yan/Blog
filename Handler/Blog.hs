{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE GADTs #-}
module Handler.Blog where

import Data.Text as DT
import Orm

import Handler.Import
import Module.BlogM
import Snippet.BlogS

data BlogJ = BlogJ {    bTitle :: Text
                      , bContent ::Text
                      , bCreateTime :: Text
                     }deriving Show
data JsonMessage a = (ToJSON a)=> JsonMessage{
                            status :: Int
                          , body :: a
                        } |  EmptyMessage

instance ToJSON (JsonMessage a)  where
    toJSON  j =
        case j of
            JsonMessage{..}  -> object
                [ "status" .= status
                , "body"   .= toJSON body
                ]
            EmptyMessage  -> object
                [ "status" .= (Number 404)
                , "msg"   .= DT.pack "数据不存在"
                ]

instance ToJSON BlogJ where
    toJSON BlogJ {..} = object
            [ "title" .= bTitle
            , "content" .= bContent
            ]
getBlogR :: BlogId -> Handler Value
getBlogR bid = do
        blogs <- blogById bid
        case blogs of
            (Entity _ blog): _ -> do
                            returnJson $ JsonMessage
                                            200
                                            (BlogJ
                                             (DT.pack $  blogTitle blog)
                                             (DT.pack $  blogContent blog)
                                             (DT.pack $  blogCreateTime blog))
            _ -> do
                returnJson EmptyMessage

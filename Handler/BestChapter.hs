{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.BestChapter where

import Handler.Import

chipBestChapter :: Widget
chipBestChapter = [whamlet|
                    <p>
                        最佳文章
                    <p>
                        <img src=@{StaticR book_bestchapter_bestchapter_jpg}>
                    |]


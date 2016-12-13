{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.HotProduct where

import Handler.Import

chipFrontpage :: Widget
chipFrontpage = [whamlet|
                <p>
                    热门商品简介
                    <ul>
                        $forall pp <- people
                            <li>
                                <img src=#{pp}>
                |]
                    where people = (map (\x->"/static/book/small/"++x)["pic-hongloumeng.jpg",
                                    "pic-sanguo.jpg",
                                    "pic-shuihuzhuan.jpg",
                                    "pic-xiyouji.jpg"])::[String]


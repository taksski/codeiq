module Gemstring where

import Data.List

type Gem = (Char, Integer)

removeGem :: [Gem] -> Char -> [Gem]
removeGem [] _ = []
removeGem ((gx,1):gs) g
  | gx == g   = gs
removeGem (gt@(gx,n):gs) g
  | gx == g   = (gx,n-1):gs
  | otherwise = gt:removeGem gs g

parse :: String -> [Gem]
parse [] = []
parse (g:gr) = seq gs $ addGem gs g
  where
    gs = parse gr
    addGem :: [Gem] -> Char -> [Gem]
    addGem [] g = [(g,1)]
    addGem (gh@(g1,n):gs) g
      | g == g1    = (g1,n+1):gs
      | otherwise  = sort $! gh:(addGem gs g)

-- count
-- ���Фν��礫�顢��§�ˤ������ä�(�����ޤ�)������ǽ��
-- ��򤹤٤ƿ����夲��
count :: [Gem] -> Integer
count [] = 1
count gs = foldl (+) 1 $! map (\g->count $! removeGem gs g) $! map (fst) gs

-- appearance_day
-- Ϳ����줿�ѥ���������Ф������ܤ˽и����뤫���֤�
appearance_day :: String -> String -> Integer
appearance_day gems ptn = seq gemset $ appearance_day1 gemset ptn
  where
    gemset = parse gems
    appearance_day1 :: [Gem] -> String -> Integer
    appearance_day1 gs p = seq gh $ appearance_day2 gs gh p
      where gh = map (fst) gs
    appearance_day2 :: [Gem] -> String -> String -> Integer
    appearance_day2 _ _ "" = 0
    appearance_day2 gs (g:gr) p@(ph:pr)
      | g == ph   = 1 + (seq gs1 $ appearance_day1 gs1 pr)
      | otherwise = (count $! gs1) + (appearance_day2 gs gr p)
      where gs1 = removeGem gs g

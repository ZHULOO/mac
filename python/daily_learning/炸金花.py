# 炸金花
"""
1. 先生成一付完整的扑克牌

2. 给5个玩家随机发牌

3. 统一开牌，比大小，输出赢家是谁
"""
import random

num = [2,3,4,5,6,7,8,9,10,"J","Q","K","A"]
color = ["红桃","方块","黑桃","梅花"]
one_poker = []
for i in color:
    for j in num:
        one_poker.append([i,j])
print(one_poker)

def play(*args):
    cards = one_poker
    random.shuffle(cards)
    names = {}.fromkeys(args,[])
    for i in names:
        cards_3 = random.sample(cards,3)
        names[i] = cards_3
        for j in cards_3:
            cards.remove(j)
    return names

print(play("player1","player2","player3","player4","player5"))

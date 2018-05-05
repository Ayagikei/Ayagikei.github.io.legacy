---
title: Java DFS+贪心解决骑士游历问题
tags:
  - 数据结构
  - java
  - 技术
  - 查找
  - 算法
categories:
  - 技术
  - 数据结构与算法
abbrlink: a3a124b6
date: 2018-05-05 18:51:46
---

{% note info %} 

## **题目**

 {% endnote %}

> 骑士游历
>
> 骑士游历问题是指，在国际象棋的棋盘（8行*8列）上，一个马要遍历棋盘，即走到棋盘上的每一格，并且每隔只到达一次。设码在棋盘的某一位置（x,y）上，按照“走马日”的规则，下一步有8个方向走，如图所示。若给定起始位置（x0,y0）,使用站和队列探索出一条马遍历棋盘的路径。
>
> |      |      | 8    |      | 1    |      |      |      |
> | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
> |      | 7    |      |      |      | 2    |      |      |
> |      |      |      | 马   |      |      |      |      |
> |      | 6    |      |      |      | 3    |      |      |
> |      |      | 5    |      | 4    |      |      |      |


<!-- more -->

<br />

{% note info %} 

## **回溯枚举解法**

 {% endnote %}



这道题的解法思路和[走迷宫](http://sarasarasa.net/post/995edba2.html)类似。

首先是新建一个8个方向移动的结点类：

```java

package lab3.Knight;

/**
 * @author AyagiKei
 * @url https://github.com/Ayagikei
 **/
public class Point {
    private int x,y;

    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public int getX() {
        return x;
    }

    public void setX(int x) {
        this.x = x;
    }

    public int getY() {
        return y;
    }

    public void setY(int y) {
        this.y = y;
    }

    public Point moveNE(){
        if(this.getX()-2 <1 || this.getY()+1 >8)
            return null;

        return new Point(this.getX()-2,this.getY()+1);
    }

    public Point moveEN(){
        if(this.getX()-1 <1 || this.getY()+2 >8)
            return null;

        return new Point(this.getX()-1,this.getY()+2);
    }

    public Point moveES(){
        if(this.getX()+1 > 8 || this.getY()+2 >8)
            return null;

        return new Point(this.getX()+1,this.getY()+2);
    }

    public Point moveSE(){
        if(this.getX()+2 > 8 || this.getY()+1 >8)
            return null;

        return new Point(this.getX()+2,this.getY()+1);
    }

    public Point moveSW(){
        if(this.getX()+2 > 8 || this.getY()-1 <1)
            return null;

        return new Point(this.getX()+2,this.getY()-1);
    }

    public Point moveWS(){
        if(this.getX()+1 > 8 || this.getY()-2 <1)
            return null;

        return new Point(this.getX()+1,this.getY()-2);
    }

    public Point moveWN(){
        if(this.getX()-1 < 1 || this.getY()-2 <1)
            return null;

        return new Point(this.getX()-1,this.getY()-2);
    }

    public Point moveNW(){
        if(this.getX()-2 < 1 || this.getY()-1 <1)
            return null;

        return new Point(this.getX()-2,this.getY()-1);
    }

    @Override
    public int hashCode() {
        int result = 17;
        result = 31 * result + this.getX();
        result = 31 * result + this.getY();
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if(obj == this) return true;
        if(!(obj instanceof Point)) return false;
        if(obj.hashCode()!=this.hashCode()) return false;

        Point p = (Point) obj;
        return (p.getY() == this.getY()) && (p.getX() == this.getX());
    }
}

```



我们这里用一个数组保存每个点搜索过的方向，如果这个点搜索过北偏东方向的话，就标为1。回溯之后可以根据这个信息搜索其他方向。

和走迷宫稍有不同的是，一个点可由多个方向抵达，并且抵达后的棋盘状况不一定。所以回溯的时候，要把沿途的点的状态清为0。

当栈的size等于64的时候，就代表所有点都走过且仅走过一遍了。再倒着把每个点的路径标上、输出就ok了。



**思路上是这样的，但实际运行的时候发现，8*8的棋盘dfs时间异常长，是得不出结果的。这个做法只能用于较小的棋盘。**

<br />

最后栈所保存的元素就是路径上的每一个点了。

优化前代码如下：

```java
    public static int chess[][]=new int[9][9];

    public static String solveByStack(Point entrance){
        Stack<Point> solve = new Stack<>();

        chess =new int[9][9];


        solve.push(entrance);
        solve.peek();
        chess[entrance.getX()][entrance.getY()] = 0;

        Point pTop;

        //所有点走过为止
        while(solve.size()!=64){

            Point qNewTop;

            pTop = solve.peek();
            System.out.println("("+pTop.getX()+"," + pTop.getY()+")");

            if(chess[pTop.getX()][pTop.getY()] < 1 && (qNewTop = pTop.moveNE()) != null && chess[qNewTop.getX()][qNewTop.getY()] == 0){
                chess[pTop.getX()][pTop.getY()] = 1;
                solve.push(qNewTop);
                continue;
            }

            if(chess[pTop.getX()][pTop.getY()] < 2 && (qNewTop = pTop.moveEN()) != null && chess[qNewTop.getX()][qNewTop.getY()] == 0){
                chess[pTop.getX()][pTop.getY()] = 2;
                solve.push(qNewTop);
                continue;
            }

            if(chess[pTop.getX()][pTop.getY()] < 3 && (qNewTop = pTop.moveES()) != null && chess[qNewTop.getX()][qNewTop.getY()] == 0){
                chess[pTop.getX()][pTop.getY()] = 3;
                solve.push(qNewTop);
                continue;
            }

            if(chess[pTop.getX()][pTop.getY()] < 4 && (qNewTop = pTop.moveSE()) != null && chess[qNewTop.getX()][qNewTop.getY()] == 0){
                chess[pTop.getX()][pTop.getY()] = 4;
                solve.push(qNewTop);
                continue;
            }

            if(chess[pTop.getX()][pTop.getY()] < 5 && (qNewTop = pTop.moveSW()) != null && chess[qNewTop.getX()][qNewTop.getY()] == 0){
                chess[pTop.getX()][pTop.getY()] = 5;
                solve.push(qNewTop);
                continue;
            }

            if(chess[pTop.getX()][pTop.getY()] < 6 && (qNewTop = pTop.moveWS()) != null && chess[qNewTop.getX()][qNewTop.getY()] == 0){
                chess[pTop.getX()][pTop.getY()] = 6;
                solve.push(qNewTop);
                continue;
            }

            if(chess[pTop.getX()][pTop.getY()] < 7 && (qNewTop = pTop.moveWN()) != null && chess[qNewTop.getX()][qNewTop.getY()] == 0){
                chess[pTop.getX()][pTop.getY()] = 7;
                solve.push(qNewTop);
                continue;
            }

            if(chess[pTop.getX()][pTop.getY()] < 8 && (qNewTop = pTop.moveNW()) != null && chess[qNewTop.getX()][qNewTop.getY()] == 0){
                chess[pTop.getX()][pTop.getY()] = 8;
                solve.push(qNewTop);
                continue;
            }

            //无路可走 回溯
            chess[pTop.getX()][pTop.getY()] = 0;
            solve.pop();

        }

        System.out.println(solve.size());

        while(!solve.isEmpty()){
            pTop = solve.pop();
            chess[pTop.getX()][pTop.getY()] = solve.size()+1;
        }

        StringBuffer stringBuffer = new StringBuffer();
        for(int i=1;i<9;i++) {
            for (int j = 1; j < 9; j++) {
                stringBuffer.append(chess[i][j] +" ");
            }
            stringBuffer.append("\r\n");
        }

        return stringBuffer.toString();
    }
```



{% note info %} 

## **使用贪心（预见算法）优化**

 {% endnote %}

贪心优化的思路是：有选择性的走下一个点，先走最难到达的点。

所以我们这里增加了一个新方法 *public static int countAccess(Point p)* 来计算8个方向中有多少个方向可以到达p点。

然后选择方向的时候以此为标准，先走去最难走的方向，就可以实现优化了。

<br />

代码如下：

```java
     public static String solveByStackWithOpti(Point entrance){
        Stack<Point> solve = new Stack<>();

        chess = new int[9][9];


        solve.push(entrance);
        solve.peek();
        chess[entrance.getX()][entrance.getY()] = 0;

        Point pTop;

        //所有点走过为止
        while(solve.size()!=64){

            Point qNewTop,chosenPoint = null;
            int direction = 0,cnt = 9;

            pTop = solve.peek();
            System.out.println("("+pTop.getX()+"," + pTop.getY()+")");

            //每一步选择通路最少的能行路


            if(chess[pTop.getX()][pTop.getY()] < 1 && (qNewTop = pTop.moveNE()) != null && chess[qNewTop.getX()][qNewTop.getY()] == 0){
                if(countAccess(qNewTop) < cnt){
                    cnt = countAccess(qNewTop);
                    direction = 1;
                    chosenPoint = qNewTop;
                }

            }

            if(chess[pTop.getX()][pTop.getY()] < 2 && (qNewTop = pTop.moveEN()) != null && chess[qNewTop.getX()][qNewTop.getY()] == 0){
                if(countAccess(qNewTop) < cnt){
                    cnt = countAccess(qNewTop);
                    direction = 2;
                    chosenPoint = qNewTop;
                }

            }

            if(chess[pTop.getX()][pTop.getY()] < 3 && (qNewTop = pTop.moveES()) != null && chess[qNewTop.getX()][qNewTop.getY()] == 0){
                if(countAccess(qNewTop) < cnt){
                    cnt = countAccess(qNewTop);
                    direction = 3;
                    chosenPoint = qNewTop;
                }

            }

            if(chess[pTop.getX()][pTop.getY()] < 4 && (qNewTop = pTop.moveSE()) != null && chess[qNewTop.getX()][qNewTop.getY()] == 0){
                if(countAccess(qNewTop) < cnt){
                    cnt = countAccess(qNewTop);
                    direction = 4;
                    chosenPoint = qNewTop;
                }

            }

            if(chess[pTop.getX()][pTop.getY()] < 5 && (qNewTop = pTop.moveSW()) != null && chess[qNewTop.getX()][qNewTop.getY()] == 0){
                if(countAccess(qNewTop) < cnt){
                    cnt = countAccess(qNewTop);
                    direction = 5;
                    chosenPoint = qNewTop;
                }

            }

            if(chess[pTop.getX()][pTop.getY()] < 6 && (qNewTop = pTop.moveWS()) != null && chess[qNewTop.getX()][qNewTop.getY()] == 0){
                if(countAccess(qNewTop) < cnt){
                    cnt = countAccess(qNewTop);
                    direction = 6;
                    chosenPoint = qNewTop;
                }

            }

            if(chess[pTop.getX()][pTop.getY()] < 7 && (qNewTop = pTop.moveWN()) != null && chess[qNewTop.getX()][qNewTop.getY()] == 0){
                if(countAccess(qNewTop) < cnt){
                    cnt = countAccess(qNewTop);
                    direction = 7;
                    chosenPoint = qNewTop;
                }

            }

            if(chess[pTop.getX()][pTop.getY()] < 8 && (qNewTop = pTop.moveNW()) != null && chess[qNewTop.getX()][qNewTop.getY()] == 0){
                if(countAccess(qNewTop) < cnt){
                    cnt = countAccess(qNewTop);
                    direction = 8;
                    chosenPoint = qNewTop;
                }

            }


            if(cnt == 9) {
                //无路可走 回溯
                chess[pTop.getX()][pTop.getY()] = 0;
                solve.pop();
            }
            else{
                //选择最窄的路先走
                chess[pTop.getX()][pTop.getY()] = direction;
                solve.push(chosenPoint);
            }

        }

        System.out.println(solve.size());

        while(!solve.isEmpty()){
            pTop = solve.pop();
            chess[pTop.getX()][pTop.getY()] = solve.size()+1;
        }

        StringBuffer stringBuffer = new StringBuffer();
        for(int i=1;i<9;i++) {
            for (int j = 1; j < 9; j++) {
                stringBuffer.append(chess[i][j] +" ");
            }
            stringBuffer.append("\r\n");
        }

        return stringBuffer.toString();
    }

    public static int countAccess(Point p){
        int cnt = 0;

        if(p.moveNE() != null && chess[p.moveNE().getX()][p.moveNE().getY()] == 0)
            cnt ++;

        if(p.moveEN() != null && chess[p.moveEN().getX()][p.moveEN().getY()] == 0)
            cnt ++;

        if(p.moveES() != null && chess[p.moveES().getX()][p.moveES().getY()] == 0)
            cnt ++;

        if(p.moveSE() != null && chess[p.moveSE().getX()][p.moveSE().getY()] == 0)
            cnt ++;

        if(p.moveSW() != null && chess[p.moveSW().getX()][p.moveSW().getY()] == 0)
            cnt ++;

        if(p.moveWS() != null && chess[p.moveWS().getX()][p.moveWS().getY()] == 0)
            cnt ++;

        if(p.moveWN() != null && chess[p.moveWN().getX()][p.moveWN().getY()] == 0)
            cnt ++;

        if(p.moveNW() != null && chess[p.moveNW().getX()][p.moveNW().getY()] == 0)
            cnt ++;

        return cnt;

    }
```

{% note info %} 

## **代码以及运行结果**

 {% endnote %}

```java
System.out.println(KnightProblemSolve.solveByStackWithOpti(new Point(4,5)));

(4,5)
(2,6)
(1,8)
(3,7)
(5,8)
(7,7)
(8,5)
(6,6)
(7,8)
(8,6)
(7,4)
(8,2)
(6,1)
(7,3)
(8,1)
(6,2)
(8,3)
(7,1)
(5,2)
(3,1)
(1,2)
(2,4)
(1,6)
(2,8)
(4,7)
(6,8)
(8,7)
(7,5)
(5,6)
(4,8)
(6,7)
(8,8)
(7,6)
(6,4)
(7,2)
(8,4)
(6,5)
(5,7)
(3,8)
(1,7)
(3,6)
(5,5)
(6,3)
(5,1)
(4,3)
(2,2)
(1,4)
(3,5)
(2,7)
(1,5)
(2,3)
(1,1)
(3,2)
(4,4)
(2,5)
(4,6)
(5,4)
(4,2)
(3,4)
(5,3)
(4,1)
(3,3)
(2,1)
64
52 21 64 47 50 23 40 3 
63 46 51 22 55 2 49 24 
20 53 62 59 48 41 4 39 
61 58 45 54 1 56 25 30 
44 19 60 57 42 29 38 5 
13 16 43 34 37 8 31 26 
18 35 14 11 28 33 6 9 
15 12 17 36 7 10 27 32 
```

所耗时间仅为20ms。

{% note info %} 

## **参考文章**

 {% endnote %}

https://blog.csdn.net/sb___itfk/article/details/50905275
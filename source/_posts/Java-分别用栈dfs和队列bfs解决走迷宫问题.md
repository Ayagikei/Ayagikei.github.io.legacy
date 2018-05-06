---
title: Java 分别用栈dfs和队列bfs解决走迷宫问题
abbrlink: 995edba2
date: 2018-05-04 21:16:24
tags: 
- 数据结构
- java
- 技术
- 查找
- 算法
categories: 
- 技术
- 数据结构与算法
---

{% note info %} 

## **题目**

 {% endnote %}

> 走迷宫。
>
> 一个迷宫如图所示，他有一个入口和一个出口，其中白色单元表示通路，黑色单元表示不通路。试寻找一条从入口到出口的路径，每一部只能从一个白色单元走到相邻的白色单元，直至出口。分别用栈和队列求解问题。
>
>  {% asset_img 01.jpg %}

<!-- more -->

<br />

{% note info %} 

## **栈的解法**

 {% endnote %}



首先写一个Point类来方便保存每个点的xy值，并且方便表示上下左右各个方向的点。

```java

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

    public Point left(){
        if(this.getY()==0)
            return null;

        return new Point(this.getX(),this.getY()-1);
    }

    public Point right(){
        return new Point(this.getX(),this.getY()+1);
    }

    public Point up(){
        if(this.getX()==0)
            return null;

        return new Point(this.getX()-1,this.getY());
    }

    public Point down(){
        return new Point(this.getX()+1,this.getY());
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

栈进行dps的思路就是使用回溯法，遇到分岔路的时候，选择一条走到底；若遇到死胡同就回溯到上一个分岔路，选择另外一条路线，直到走到出口为止。

最后栈所保存的元素就是路径上的每一个点了。

代码如下：

```java
public static String solveByStack(int maze[][],Point entrance,Point exit){
    Stack<Point> solve = new Stack<>();

    solve.push(entrance);
    maze[entrance.getX()][entrance.getY()] = 2;

    Point p;

    //找到出口为止
    while(!solve.peek().equals(exit)){

        //System.out.println(solve.peek().getX() + " " + solve.peek().getY());

        //上下左右进一格，并将走过的地方标记为2
        if(((p = solve.peek().up())!=null) && maze[p.getX()][p.getY()] == 0){
            maze[p.getX()][p.getY()] = 2;
            solve.push(p);
           // System.out.println("up");
            continue;
        }

        p = solve.peek().down();
        if((p.getX() < maze.length) && maze[p.getX()][p.getY()] == 0){
            maze[p.getX()][p.getY()] = 2;
            solve.push(p);
          //  System.out.println("down");
            continue;
        }

        p =solve.peek().left();
        if((p !=null) && maze[p.getX()][p.getY()] == 0){
            maze[p.getX()][p.getY()] = 2;
            solve.push(p);
           // System.out.println("left");
            continue;
        }

        p = solve.peek().right();
        if((p.getY() < maze[0].length) && maze[p.getX()][p.getY()] == 0){
            maze[p.getX()][p.getY()] = 2;
            solve.push(p);
           // System.out.println("right");
            continue;
        }

        //无路可走 回溯
        solve.pop();
        //System.out.println("back");

    }

    //反向标记最终的路线为3
    while(!solve.isEmpty()){
        p = solve.pop();
        maze[p.getX()][p.getY()] = 3;
    }

    //构建字符串返回
    StringBuffer stringBuffer = new StringBuffer();
    for(int i=0;i<maze.length;i++) {
        for (int j = 0; j < maze[0].length; j++) {
            stringBuffer.append(maze[i][j]);
        }
        stringBuffer.append("\r\n");
    }

    return stringBuffer.toString();
}
```



{% note info %} 

## **队列的解法**

 {% endnote %}

队列同样也要用到Point类，代码同上。

使用队列进行bfs的思路就是，一层层的往下搜索。

<br />

具体方法为：

(1) 将从入口开始的相邻可通元素入队。

(2) 出队首元素，再将其相邻未曾入队的元素入队。

(3) 重复操作(2)，直到找到出口。

<br />

这样就有一个问题：该如何记录路径？

这里可以采用增加一个数组来保存经过的节点的前驱结点。

最后从出口可以，根据节点的前驱结点就可以找出完整的路径了。



代码如下：

```java
    public static String solveByQueue(int maze[][],Point entrance,Point exit){

        Point [][]mark = new Point[maze.length][maze[0].length];

        Queue<Point> queue = new LinkedList<Point>();

        //起点的前驱指向自己，并入队
        mark[entrance.getX()][entrance.getY()] = entrance;
        queue.offer(entrance);

        while(!queue.isEmpty()){
            Point p = queue.poll();


            Point n = p.up();
            if( n != null && maze[n.getX()][n.getY()] == 0 && mark[n.getX()][n.getY()] == null){
                mark[n.getX()][n.getY()] = p;
                if(n.equals(exit)){
                    break;
                }
                queue.offer(n);
            }

            n = p.down();
            if((n.getX() < maze.length) && maze[n.getX()][n.getY()] == 0 && mark[n.getX()][n.getY()] == null){
                mark[n.getX()][n.getY()] = p;
                if(n.equals(exit)){
                    break;
                }
                queue.offer(n);
            }

            n = p.left();
            if((n !=null) && maze[n.getX()][n.getY()] == 0 && mark[n.getX()][n.getY()] == null){
                mark[n.getX()][n.getY()] = p;
                if(n.equals(exit)){
                    break;
                }
                queue.offer(n);
            }

            n = p.right();
            if((n.getY() < maze[0].length) && maze[n.getX()][n.getY()] == 0 && mark[n.getX()][n.getY()] == null){
                mark[n.getX()][n.getY()] = p;
                if(n.equals(exit)){
                    break;
                }
                queue.offer(n);
            }

        }

        //标记路径
        Point p = exit;
        while(p != entrance){
            maze[p.getX()][p.getY()] = 3;
            p = mark[p.getX()][p.getY()];
        }
        maze[p.getX()][p.getY()] = 3;

        StringBuffer stringBuffer = new StringBuffer();
        for(int i=0;i<maze.length;i++) {
            for (int j = 0; j < maze[0].length; j++) {
                stringBuffer.append(maze[i][j]);
            }
            stringBuffer.append("\r\n");
        }

        return stringBuffer.toString();
    }
```

{% note info %} 

## **测试代码**

 {% endnote %}

```java
package lab3.Maze;

import org.junit.Assert;
import org.junit.Test;

import static org.junit.Assert.*;

/**
 * @author AyagiKei
 * @url https://github.com/Ayagikei
 **/
public class MazeSolveTest {

    @Test
    public void solveByStack() {
        int maze[][] = {
                {0,1,0,0,0,1},
                {0,0,0,1,0,1},
                {1,0,1,0,0,1},
                {0,0,0,1,1,1},
                {0,1,1,0,0,0},
                {0,0,0,0,1,1}
        };

        System.out.println(MazeSolve.solveByStack(maze,new Point(0,0),new Point(4,5)));

        int maze2[][] = {
                {0,1,0,0,0,1},
                {0,0,0,1,0,1},
                {1,1,1,0,0,1},
                {0,0,0,1,0,1},
                {0,1,1,0,0,0},
                {0,0,0,0,1,1}
        };
        System.out.println(MazeSolve.solveByStack(maze2,new Point(0,0),new Point(4,5)));

    }

    @Test
    public void solveByQueue() {
        int maze[][] = {
                {0,1,0,0,0,1},
                {0,0,0,1,0,1},
                {1,0,1,0,0,1},
                {0,0,0,1,1,1},
                {0,1,1,0,0,0},
                {0,0,0,0,1,1}
        };

        System.out.println(MazeSolve.solveByQueue(maze,new Point(0,0),new Point(4,5)));

        int maze2[][] = {
            {0,1,0,0,0,1},
            {0,0,0,1,0,1},
            {1,1,1,0,0,1},
            {0,0,0,1,0,1},
            {0,1,1,0,0,0},
            {0,0,0,0,1,1}
        };
        System.out.println(MazeSolve.solveByQueue(maze2,new Point(0,0),new Point(4,5)));


    }
}
```

{% note info %} 

## **参考文章**

 {% endnote %}

https://blog.csdn.net/K346K346/article/details/51289478

https://blog.csdn.net/raphealguo/article/details/7523411
//pavel.stepanov@bmstu.ru
//годовой проэкт по инфе
//перемножение матриц
//добавление матриц смещения и поворота
//расширение на трёхмерное пространство
//функция с 3-D очками
//расширение на n-мерные пространства
program TopProject;
uses GraphABC;
type matrix = record
     matr:array[1..10,1..100] of real;
     x,y:integer;
     f:text;
     end;
     
type obj = record
     //файл матрицы
     //файл последовательности соединений
     m:matrix;
     p : record
     posled:array[1..2,1..100] of integer;
     f:text;
     n:integer;
     end;
     end;
     
type vector = array[1..3] of real;

var matrix2:matrix;
    povorot3DX, apovorot3DX, povorot3DY, apovorot3DY , povorot3DZ, apovorot3DZ :matrix;
    objects:array[1..100] of obj;
    selectobject:integer;
    numObjects:integer;
    MoveX,MoveY,MoveZ:integer;
    izmer:integer = 3;
    c:vector;//центр вращения
     
     
function mul(m1,m2:matrix):matrix;//++
//файл идёт от первой матрицы
     var m:matrix;
     begin
      m.f:=m1.f;
      m.x:=m2.x;
      m.y:=m1.y;
      for var x:= 1 to m.x do
      begin
        for var y:= 1 to m.y do
        begin
          for var e:= 1 to m.x do
          begin
            m.matr[x,y]+=(m1.matr[e,y]*m2.matr[x,e]);
          end;
        end;
      end;
     mul:=m;
     end;



procedure cout(m:matrix);//++
begin
  writeln;
  writeln(m.x,' ',m.y);
  for var i:= 1 to m.y do
  begin
    for var j:= 1 to m.x do
    begin
      write(m.matr[j,i],'; ');
    end;
    writeln;
  end;
  writeln;
end;

procedure printf(var tex:text; m:matrix);
begin
  rewrite(tex);
  writeln(tex,m.x,m.y);
  for var i:= 1 to m.y do
  begin
    for var j:= 1 to m.x do
    begin
      write(tex,m.matr[j,i],' ');
    end;
    writeln;
  end;
  close(tex);
end;

function scanf(m:matrix):matrix;//++

begin
  reset(m.f);
  readln(m.f,m.x,m.y);
  for var i:= 1 to m.y do
  begin
    for var j:= 1 to m.x do
    begin
      read(m.f,m.matr[j,i]);
    end;
      readln(m.f);
  end;
  close(m.f);
scanf:=m;
end;

function scanobject(o:obj):obj;//++
  var Ret:obj = o;
begin
  ret.m:=scanf(ret.m);
  reset(ret.p.f);
  readln(ret.p.f,ret.p.n);
  for var i:= 1 to ret.p.n do
  begin
    readln(ret.p.f,ret.p.posled[1,i],ret.p.posled[2,i]);
  end;
  close(ret.p.f);
  scanobject:=ret;
end;

procedure visual(o:obj);//+3
var x,y,x1,y1:real;
begin
  for var i:= 1 to o.p.n do
  begin
    for var j:= 1 to izmer do
    begin
      x:=(o.m.matr[1,o.p.posled[1,i]])+(4.6/9)*(o.m.matr[3,o.p.posled[1,i]]);
      y:=(o.m.matr[2,o.p.posled[1,i]])+(4.6/9)*(o.m.matr[3,o.p.posled[1,i]]);
      x1:=(o.m.matr[1,o.p.posled[2,i]])+(4.6/9)*(o.m.matr[3,o.p.posled[2,i]]);
      y1:=(o.m.matr[2,o.p.posled[2,i]])+(4.6/9)*(o.m.matr[3,o.p.posled[2,i]]);
      line(round(x),round(y),round(x1),round(y1));
    end;
  end;
end;

function plus(m:matrix;x:integer;p:real):matrix;//++
var matr:matrix = m;
begin
  for var i:= 1 to matr.y do
  begin
    (matr.matr[x,i])+=p;
  end;
  plus:=matr;
end;


function av(m:matrix):vector;//++
var
a:vector;
begin
  for var i:= 1 to m.y do
  begin
    for var j:= 1 to izmer do
    begin
      a[j]+=m.matr[j,i];
    end;
  end;
  for var j:= 1 to izmer do
    begin
      a[j]/=m.y;
    end;
  av:=a;
end;

procedure KeyDown(Key:integer);
var dopmatrix:matrix;
begin
  //write('KEY');
  case Key of
  VK_Left://x-1
  begin
    for var i:= 1 to (objects[selectobject].m.y)do
    begin
      objects[selectobject].m.matr[1,i]-=MoveX;
    end;
    Window.Clear(clBlack);
    for var i:= 1 to numObjects do
      Visual(objects[1]);
  end;
  
  VK_Right://x-1
  begin
    for var i:= 1 to (objects[selectobject].m.y)do
    begin
      objects[selectobject].m.matr[1,i]+=MoveX;
    end;
    Window.Clear(clBlack);
    for var i:= 1 to numObjects do
      Visual(objects[1]);
  end;
  
  VK_Up://y-1
  begin
    for var i:= 1 to (objects[selectobject].m.y)do
    begin
      objects[selectobject].m.matr[2,i]-=MoveY;//+1
    end;
    Window.Clear(clBlack);
    for var i:= 1 to numObjects do
      Visual(objects[1]);
  end;
  
  VK_Down://y+1
  begin
    for var i:= 1 to (objects[selectobject].m.y)do
    begin
      objects[selectobject].m.matr[2,i]+=MoveY;//-1
    end;
    Window.Clear(clBlack);
    for var i:= 1 to numObjects do
      Visual(objects[1]);
  end;
  
  VK_Q:
  begin
    c:=av(objects[selectobject].m);
    dopmatrix:=objects[selectobject].m;
    for var i:= 1 to izmer do
    begin
      objects[selectobject].m:=plus(objects[selectobject].m,i,(-1)*c[i]);
    end;
    //вращение вокруг
    objects[selectobject].m:= mul(objects[selectobject].m,povorot3DX);//своего центра
    for var i:= 1 to izmer do
    begin
      objects[selectobject].m:=plus(objects[selectobject].m,i,c[i]);
    end;
    Window.Clear(clBlack);
    for var i:= 1 to numObjects do
      Visual(objects[1]);
  end;
  
  
  VK_W:
  begin
    c:=av(objects[selectobject].m);
    dopmatrix:=objects[selectobject].m;
    for var i:= 1 to izmer do
    begin
      objects[selectobject].m:=plus(objects[selectobject].m,i,(-1)*c[i]);
    end;
    //вращение вокруг
    objects[selectobject].m:= mul(objects[selectobject].m,apovorot3DX);//своего центра
    for var i:= 1 to izmer do
    begin
      objects[selectobject].m:=plus(objects[selectobject].m,i,c[i]);
    end;
    Window.Clear(clBlack);
    for var i:= 1 to numObjects do
      Visual(objects[1]);
  end;
  
  VK_A:
  begin
    c:=av(objects[selectobject].m);
    dopmatrix:=objects[selectobject].m;
    for var i:= 1 to izmer do
    begin
      objects[selectobject].m:=plus(objects[selectobject].m,i,(-1)*c[i]);
    end;
    //вращение вокруг
    objects[selectobject].m:= mul(objects[selectobject].m,povorot3DY);//своего центра
    for var i:= 1 to izmer do
    begin
      objects[selectobject].m:=plus(objects[selectobject].m,i,c[i]);
    end;
    Window.Clear(clBlack);
    for var i:= 1 to numObjects do
      Visual(objects[1]);
  end;
  
  VK_S:
  begin
    c:=av(objects[selectobject].m);
    dopmatrix:=objects[selectobject].m;
    for var i:= 1 to izmer do
    begin
      objects[selectobject].m:=plus(objects[selectobject].m,i,(-1)*c[i]);
    end;
    //вращение вокруг
    objects[selectobject].m:= mul(objects[selectobject].m,apovorot3DY);//своего центра
    for var i:= 1 to izmer do
    begin
      objects[selectobject].m:=plus(objects[selectobject].m,i,c[i]);
    end;
    Window.Clear(clBlack);
    for var i:= 1 to numObjects do
      Visual(objects[1]);
  end;
  
  VK_Z:
  begin
    c:=av(objects[selectobject].m);
    dopmatrix:=objects[selectobject].m;
    for var i:= 1 to izmer do
    begin
      objects[selectobject].m:=plus(objects[selectobject].m,i,(-1)*c[i]);
    end;
    //вращение вокруг
    objects[selectobject].m:= mul(objects[selectobject].m,povorot3DZ);//своего центра
    for var i:= 1 to izmer do
    begin
      objects[selectobject].m:=plus(objects[selectobject].m,i,c[i]);
    end;
    Window.Clear(clBlack);
    for var i:= 1 to numObjects do
      Visual(objects[1]);
  end;
  
  VK_X:
  begin
    c:=av(objects[selectobject].m);
    dopmatrix:=objects[selectobject].m;
    for var i:= 1 to izmer do
    begin
      objects[selectobject].m:=plus(objects[selectobject].m,i,(-1)*c[i]);
    end;
    //вращение вокруг
    objects[selectobject].m:= mul(objects[selectobject].m,apovorot3DZ);//своего центра
    for var i:= 1 to izmer do
    begin
      objects[selectobject].m:=plus(objects[selectobject].m,i,c[i]);
    end;
    Window.Clear(clBlack);
    for var i:= 1 to numObjects do
      Visual(objects[1]);
  end;
  
  end;
  
end;

function perspective(m:matrix):matrix;
begin
  {cam    -    0,0,0}
  
end;

begin
MoveX:=40;
MoveY:=40;
numObjects:=1;
SelectObject:=1;
OnKeyDown := KeyDown;
Window.Maximize;
Setpencolor(clWhite);
assign(objects[1].m.f,'matrix13D.txt');
assign(matrix2.f,'matrix23D.txt');
assign(objects[1].p.f,'posledovatelnost.txt');
assign(povorot3DX.f,'povorot3DX.txt');
assign(apovorot3DX.f,'apovorot3DX.txt');
assign(povorot3DY.f,'povorot3DY.txt');
assign(apovorot3DY.f,'apovorot3DY.txt');
assign(povorot3DZ.f,'povorot3DZ.txt');
assign(apovorot3DZ.f,'apovorot3DZ.txt');
povorot3DX:=scanf(povorot3DX);
apovorot3DX:=scanf(apovorot3DX);
povorot3DY:=scanf(povorot3DY);
apovorot3DY:=scanf(apovorot3DY);
povorot3DZ:=scanf(povorot3DZ);
apovorot3DZ:=scanf(apovorot3DZ);
objects[1]:=scanobject(objects[1]);
matrix2:=scanf(matrix2);

//writeln('o.m: ...');
//cout(object1.m); 

//cout(matrix1);
//cout(matrix2);

//objects[1].m:=mul(objects[1].m,matrix2);

//cout(objects[1].m);
//for var i:= 1 to izmer do
//write(av(objects[1].m)[i],'  ');

//cout(mul(objects[1].m,matrix2));
{for var i:= 1 to object1.p.n do
begin
line(round(object1.m.matr[1,object1.p.posled[1,i]]),round(object1.m.matr[2,object1.p.posled[1,i]])  ,  round(object1.m.matr[1,object1.p.posled[2,i]]),round(object1.m.matr[2,object1.p.posled[2,i]]));
end;}

visual(objects[1]);

end.
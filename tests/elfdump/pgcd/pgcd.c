#include<stdio.h>

int pgcd(int a,int b){
  if (a<0 || b<0){
    return 0;
  }
  else {
    while(a!=b){
      if(a>b){
        a-=b;
      }
      else{
        b-=a;
      }
    }
  }
  return a;
}

int main(void){
  int res;
  int a=1245;
  int b=45;
  res=pgcd(a,b);
  printf("pgcd(%d,%d)=%d\n",a,b,res);
}

#include<stdio.h>

int sumofint(int max){
  int sum=0;
  for(int i=1;i < max;i++){
    sum+=i;
  }
  return sum;
}

int main(void){
  int val=6;
  int res;
  res=sumofint(val);
  printf("sumofint(%d)=%d\n",val,res);
  return res;
}

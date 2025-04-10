/******************************************************************************

                            Online C Compiler.
                Code, Compile, Run and Debug C program online.
Write your code in this editor and press "Run" button to compile and execute it.

*******************************************************************************/

#include <stdio.h>
#define MAX 100
#include <math.h>
#include <stdbool.h>
#include <stdlib.h>
void input_array(int a[], int *n) {
    do {
        printf("\nEnter the length of the array: ");
        scanf("%d", n);
    }
    while (*n<1 || *n>100);
    
    printf("Enter the array: ");
    for (int i=0; i<*n; i++){
        scanf("%d", &a[i]);
    }
    
}
    
    
void output_array(int a[], int n) {
    printf("Array\n");
    for (int i=0; i<n; i++)
        printf ("%d ", a[i]);
}


void swap(int *x, int *y) {
    int c = *x;
    *x = *y;
    *y = c;
}
void sort_array(int a[], int n) {
    for (int i=0; i<n-1; i++) {
        for (int j=i+1; j<n; j++) {
            if (a[j]<a[i]) {
                swap(&a[j], &a[i]);
            }
        }
    }
}

bool check_old(int a[], int n) {
    for(int i=0; i<n; i++) {
        if(a[i]%2 == 0) {
            return 0;
        }
    }
    return 1;
}
int search_value(int a[], int n, int value) {
    int count = 0;
    for (int i = 0; i<n; i++){
        if (a[i] == value)
            count ++;
    }
    return count;
}

int insert_array(int a[], int *m, int i) {
    a[*m] = i;
    (*m) ++;
}

int is_prime(int n, int i) {
    if (i==1)
        return 1;
    if (n%i==0)
        return 0;
    return is_prime(n, i-1);
}
void check_prime(int a[], int n){
    int kk[MAX], m =0;
    for (int i =0; i< n; i++) {
        if (a[i] < 2)
            continue;
        else if (a[i]==2)
            insert_array(kk, &m, a[i]);
        else if(is_prime(a[i], (int)sqrt(a[i]))==1) 
            insert_array(kk, &m, a[i]);
    }
    output_array(kk, m);
    
}

int main (){
    int choice, n=0;
    int a[MAX];
    int value;
    
    
    do {
        printf("\nn######MENU######\n");
        printf("1. Input the array\n");
        printf("2. Output the array\n");
        printf("3. Printf out the array in descending order\n");
        printf("4. Check if all elements of the array are olf\n");
        printf("5. Search the value\n");
        printf("6. Displays elements that are prime numbers in the array");
        printf("\n7. Quit");
        printf("\n Enter the number you want to choose: ");
        scanf ("%d", &choice);
        switch (choice) {
            case 1: 
                input_array(a, &n);
                break;
            case 2:
                output_array(a, n);
                break;
            case 3: 
                sort_array(a, n);
                output_array(a, n);
                break;
            case 4:
                printf("All elements in the array are odd: ");
                check_old(a, n);
                printf(check_old(a, n)?"true":"false");
                break;
            case 5:
                printf("Enter the number of element x you want to search: ");
                scanf("%d", &value);
                printf("The number of element %d appears %d", value, search_value(a, n, value));
                break;
            case 6:
                printf("prime numbers: ");
                check_prime(a, n);
                break;
            case 7:
                printf("Are you sure you want to quit, enter 1 to confirm: ");
                int confirm;
                scanf("%d", &confirm);
                if (confirm==1) {
                    printf("Exit...");
                    exit(0);
                }
                break;
            default:
                printf("Try again");
                
        }
        
    }
    while(1);
    return 0;
}
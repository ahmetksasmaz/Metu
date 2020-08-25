#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

struct molecule {
  long int numerator;
  long int denominator;
  char side;
  char formula[400];
};

struct atom {
  long int inner_coefficients[20];
};

struct matrix{
  long int elements[20][20];
};

struct molecule molecules[20];

struct atom *atoms;

void atom_coefficients(int molecule_number , char *formula , char side){
  long int atom_stack[213][2];
  int atom_count = 0;
  int stack_count = 0;
  int stack_temp;
  char stack_coef_temp;
  char coefficient_temp[50];
  int coefficient_count = 0;
  int i;
  long int temp_coefficient = 0;
  unsigned char stack[400];

  for(;*formula;formula++){
    if(*formula >= 'A' && *formula <= 'Z'){
      formula++;
      if(*formula >= 'a' && *formula <= 'z'){
        stack[stack_count] = atom_count;
        atom_stack[atom_count][0] = (*formula - 'a' + 1)*26;
        atom_stack[atom_count][0] += (*--formula - 'A');
        atom_stack[atom_count][1] = side;
        formula++;
      }
      else{
        formula--;
        stack[stack_count] = atom_count;
        atom_stack[atom_count][0] = (*formula - 'A');
        atom_stack[atom_count][1] = side;
      }
      atom_count++;
      stack_count++;
    }
    else if(*formula >= 'a' && *formula <= 'z'){}
    else if(*formula == '('){
      stack[stack_count] = '(';
      stack_count++;
    }
    else if(*formula == ')'){
      coefficient_count = 0;
      temp_coefficient = 0;
      memset(coefficient_temp, 0, 50);
      for(i = 0;;i++){
        stack_coef_temp = *++formula;
        if(stack_coef_temp >= '0' && stack_coef_temp <= '9'){
          coefficient_temp[i] = stack_coef_temp;
          coefficient_count++;
        }
        else{
          break;
        }
      }
      formula--;
      formula--;
      for(i = 0; i < coefficient_count; i++){
        temp_coefficient += pow(10 , i)*(coefficient_temp[coefficient_count-i-1]-'0');
      }
      for(stack_temp = stack_count - 1; stack[stack_temp] != '('; stack_temp--){
        if(stack[stack_temp] != '*'){
          atom_stack[stack[stack_temp]][1] *= temp_coefficient;
        }
      }
      stack[stack_temp] = '*';
      stack[stack_count] = '*';
      stack_count++;
    }
    else{
      coefficient_count = 0;
      temp_coefficient = 0;
      memset(coefficient_temp, 0, 50);
      for(i = 0;;i++){
        stack_coef_temp = *formula++;
        if(stack_coef_temp >= '0' && stack_coef_temp <= '9'){
          coefficient_temp[i] = stack_coef_temp;
          coefficient_count++;
        }
        else{
          break;
        }
      }
      formula--;
      formula--;
      for(i = 0; i < coefficient_count; i++){
        temp_coefficient += pow(10 , i)*(coefficient_temp[coefficient_count-i-1]-'0');
      }
      atom_stack[stack[stack_count-1]][1] *= temp_coefficient;
    }
  }
  for(i = 0; i < atom_count; i++){
    atoms[atom_stack[i][0]].inner_coefficients[molecule_number] += atom_stack[i][1];
  }


}

int zero_row(struct atom atom){

  int i;

  for(i = 0; i < 20; i++){
    if(atom.inner_coefficients[i] != 0){return 0;}
  }

  return 1;

}

int multiplied_row(struct atom atom1 , struct atom atom2){
  int i;

  for(i = 0; i < 20; i++){
    if((!(atom1.inner_coefficients[i]) && atom2.inner_coefficients[i]) ||  (!(atom2.inner_coefficients[i]) && atom1.inner_coefficients[i])){
      return 0;
    }
    if(atom1.inner_coefficients[0]*atom2.inner_coefficients[i] != atom2.inner_coefficients[0]*atom1.inner_coefficients[i]){
      return 0;
    }
  }
  return 1;

}

int added_row(struct atom atom1 , struct atom atom2){
  int i;

  for(i = 0; i < 20; i++){
    if( (atom1.inner_coefficients[0] - atom2.inner_coefficients[0]) != (atom1.inner_coefficients[i] - atom2.inner_coefficients[i])){
      return 0;
    }
  }
  return 1;
}

int degree(struct atom atom){
  int i;
  for(i = 0; i < 20; i++){
    if(atom.inner_coefficients[i]){return i;}
  }
  return -1;
}

long int greatest_common_divisor(long int a , long int b){
  long int temp;
  if(a == 0 || b == 0){return 1;}
  if(a > b){
    if(a % b == 0){return b;}
    temp = b;
    b = a % b;
    a = temp;
    return greatest_common_divisor(a , b);
  }
  else if(a == b){
    return a;
  }
  else{
    if(b % a == 0){return a;}
    temp = a;
    a = b % a;
    b = temp;
    return greatest_common_divisor(a , b);
  }
}

long int absolute(long int x){
  if(x >= 0){return x;}
  else{return -x;}
}

int order(long int * row_index , int row_count){
  int i , j , order_degree_first , order_degree_second, order_temp;

  for(i = 0; i < row_count; i++){
    order_degree_first = degree(atoms[row_index[i]]);
    for(j = i+1; j < row_count; j++){
      order_degree_second = degree(atoms[row_index[j]]);
      if(order_degree_first > order_degree_second){
        order_temp = row_index[j];
        row_index[j] = row_index[i];
        row_index[i] = order_temp;
        break;
      }
    }
  }
  for(i = 0; i < row_count-1; i++){
    order_degree_first = degree(atoms[row_index[i]]);
    order_degree_second = degree(atoms[row_index[i+1]]);
    if(order_degree_first >= order_degree_second){
      return 1;
    }
  }
  return 0;
}

int main(){

  /* Reaction equation to molecules */
  char c , side_flag = 1 , row_flag;
  int molecule_counter = 0 , formula_counter = 0;

  int i , j , k , non_zero_count = 0 , non_equivalent_row_count = 0;

  int order_degree_first , order_degree_second;

  long int * non_zero_row_index = malloc(702 * sizeof(long int));
  long int * non_equivalent_row_index;
  long int * matrix_data;
  long int ** matrix;

  long int numerator_temp;
  long int numerator_sub_temp;
  long int denominator_temp;
  long int gcd;

  /* Allocate memory for atoms */

  atoms = malloc(702 * sizeof(struct atom));

  molecules[0].side = 1;

  while((c = getchar()) != EOF){ /* Get reaction equation */

    switch(c){
      case '\n': break; /* Get rid of new line */
      case ' ': break; /* Get rid of spaces */
      case '+': formula_counter = 0; molecule_counter++; molecules[molecule_counter].side = side_flag; break; /* Change molecule */
      case '-': break;
      case '>': formula_counter = 0; molecule_counter++; side_flag = -1; molecules[molecule_counter].side = side_flag; break; /* Change side */
      default: molecules[molecule_counter].formula[formula_counter] = c; formula_counter++; break; /* Write formula characters */
    }

  }

  for(i = 0; i <= molecule_counter; i++){
      atom_coefficients(i , &molecules[i].formula[0] , molecules[i].side);
  }

  /* Zero row control */

  for(i = 0; i < 702; i++){
    if(!zero_row(atoms[i])){ non_zero_row_index[non_zero_count] = i; non_zero_count++; }
  }

  non_equivalent_row_index = malloc(non_zero_count * sizeof(long int));

  /* Equivalent row control */

  for(i = 0; i < non_zero_count; i++){
    row_flag = 1;
    for(j = i+1; j < non_zero_count; j++){
      if(multiplied_row(atoms[non_zero_row_index[i]] , atoms[non_zero_row_index[j]]) || added_row(atoms[non_zero_row_index[i]] , atoms[non_zero_row_index[j]])){
        row_flag = 0; break;
      }
    }
    if(row_flag){non_equivalent_row_index[non_equivalent_row_count] = non_zero_row_index[i] ; non_equivalent_row_count++;}
  }


  /* Order upper triangular form */

  while(order(non_equivalent_row_index , non_equivalent_row_count)){

    /* Gaussian elimination */

    for(i = 0; i < non_equivalent_row_count; i++){
      order_degree_first = degree(atoms[non_equivalent_row_index[i]]);
      for(j = i+1; j < non_equivalent_row_count; j++){
        order_degree_second = degree(atoms[non_equivalent_row_index[j]]);
        if(order_degree_first == order_degree_second){
          for(k = order_degree_first+1; k < molecule_counter+1; k++){
            atoms[non_equivalent_row_index[j]].inner_coefficients[k] *= -atoms[non_equivalent_row_index[i]].inner_coefficients[order_degree_first];
            atoms[non_equivalent_row_index[j]].inner_coefficients[k] += atoms[non_equivalent_row_index[i]].inner_coefficients[k]*atoms[non_equivalent_row_index[j]].inner_coefficients[order_degree_first];
          }
          atoms[non_equivalent_row_index[j]].inner_coefficients[order_degree_first] = 0;
        }
      }
    }

    non_zero_count = 0;
    for(i = 0; i < non_equivalent_row_count; i++){
      if(!zero_row(atoms[non_equivalent_row_index[i]])){ non_equivalent_row_index[non_zero_count] = non_equivalent_row_index[i]; non_zero_count++; }
    }
    non_equivalent_row_count = non_zero_count;

  }

  matrix_data = malloc((molecule_counter+1) * (molecule_counter+2) * sizeof(long int));
  matrix = malloc((molecule_counter+1) * sizeof(void *));

  for(i = 0; i < molecule_counter+1; i++){
    matrix[i] = &matrix_data[i*(molecule_counter+1)];
  }

  /* Free values */


  for(i = 0; i < molecule_counter+1; i++){
    if(i == molecule_counter){
      matrix[i][i] = 1;
      matrix[i][molecule_counter+1] = 1;
    }
    else if(i != degree(atoms[non_equivalent_row_index[i]])){
      matrix[i][i] = 1;
      matrix[i][molecule_counter+1] = 1;
    }
    else{
      for(j = 0; j < molecule_counter+1; j++){
        matrix[i][j] = atoms[non_equivalent_row_index[i]].inner_coefficients[j];
      }
      matrix[i][j] = 0;
    }
  }

  /* Number decreasing */

  for(i = 0; i < molecule_counter+1; i++){
    gcd = absolute(matrix[i][i]);
    for(j = i+1; j < molecule_counter+2 ; j++){
      if(matrix[i][j]){gcd = greatest_common_divisor(absolute(gcd) , absolute(matrix[i][j]));}
    }
    for(j = 0; j < molecule_counter+2; j++){
      matrix[i][j] /= gcd;
    }
  }

  /* Back substitution */

  molecules[molecule_counter].numerator = matrix[molecule_counter][molecule_counter+1];
  molecules[molecule_counter].denominator = matrix[molecule_counter][molecule_counter];

  for(i = 1; i < molecule_counter+1; i++){

    /* Denominator calculation */

    denominator_temp = matrix[molecule_counter-i][molecule_counter-i];
    for(j = 0; j < i; j++){
      denominator_temp *= molecules[molecule_counter-j].denominator;
    }
    molecules[molecule_counter-i].denominator = denominator_temp;

    /* Numerator calculation */

    numerator_temp = matrix[molecule_counter-i][molecule_counter+1];
    for(j = 0; j < i; j++){
      numerator_temp *= molecules[molecule_counter-j].denominator;
    }
    for(j = 0; j < i; j++){
      numerator_sub_temp = matrix[molecule_counter-i][molecule_counter-j];
      for(k = 0; k < i; k++){
        if(j ==  k){
          numerator_sub_temp *= molecules[molecule_counter-k].numerator;
        }
        else{
          numerator_sub_temp *= molecules[molecule_counter-k].denominator;
        }
      }
      numerator_temp -= numerator_sub_temp;
    }
    molecules[molecule_counter-i].numerator = numerator_temp;

    gcd = greatest_common_divisor(absolute(molecules[molecule_counter-i].numerator) , absolute(molecules[molecule_counter-i].denominator));
    molecules[molecule_counter-i].numerator /= gcd;
    molecules[molecule_counter-i].denominator /= gcd;
  }

  for(i = 0; i < molecule_counter+1; i++){
    for(j = 0; j < molecule_counter+1; j++ ){
      if(j != i){
        molecules[i].numerator *= molecules[j].denominator;
      }
    }
  }

  gcd = greatest_common_divisor(absolute(molecules[0].numerator) , absolute(molecules[1].numerator));

  for(i = 2; i < molecule_counter+1; i++){
    gcd = greatest_common_divisor(absolute(gcd) , absolute(molecules[i].numerator));
  }

  printf("%ld" , molecules[0].numerator/gcd);

  for(i = 1; i < molecule_counter+1; i++){
    printf(" %ld" , molecules[i].numerator/gcd);
  }

  free(atoms);
  free(non_zero_row_index);
  free(non_equivalent_row_index);
  free(matrix_data);
  free(matrix);

  return 0;

}

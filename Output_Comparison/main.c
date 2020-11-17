#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{

  FILE *fp_in1;
  FILE *fp_in2;


  int x,y;

  printf("Insert the name of the first result file under test : \n");

  scanf("%s",argv[1]);

    /// open files
  fp_in1 = fopen(argv[1], "r");
  if (fp_in1 == NULL)
  {
    printf("Error: cannot open file: %s \n",argv[1]);
    exit(2);
  }

  printf("Insert the name of the first result file under test : \n");

  scanf ("%s",argv[2]);
  fp_in2= fopen(argv[2], "r");
 if (fp_in2 == NULL)
  {
    printf("Error: cannot open file: %s \n",argv[2]);
    exit(2);
  }

  /// check the command line
  if (argc != 3)
  {
    printf("Use: three parameters \n");
    exit(1);
  }

fscanf(fp_in1, "%d", &x);
fscanf(fp_in2, "%d", &y);
int flag=0;
int i=0;
int displacement=0;
int max=0;
  do{
        i++;
        displacement=(y-x);
        if(displacement!=0)
        {
            if (max<=abs(displacement))
            {
                max=abs(displacement);
            }
            flag++;
            printf("Error in position %d ",i);
  printf("= %d\n",displacement);

        }
   fscanf(fp_in1, "%d", &x);
    fscanf(fp_in2, "%d", &y);

  } while (!feof(fp_in1));

printf("Max absolute displacement = %d", max);
  fclose(fp_in1);
    fclose(fp_in2);

  return 0;

}



#ifndef HIV_HEADER
#define HIV_HEADER
#define _GNU_SOURCE

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include <glib.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <assert.h>
#include <time.h>
#include <getopt.h>
#include <unistd.h>
#include <regex.h>
#include <getopt.h>


/* Bifurcating tree */
struct node {
  char * name;
  double branchLength;
  double time;
  struct node* left;  /* NULL if no children*/
  struct node* right; /* only viruses with no children are replicating */
  int mark;
  int  clv_index;

} ;
  
typedef struct list_item_s
{
  void * data;
  struct list_item_s * next;
} list_item_t;

typedef struct list_s
{
  list_item_t * head;
  list_item_t * tail;
  long count;
} list_t;

typedef struct mutation_s
{
  char state; 
  int site;
  double time; 
  struct node * node;
  
} mutation_t;

void printHelp();
bool FloatEquals(double a, double b, double threshold);
struct node* newNode(double branchLength);
int makeTree(struct node* node_ptr, char* treeString, int currChar);

int simulateDnaTree(struct node* node, int base, double instRate[4][4], const gsl_rng * r,
  char** alignment, int baseIndex, int nodeIndex, int * mutPresent, list_t * mutList);

int simulateDNABranch(int base, double instRate[4][4], struct node * , const gsl_rng * r, int* mutPresent, list_t * mutList, int site);
int countTips(struct node* node, int count);
void printAlignment(char** alignment, int numSeq, struct node** nodeOrder, char* outfile);
void printTree(struct node* root_ptr, char* fileName);
char* NewickStringBranchLength(struct node* node, char* treeString, double previousTime);
void clearTree(struct node* node_ptr);
void writeSeed(unsigned int RGSeed, char* outfile);
int* readFasta(char* fastaSeq, int* numBases);
int* setStartSeq (int* numBases, int randomStart, double statFreq[], char* fastaSeq, gsl_rng *r);
void setSeed(int RGSeed, gsl_rng *r, char* outfile);

void makeAlignment(struct node* root_ptr, int startSeq[], double instRate[4][4], char** alignment, struct node ** nodeOrder, int numBases, int numTips, gsl_rng *r, double mu);
void clearMemory(struct node* root_ptr, int numTips, struct node ** nodeOrder, char** alignment, char* treeString, gsl_rng *r);
char** allocateAlignmentMem(int numTips, int numBases);
void makeInstantaneousRate(double instRate[4][4], double statFreq[], double mu);
void checkInput(double statFreq[], double rateParams[], double mu);
void checkModelInput(int regMatch);

void printTreeNewNames(struct node* root_ptr, char *outfile);
char* treeNewNames(struct node* node, char* treeString, double previousTime);

void findLastSample(struct node* node, double* lastSample);
int findNodeOrder(struct node* node, struct node ** nodeOrder, int nodeNum); 

void list_clear(list_t * list, void (*cb_dealloc)(void *));
void list_append(list_t * list, void * data);

void mutation_dealloc(void * data);
int assign_CLV(struct node* node, int clv);

double setTimes(struct node* node);
#endif

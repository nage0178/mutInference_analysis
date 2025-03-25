#include "dna_sim.h"

#define DEF_LIST_APPEND   0
#define DEF_LIST_PREPEND  1

static int list_insert(list_t * list, void * data, int where)
{
  if (!list) return 0;

  /* create list item */
  list_item_t * item = (list_item_t *)malloc(sizeof(list_item_t));
  item->data = data;

  /* if list is empty */
  if (!(list->count))
  {
    list->head = list->tail = item;
    list->count = 1;
    item->next = NULL;
    return 1;
  }

  /* append */
  if (where == DEF_LIST_APPEND)
  {
    list->tail->next = item;
    list->tail = item;
    item->next = NULL;
    list->count++;
    return 1;
  }

  /* prepend */
  item->next = list->head;
  list->head = item;
  list->count++;

  return 1;
}

void list_append(list_t * list, void * data)
{
  list_insert(list, data, DEF_LIST_APPEND);
}

void mutation_dealloc(void * data)
{
  if (data)
  {
    mutation_t * mut = (mutation_t *)data;

    free(mut);
  }
}

void list_clear(list_t * list, void (*cb_dealloc)(void *))
{
  list_item_t * head = list->head;

  while (head)
  {
    list_item_t * temp = head;
    head = head->next;
    if (cb_dealloc)
      cb_dealloc(temp->data);
    free(temp);
  }

  list->head = list->tail = NULL;
  list->count = 0;
}


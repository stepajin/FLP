#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "limits.h"

#define max(a,b) (a >= b ? a : b)
#define min(a,b) (a <= b ? a : b)

int ** mallocGraph(int x, int y) {
	int ** array, i, j;
	array = (int **) malloc(x * sizeof(int *));

	for (i = 0; i < x; i++)
		array[i] = (int *) malloc(y * sizeof(int));

	for (i = 0; i < x; i++)
		for (j = 0; j < y; j++)
			array[i][j] = INT_MAX;

	return array;
}

void loadGraph(int ** graph, int S) {
	int i, c1, c2, noise;

	for (i = 0; i < S; i++) {
		scanf("%d %d %d", &c1, &c2, &noise);
		c1--; c2--; /* indexing from 1 */
		graph[c1][c2] = graph[c2][c1] = noise;
	}
}

void floydwarshall(int ** graph, int C) {
	int k , i, j;

	for (k = 0; k < C; k++)
		for (i = 0; i < C; i++)
			for (j = 0; j < C; j++)
				graph[i][j] = min(graph[i][j], max(graph[i][k], graph[k][j]));
}

void queries(int ** graph, int Q, int casenumber) {
	int i, from, to;

	if (casenumber > 1) 
		printf("\n");
	printf("Case #%d\n", casenumber);
		
	for (i = 0; i < Q; i++) {
		scanf("%d %d", &from, &to);
		from--; to--;

		if (graph[from][to] < INT_MAX) {
			printf("%d\n", graph[from][to]);
		} else {
			printf("no path\n");
		}
	}
}

int main() {
	int C, S, Q, i, casenumber = 0;

	while (++casenumber) {
		scanf("%d %d %d", &C, &S, &Q);
		if (C == 0)
			break;

		int ** graph = mallocGraph(C, C);
		loadGraph(graph, S);
		floydwarshall(graph, C);
		queries(graph, Q, casenumber);
	}

	return 0;
} 

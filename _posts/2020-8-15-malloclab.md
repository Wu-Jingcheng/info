# Malloclab

## Beforehand Statement

According to academic integrity policy presented on the course webpage:

I am subject to the following limits:

> **From Now and Into the Future:**
>
> As a general principle, you may not provide detailed help with an assignment to students this semester or in future semesters for any of the above-listed courses (unless you are serving as a teaching assistant or instructor for the course.) The following are clarifications about which forms of aid are authorized and which are not. Note that they apply to *all* of the above listed courses and *from now and into the indefinite future*.
>
> **Sharing:** You **may not** supply a copy of a file or document to an individual student or via a public channel, such as a blog post.
>
> **Providing access:** *You **may not** have any of your solution files in unprotected directories or in unprotected code repositories, either by putting files in an unprotected location or by allowing protections to lapse. Be sure to store your work in protected directories, and log off when you leave an open cluster, to prevent others from copying your work. If you make use of a code repository, such as Github, make sure your work is kept private, even after you have left CMU.*
>
> ***Coaching, Assisting, and Collaborating:*** You **may not** provide electronic, verbal, or written descriptions of code or other solution information.
>
> - You **may** clarify ambiguities or vague points in class handouts or textbooks.
> - You **may** help others use the computer systems, networks, compilers, debuggers, profilers, code libraries, and other system facilities.
> - You **may** discuss and provide general, strategic advice about an assignment. Providing anything more detailed than a brief description or a block diagram is not allowed. Providing any kind of code or pseudo-code is not allowed. Providing explicit directions on how to assemble allowed blocks of code is forbidden.
> - You **may** provide suggestions of potential bugs based on high-level symptoms. Code-based debugging assistance is forbidden.

Therefore, this page would only discuss the lab and my solution in a brief and a rather vague way.

## Overview

**The overall size of the script we are working on eventually goes up to ~1170 lines**

Malloclab can be divided into to 2 subtasks, which are marked as the checkpoint and the final. The basic idea is: we need to design allocators that have good enough performance in both utilizations and throughput. The full-score benchmarks for the checkpoint and the final are listed as follows:

| Phase      | Utilizations | Throughput |
| ---------- | ------------ | ---------- |
| Checkpoint | 58%          | 80%        |
| Final      | 74%          | 90%        |

A starter code, which has all implementations aside from block coalescing to realize an implicit free list allocator, is given. Basically, our task is to make it into an explicit free list allocator and then a segregated free list allocator to survive the checkpoint. Based on the checkpoint result, we are supposed to make some improvements to increase utilizations while maintaining a relatively high thru.

Anyway, I survived. And there are some funny points.

At the checkpoint, actually I didn't have full scores because of relatively low util, which is abnormal. After the checkpoint (ends up with 91.4 scores), I carefully looked into the code and debugged with a method named mm_checkheap(__LINE__), which is a heap checker to spot inconsistensies within the heap from different levels. My observation was that the free block counts from heap traversal and free lists are not matched. Eventually, I found out that the cause is that I set a improper if statement for mm_init(). My preliminary design is: mm_init() called when all list roots are null, which means free lists are empty. However, it is possible that a heap space has been intilized but run out of and left empty free lists. Hence, the init method is overly used and prologue/epilogue take up some space and lowers util.

At the final, there are more stories.

To earn full scores in the final, we are supposed to realize following strategies step by step.

1. Eliminate footers of allocated block.
2. Decrease min block size from 32 to 16 bytes. To do so, we need to eliminate prev field and footer in 16-byte blocks.
3. (Optional) Compress headers. Actually after step 2, we are almost there and thereby can use fine tune to achieve it. In my case, I fine tuned the find fit strategy from first fit to better fit and expanded the extendsize each we request new heap space over chunksize (more precisely, 5*allocated_size).

Things above altogether win full scores in the final.

Some hints: cgdb, heap checker and beforehand careful design are important.

Some funny things:

When I eliminated the footers, found out that always garbled bytes error while reallocing. Turned out that adjustment in get_payload_size is missed out and the offset of the eliminated footer size wasn't counted during the calculatioin and overwrote bytes in other blocks.

One stupid thing is: when I removed block footers for the first time, I removed all despite the size classes, which led to ~700 KOP thru.

The basic design can be demonstrated by my file header comment:

> - @file mm.c A heap space allocator.
> - @brief A 64-bit struct-based segregated free list memory allocator
> - 
> - 15-213: Introduction to Computer Systems
> - 
> - This allocator is the malloclab result in 15513.
> - 
> - The heap space is maintained mainly by a block-oriented strategy. The space
> - is divided into blocks and their sizes, allocation status and the like are
> - encoded in their header/footer.
> - 
> - The allocator implements a segregated free list. It has an array of 16
> - pointers to free blocks. The 15 in front are roots of different size classes.
> - The last is the tail of the 16-byte class.
> - 
> - For finding fit blocks strategy, it utilizes a `better` fit algorithm. The
> - numbers of suitable blocks under scrutiny is confined by the const
> - `max_find`, which is 3 when I handed in.
> - 
> - In each free list, block placements follow address ordered principle.
> - 
> - One interesting design is that when we request heap extension size that is
> - beyond the chunksize, the allocator makes the demand size quintuple to reduce
> - future extension operations.
> - 
> - Have fun!

## Dummy writeup (Readers may ignore, serves for personal use)

The whole writeup is given in a very ambiguous way. Therefore, the primary thing to do is to figure out what are our real tasks. For checkpoint, our handin is graded by:

1. **Autograding**: We are supposed to reach beyond 58% ratio in utilization and 80% in throughput to win all autograding scores at the checkpoint phase.
2. **Heap Checker**: This is primarily graded with the function **mm_checkheap**, which is used to check the consistency of the heap.

### Some important concepts that are not covered in lectures

- Chunk and chunk_size: chunk is a memory space and chunk size if predefined, by which we extend the heap space.
- Prologue footer and epilogue header: they are to pad the current chunk and the next chunk so that the blocks inside the chunks are able to be 16-byte aligned.

### Checkpoint

Grading is based on the autograding of the allocator overhead vs. standard one and heap checker.

### Final

...
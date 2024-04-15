
_mlfq_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
  while (wait() != -1);
}

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  int count[MAX_LEVEL] = {0};
  13:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  1a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  21:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  28:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  2f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

  parent = getpid();
  36:	e8 58 07 00 00       	call   793 <getpid>

  printf(1,"MLFQ test start\n");
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	68 0a 0c 00 00       	push   $0xc0a
  43:	6a 01                	push   $0x1
  parent = getpid();
  45:	a3 c0 10 00 00       	mov    %eax,0x10c0
  printf(1,"MLFQ test start\n");
  4a:	e8 61 08 00 00       	call   8b0 <printf>

  printf(1, "[Test 1] default\n");
  4f:	5e                   	pop    %esi
  50:	58                   	pop    %eax
  51:	68 1b 0c 00 00       	push   $0xc1b
  56:	6a 01                	push   $0x1
  58:	e8 53 08 00 00       	call   8b0 <printf>
  pid = fork_children();
  5d:	e8 ce 02 00 00       	call   330 <fork_children>

  if (pid != parent)
  62:	83 c4 10             	add    $0x10,%esp
  65:	39 05 c0 10 00 00    	cmp    %eax,0x10c0
  6b:	74 7d                	je     ea <main+0xea>
  6d:	89 c6                	mov    %eax,%esi
  6f:	bb a0 86 01 00       	mov    $0x186a0,%ebx
  74:	eb 1c                	jmp    92 <main+0x92>
  76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  7d:	8d 76 00             	lea    0x0(%esi),%esi
    for (i = 0; i < NUM_LOOP; i++)
    {
      int x = getlev();
      if (x < 0 || x > 3)
      {
	      if(x != 99){
  80:	83 f8 63             	cmp    $0x63,%eax
  83:	0f 85 c7 00 00 00    	jne    150 <main+0x150>
          printf(1, "Wrong level: %d\n", x);
          exit();
	      } 
      }
      if(x == 99) count[4]++;
  89:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    for (i = 0; i < NUM_LOOP; i++)
  8d:	83 eb 01             	sub    $0x1,%ebx
  90:	74 14                	je     a6 <main+0xa6>
      int x = getlev();
  92:	e8 3c 07 00 00       	call   7d3 <getlev>
      if (x < 0 || x > 3)
  97:	83 f8 03             	cmp    $0x3,%eax
  9a:	77 e4                	ja     80 <main+0x80>
      else count[x]++;
  9c:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
    for (i = 0; i < NUM_LOOP; i++)
  a1:	83 eb 01             	sub    $0x1,%ebx
  a4:	75 ec                	jne    92 <main+0x92>
    }
    printf(1, "Process %d\n", pid);
  a6:	53                   	push   %ebx
    for (i = 0; i < MAX_LEVEL - 1; i++)
  a7:	31 db                	xor    %ebx,%ebx
    printf(1, "Process %d\n", pid);
  a9:	56                   	push   %esi
  aa:	8d 75 d4             	lea    -0x2c(%ebp),%esi
  ad:	68 3e 0c 00 00       	push   $0xc3e
  b2:	6a 01                	push   $0x1
  b4:	e8 f7 07 00 00       	call   8b0 <printf>
  b9:	83 c4 10             	add    $0x10,%esp
      printf(1, "L%d: %d\n", i, count[i]);
  bc:	ff 34 9e             	push   (%esi,%ebx,4)
  bf:	53                   	push   %ebx
    for (i = 0; i < MAX_LEVEL - 1; i++)
  c0:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n", i, count[i]);
  c3:	68 4a 0c 00 00       	push   $0xc4a
  c8:	6a 01                	push   $0x1
  ca:	e8 e1 07 00 00       	call   8b0 <printf>
    for (i = 0; i < MAX_LEVEL - 1; i++)
  cf:	83 c4 10             	add    $0x10,%esp
  d2:	83 fb 04             	cmp    $0x4,%ebx
  d5:	75 e5                	jne    bc <main+0xbc>
    printf(1, "MoQ: %d\n", count[4]);
  d7:	51                   	push   %ecx
  d8:	ff 75 e4             	push   -0x1c(%ebp)
  db:	68 53 0c 00 00       	push   $0xc53
  e0:	6a 01                	push   $0x1
  e2:	e8 c9 07 00 00       	call   8b0 <printf>
  e7:	83 c4 10             	add    $0x10,%esp
  }
  exit_children();
  ea:	e8 a1 03 00 00       	call   490 <exit_children>
  printf(1, "[Test 1] finished\n");
  ef:	56                   	push   %esi
  f0:	56                   	push   %esi
  f1:	68 5c 0c 00 00       	push   $0xc5c
  f6:	6a 01                	push   $0x1
  f8:	e8 b3 07 00 00       	call   8b0 <printf>

  printf(1, "[Test 2] priorities\n");
  fd:	58                   	pop    %eax
  fe:	5a                   	pop    %edx
  ff:	68 6f 0c 00 00       	push   $0xc6f
 104:	6a 01                	push   $0x1
 106:	e8 a5 07 00 00       	call   8b0 <printf>
  pid = fork_children2();
 10b:	e8 70 02 00 00       	call   380 <fork_children2>

  if (pid != parent)
 110:	83 c4 10             	add    $0x10,%esp
  pid = fork_children2();
 113:	89 c6                	mov    %eax,%esi
  if (pid != parent)
 115:	39 05 c0 10 00 00    	cmp    %eax,0x10c0
 11b:	0f 84 88 00 00 00    	je     1a9 <main+0x1a9>
 121:	bb a0 86 01 00       	mov    $0x186a0,%ebx
 126:	eb 16                	jmp    13e <main+0x13e>
 128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12f:	90                   	nop
    for (i = 0; i < NUM_LOOP; i++)
    {
      int x = getlev();
      if (x < 0 || x > 3)
      {
	if(x != 99){
 130:	83 f8 63             	cmp    $0x63,%eax
 133:	75 1b                	jne    150 <main+0x150>
          printf(1, "Wrong level: %d\n", x);
          exit();
	}
      }
      if(x == 99) count[4]++;
 135:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    for (i = 0; i < NUM_LOOP; i++)
 139:	83 eb 01             	sub    $0x1,%ebx
 13c:	74 27                	je     165 <main+0x165>
      int x = getlev();
 13e:	e8 90 06 00 00       	call   7d3 <getlev>
      if (x < 0 || x > 3)
 143:	83 f8 03             	cmp    $0x3,%eax
 146:	77 e8                	ja     130 <main+0x130>
      else count[x]++;
 148:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
 14d:	eb ea                	jmp    139 <main+0x139>
 14f:	90                   	nop
      int x = getlev();
      if(x < 0 || x > 3)
      {
        if(x != 99)
        {
	  printf(1, "Wrong level: %d\n", x);
 150:	83 ec 04             	sub    $0x4,%esp
 153:	50                   	push   %eax
 154:	68 2d 0c 00 00       	push   $0xc2d
 159:	6a 01                	push   $0x1
 15b:	e8 50 07 00 00       	call   8b0 <printf>
	  exit();
 160:	e8 ae 05 00 00       	call   713 <exit>
    printf(1, "Process %d\n", pid);
 165:	53                   	push   %ebx
    for (i = 0; i < MAX_LEVEL - 1; i++)
 166:	31 db                	xor    %ebx,%ebx
    printf(1, "Process %d\n", pid);
 168:	56                   	push   %esi
 169:	8d 75 d4             	lea    -0x2c(%ebp),%esi
 16c:	68 3e 0c 00 00       	push   $0xc3e
 171:	6a 01                	push   $0x1
 173:	e8 38 07 00 00       	call   8b0 <printf>
 178:	83 c4 10             	add    $0x10,%esp
      printf(1, "L%d: %d\n", i, count[i]);
 17b:	ff 34 9e             	push   (%esi,%ebx,4)
 17e:	53                   	push   %ebx
    for (i = 0; i < MAX_LEVEL - 1; i++)
 17f:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n", i, count[i]);
 182:	68 4a 0c 00 00       	push   $0xc4a
 187:	6a 01                	push   $0x1
 189:	e8 22 07 00 00       	call   8b0 <printf>
    for (i = 0; i < MAX_LEVEL - 1; i++)
 18e:	83 c4 10             	add    $0x10,%esp
 191:	83 fb 04             	cmp    $0x4,%ebx
 194:	75 e5                	jne    17b <main+0x17b>
    printf(1, "MoQ: %d\n", count[4]);
 196:	51                   	push   %ecx
 197:	ff 75 e4             	push   -0x1c(%ebp)
 19a:	68 53 0c 00 00       	push   $0xc53
 19f:	6a 01                	push   $0x1
 1a1:	e8 0a 07 00 00       	call   8b0 <printf>
 1a6:	83 c4 10             	add    $0x10,%esp
  exit_children();
 1a9:	e8 e2 02 00 00       	call   490 <exit_children>
  printf(1, "[Test 2] finished\n");
 1ae:	50                   	push   %eax
 1af:	50                   	push   %eax
 1b0:	68 84 0c 00 00       	push   $0xc84
 1b5:	6a 01                	push   $0x1
 1b7:	e8 f4 06 00 00       	call   8b0 <printf>
  printf(1, "[Test 3] sleep\n");
 1bc:	58                   	pop    %eax
 1bd:	5a                   	pop    %edx
 1be:	68 97 0c 00 00       	push   $0xc97
 1c3:	6a 01                	push   $0x1
 1c5:	e8 e6 06 00 00       	call   8b0 <printf>
  pid = fork_children2();
 1ca:	e8 b1 01 00 00       	call   380 <fork_children2>
  if (pid != parent)
 1cf:	83 c4 10             	add    $0x10,%esp
  pid = fork_children2();
 1d2:	89 c6                	mov    %eax,%esi
  if (pid != parent)
 1d4:	39 05 c0 10 00 00    	cmp    %eax,0x10c0
 1da:	0f 84 84 00 00 00    	je     264 <main+0x264>
 1e0:	bb f4 01 00 00       	mov    $0x1f4,%ebx
 1e5:	eb 28                	jmp    20f <main+0x20f>
 1e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ee:	66 90                	xchg   %ax,%ax
	if(x != 99){
 1f0:	83 f8 63             	cmp    $0x63,%eax
 1f3:	0f 85 57 ff ff ff    	jne    150 <main+0x150>
      if(x == 99) count[4]++;
 1f9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
      sleep(1);
 1fd:	83 ec 0c             	sub    $0xc,%esp
 200:	6a 01                	push   $0x1
 202:	e8 9c 05 00 00       	call   7a3 <sleep>
    for (i = 0; i < NUM_SLEEP; i++)
 207:	83 c4 10             	add    $0x10,%esp
 20a:	83 eb 01             	sub    $0x1,%ebx
 20d:	74 11                	je     220 <main+0x220>
      int x = getlev();
 20f:	e8 bf 05 00 00       	call   7d3 <getlev>
      if (x < 0 || x > 3)
 214:	83 f8 03             	cmp    $0x3,%eax
 217:	77 d7                	ja     1f0 <main+0x1f0>
      else count[x]++;
 219:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
 21e:	eb dd                	jmp    1fd <main+0x1fd>
    printf(1, "Process %d\n", pid);
 220:	50                   	push   %eax
    for (i = 0; i < MAX_LEVEL - 1; i++)
 221:	31 db                	xor    %ebx,%ebx
    printf(1, "Process %d\n", pid);
 223:	56                   	push   %esi
 224:	8d 75 d4             	lea    -0x2c(%ebp),%esi
 227:	68 3e 0c 00 00       	push   $0xc3e
 22c:	6a 01                	push   $0x1
 22e:	e8 7d 06 00 00       	call   8b0 <printf>
 233:	83 c4 10             	add    $0x10,%esp
      printf(1, "L%d: %d\n", i, count[i]);
 236:	ff 34 9e             	push   (%esi,%ebx,4)
 239:	53                   	push   %ebx
    for (i = 0; i < MAX_LEVEL - 1; i++)
 23a:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n", i, count[i]);
 23d:	68 4a 0c 00 00       	push   $0xc4a
 242:	6a 01                	push   $0x1
 244:	e8 67 06 00 00       	call   8b0 <printf>
    for (i = 0; i < MAX_LEVEL - 1; i++)
 249:	83 c4 10             	add    $0x10,%esp
 24c:	83 fb 04             	cmp    $0x4,%ebx
 24f:	75 e5                	jne    236 <main+0x236>
    printf(1, "MoQ: %d\n", count[4]);
 251:	50                   	push   %eax
 252:	ff 75 e4             	push   -0x1c(%ebp)
 255:	68 53 0c 00 00       	push   $0xc53
 25a:	6a 01                	push   $0x1
 25c:	e8 4f 06 00 00       	call   8b0 <printf>
 261:	83 c4 10             	add    $0x10,%esp
  exit_children();
 264:	e8 27 02 00 00       	call   490 <exit_children>
  printf(1, "[Test 3] finished\n");
 269:	53                   	push   %ebx
 26a:	53                   	push   %ebx
 26b:	68 a7 0c 00 00       	push   $0xca7
 270:	6a 01                	push   $0x1
 272:	e8 39 06 00 00       	call   8b0 <printf>
  printf(1, "[Test 4] MoQ\n");
 277:	5e                   	pop    %esi
 278:	58                   	pop    %eax
 279:	68 ba 0c 00 00       	push   $0xcba
 27e:	6a 01                	push   $0x1
 280:	e8 2b 06 00 00       	call   8b0 <printf>
  pid = fork_children3();
 285:	e8 66 01 00 00       	call   3f0 <fork_children3>
  if(pid != parent)
 28a:	83 c4 10             	add    $0x10,%esp
  pid = fork_children3();
 28d:	89 c6                	mov    %eax,%esi
  if(pid != parent)
 28f:	39 05 c0 10 00 00    	cmp    %eax,0x10c0
 295:	74 7b                	je     312 <main+0x312>
    if(pid == 36)
 297:	bb a0 86 01 00       	mov    $0x186a0,%ebx
 29c:	83 f8 24             	cmp    $0x24,%eax
 29f:	75 1c                	jne    2bd <main+0x2bd>
      monopolize();
 2a1:	e8 45 05 00 00       	call   7eb <monopolize>
      exit();
 2a6:	e8 68 04 00 00       	call   713 <exit>
        if(x != 99)
 2ab:	83 f8 63             	cmp    $0x63,%eax
 2ae:	0f 85 9c fe ff ff    	jne    150 <main+0x150>
	}
      }
      if(x == 99) count[4]++;
 2b4:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    for(i = 0; i < NUM_LOOP; i++)
 2b8:	83 eb 01             	sub    $0x1,%ebx
 2bb:	74 11                	je     2ce <main+0x2ce>
      int x = getlev();
 2bd:	e8 11 05 00 00       	call   7d3 <getlev>
      if(x < 0 || x > 3)
 2c2:	83 f8 03             	cmp    $0x3,%eax
 2c5:	77 e4                	ja     2ab <main+0x2ab>
      else count[x]++;
 2c7:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
 2cc:	eb ea                	jmp    2b8 <main+0x2b8>
    }
    printf(1, "Process %d\n", pid);
 2ce:	51                   	push   %ecx
    for(i = 0; i < MAX_LEVEL - 1; i++)
 2cf:	31 db                	xor    %ebx,%ebx
    printf(1, "Process %d\n", pid);
 2d1:	56                   	push   %esi
 2d2:	8d 75 d4             	lea    -0x2c(%ebp),%esi
 2d5:	68 3e 0c 00 00       	push   $0xc3e
 2da:	6a 01                	push   $0x1
 2dc:	e8 cf 05 00 00       	call   8b0 <printf>
 2e1:	83 c4 10             	add    $0x10,%esp
      printf(1, "L%d: %d\n",i,count[i]);
 2e4:	ff 34 9e             	push   (%esi,%ebx,4)
 2e7:	53                   	push   %ebx
    for(i = 0; i < MAX_LEVEL - 1; i++)
 2e8:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n",i,count[i]);
 2eb:	68 4a 0c 00 00       	push   $0xc4a
 2f0:	6a 01                	push   $0x1
 2f2:	e8 b9 05 00 00       	call   8b0 <printf>
    for(i = 0; i < MAX_LEVEL - 1; i++)
 2f7:	83 c4 10             	add    $0x10,%esp
 2fa:	83 fb 04             	cmp    $0x4,%ebx
 2fd:	75 e5                	jne    2e4 <main+0x2e4>
    printf(1, "MoQ: %d\n", count[i]);
 2ff:	52                   	push   %edx
 300:	ff 75 e4             	push   -0x1c(%ebp)
 303:	68 53 0c 00 00       	push   $0xc53
 308:	6a 01                	push   $0x1
 30a:	e8 a1 05 00 00       	call   8b0 <printf>
 30f:	83 c4 10             	add    $0x10,%esp
  }
  exit_children();
 312:	e8 79 01 00 00       	call   490 <exit_children>
  printf(1, "[Test 4] finished\n");
 317:	50                   	push   %eax
 318:	50                   	push   %eax
 319:	68 c8 0c 00 00       	push   $0xcc8
 31e:	6a 01                	push   $0x1
 320:	e8 8b 05 00 00       	call   8b0 <printf>

  exit();
 325:	e8 e9 03 00 00       	call   713 <exit>
 32a:	66 90                	xchg   %ax,%ax
 32c:	66 90                	xchg   %ax,%ax
 32e:	66 90                	xchg   %ax,%ax

00000330 <fork_children>:
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	53                   	push   %ebx
 334:	bb 08 00 00 00       	mov    $0x8,%ebx
 339:	83 ec 04             	sub    $0x4,%esp
 33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if ((p = fork()) == 0)
 340:	e8 c6 03 00 00       	call   70b <fork>
 345:	85 c0                	test   %eax,%eax
 347:	74 17                	je     360 <fork_children+0x30>
  for (i = 0; i < NUM_THREAD; i++)
 349:	83 eb 01             	sub    $0x1,%ebx
 34c:	75 f2                	jne    340 <fork_children+0x10>
}
 34e:	a1 c0 10 00 00       	mov    0x10c0,%eax
 353:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 356:	c9                   	leave  
 357:	c3                   	ret    
 358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35f:	90                   	nop
      sleep(10);
 360:	83 ec 0c             	sub    $0xc,%esp
 363:	6a 0a                	push   $0xa
 365:	e8 39 04 00 00       	call   7a3 <sleep>
}
 36a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return getpid();
 36d:	83 c4 10             	add    $0x10,%esp
}
 370:	c9                   	leave  
      return getpid();
 371:	e9 1d 04 00 00       	jmp    793 <getpid>
 376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 37d:	8d 76 00             	lea    0x0(%esi),%esi

00000380 <fork_children2>:
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++)
 384:	31 db                	xor    %ebx,%ebx
{
 386:	83 ec 04             	sub    $0x4,%esp
 389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if ((p = fork()) == 0)
 390:	e8 76 03 00 00       	call   70b <fork>
 395:	85 c0                	test   %eax,%eax
 397:	74 27                	je     3c0 <fork_children2+0x40>
      int r = setpriority(p, i + 1);
 399:	83 ec 08             	sub    $0x8,%esp
 39c:	83 c3 01             	add    $0x1,%ebx
 39f:	53                   	push   %ebx
 3a0:	50                   	push   %eax
 3a1:	e8 35 04 00 00       	call   7db <setpriority>
      if (r < 0)
 3a6:	83 c4 10             	add    $0x10,%esp
 3a9:	85 c0                	test   %eax,%eax
 3ab:	78 29                	js     3d6 <fork_children2+0x56>
  for (i = 0; i < NUM_THREAD; i++)
 3ad:	83 fb 08             	cmp    $0x8,%ebx
 3b0:	75 de                	jne    390 <fork_children2+0x10>
}
 3b2:	a1 c0 10 00 00       	mov    0x10c0,%eax
 3b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3ba:	c9                   	leave  
 3bb:	c3                   	ret    
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sleep(10);
 3c0:	83 ec 0c             	sub    $0xc,%esp
 3c3:	6a 0a                	push   $0xa
 3c5:	e8 d9 03 00 00       	call   7a3 <sleep>
}
 3ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return getpid();
 3cd:	83 c4 10             	add    $0x10,%esp
}
 3d0:	c9                   	leave  
      return getpid();
 3d1:	e9 bd 03 00 00       	jmp    793 <getpid>
        printf(1, "setpriority returned %d\n", r);
 3d6:	83 ec 04             	sub    $0x4,%esp
 3d9:	50                   	push   %eax
 3da:	68 d8 0b 00 00       	push   $0xbd8
 3df:	6a 01                	push   $0x1
 3e1:	e8 ca 04 00 00       	call   8b0 <printf>
        exit();
 3e6:	e8 28 03 00 00       	call   713 <exit>
 3eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3ef:	90                   	nop

000003f0 <fork_children3>:
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	56                   	push   %esi
 3f4:	53                   	push   %ebx
 3f5:	bb 09 00 00 00       	mov    $0x9,%ebx
 3fa:	eb 09                	jmp    405 <fork_children3+0x15>
 3fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0;i<=NUM_THREAD;i++){
 400:	83 eb 01             	sub    $0x1,%ebx
 403:	74 5b                	je     460 <fork_children3+0x70>
    if((p = fork()) == 0)
 405:	e8 01 03 00 00       	call   70b <fork>
 40a:	85 c0                	test   %eax,%eax
 40c:	74 62                	je     470 <fork_children3+0x80>
      if(p % 2 == 1)
 40e:	89 c1                	mov    %eax,%ecx
 410:	c1 e9 1f             	shr    $0x1f,%ecx
 413:	8d 14 08             	lea    (%eax,%ecx,1),%edx
 416:	83 e2 01             	and    $0x1,%edx
 419:	29 ca                	sub    %ecx,%edx
 41b:	83 fa 01             	cmp    $0x1,%edx
 41e:	75 e0                	jne    400 <fork_children3+0x10>
        r = setmonopoly(p, 2021064720); // input your student number
 420:	83 ec 08             	sub    $0x8,%esp
 423:	68 10 00 77 78       	push   $0x78770010
 428:	50                   	push   %eax
 429:	e8 b5 03 00 00       	call   7e3 <setmonopoly>
        printf(1, "Number of processes in MoQ: %d\n",r);
 42e:	83 c4 0c             	add    $0xc,%esp
 431:	50                   	push   %eax
        r = setmonopoly(p, 2021064720); // input your student number
 432:	89 c6                	mov    %eax,%esi
        printf(1, "Number of processes in MoQ: %d\n",r);
 434:	68 dc 0c 00 00       	push   $0xcdc
 439:	6a 01                	push   $0x1
 43b:	e8 70 04 00 00       	call   8b0 <printf>
      if(r < 0)
 440:	83 c4 10             	add    $0x10,%esp
 443:	85 f6                	test   %esi,%esi
 445:	79 b9                	jns    400 <fork_children3+0x10>
        printf(1, "setmonopoly returned %d\n", r);
 447:	50                   	push   %eax
 448:	56                   	push   %esi
 449:	68 f1 0b 00 00       	push   $0xbf1
 44e:	6a 01                	push   $0x1
 450:	e8 5b 04 00 00       	call   8b0 <printf>
        exit();
 455:	e8 b9 02 00 00       	call   713 <exit>
 45a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
 460:	a1 c0 10 00 00       	mov    0x10c0,%eax
 465:	8d 65 f8             	lea    -0x8(%ebp),%esp
 468:	5b                   	pop    %ebx
 469:	5e                   	pop    %esi
 46a:	5d                   	pop    %ebp
 46b:	c3                   	ret    
 46c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sleep(10);
 470:	83 ec 0c             	sub    $0xc,%esp
 473:	6a 0a                	push   $0xa
 475:	e8 29 03 00 00       	call   7a3 <sleep>
      return getpid();
 47a:	83 c4 10             	add    $0x10,%esp
}
 47d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 480:	5b                   	pop    %ebx
 481:	5e                   	pop    %esi
 482:	5d                   	pop    %ebp
      return getpid();
 483:	e9 0b 03 00 00       	jmp    793 <getpid>
 488:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 48f:	90                   	nop

00000490 <exit_children>:
{ 
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	83 ec 08             	sub    $0x8,%esp
  if (getpid() != parent){
 496:	e8 f8 02 00 00       	call   793 <getpid>
 49b:	3b 05 c0 10 00 00    	cmp    0x10c0,%eax
 4a1:	75 11                	jne    4b4 <exit_children+0x24>
 4a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4a7:	90                   	nop
  while (wait() != -1);
 4a8:	e8 6e 02 00 00       	call   71b <wait>
 4ad:	83 f8 ff             	cmp    $0xffffffff,%eax
 4b0:	75 f6                	jne    4a8 <exit_children+0x18>
}
 4b2:	c9                   	leave  
 4b3:	c3                   	ret    
    exit();
 4b4:	e8 5a 02 00 00       	call   713 <exit>
 4b9:	66 90                	xchg   %ax,%ax
 4bb:	66 90                	xchg   %ax,%ax
 4bd:	66 90                	xchg   %ax,%ax
 4bf:	90                   	nop

000004c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 4c0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4c1:	31 c0                	xor    %eax,%eax
{
 4c3:	89 e5                	mov    %esp,%ebp
 4c5:	53                   	push   %ebx
 4c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 4cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 4d0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 4d4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 4d7:	83 c0 01             	add    $0x1,%eax
 4da:	84 d2                	test   %dl,%dl
 4dc:	75 f2                	jne    4d0 <strcpy+0x10>
    ;
  return os;
}
 4de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4e1:	89 c8                	mov    %ecx,%eax
 4e3:	c9                   	leave  
 4e4:	c3                   	ret    
 4e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	53                   	push   %ebx
 4f4:	8b 55 08             	mov    0x8(%ebp),%edx
 4f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 4fa:	0f b6 02             	movzbl (%edx),%eax
 4fd:	84 c0                	test   %al,%al
 4ff:	75 17                	jne    518 <strcmp+0x28>
 501:	eb 3a                	jmp    53d <strcmp+0x4d>
 503:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 507:	90                   	nop
 508:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 50c:	83 c2 01             	add    $0x1,%edx
 50f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 512:	84 c0                	test   %al,%al
 514:	74 1a                	je     530 <strcmp+0x40>
    p++, q++;
 516:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 518:	0f b6 19             	movzbl (%ecx),%ebx
 51b:	38 c3                	cmp    %al,%bl
 51d:	74 e9                	je     508 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 51f:	29 d8                	sub    %ebx,%eax
}
 521:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 524:	c9                   	leave  
 525:	c3                   	ret    
 526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 530:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 534:	31 c0                	xor    %eax,%eax
 536:	29 d8                	sub    %ebx,%eax
}
 538:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 53b:	c9                   	leave  
 53c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 53d:	0f b6 19             	movzbl (%ecx),%ebx
 540:	31 c0                	xor    %eax,%eax
 542:	eb db                	jmp    51f <strcmp+0x2f>
 544:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 54b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 54f:	90                   	nop

00000550 <strlen>:

uint
strlen(const char *s)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 556:	80 3a 00             	cmpb   $0x0,(%edx)
 559:	74 15                	je     570 <strlen+0x20>
 55b:	31 c0                	xor    %eax,%eax
 55d:	8d 76 00             	lea    0x0(%esi),%esi
 560:	83 c0 01             	add    $0x1,%eax
 563:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 567:	89 c1                	mov    %eax,%ecx
 569:	75 f5                	jne    560 <strlen+0x10>
    ;
  return n;
}
 56b:	89 c8                	mov    %ecx,%eax
 56d:	5d                   	pop    %ebp
 56e:	c3                   	ret    
 56f:	90                   	nop
  for(n = 0; s[n]; n++)
 570:	31 c9                	xor    %ecx,%ecx
}
 572:	5d                   	pop    %ebp
 573:	89 c8                	mov    %ecx,%eax
 575:	c3                   	ret    
 576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57d:	8d 76 00             	lea    0x0(%esi),%esi

00000580 <memset>:

void*
memset(void *dst, int c, uint n)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	57                   	push   %edi
 584:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 587:	8b 4d 10             	mov    0x10(%ebp),%ecx
 58a:	8b 45 0c             	mov    0xc(%ebp),%eax
 58d:	89 d7                	mov    %edx,%edi
 58f:	fc                   	cld    
 590:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 592:	8b 7d fc             	mov    -0x4(%ebp),%edi
 595:	89 d0                	mov    %edx,%eax
 597:	c9                   	leave  
 598:	c3                   	ret    
 599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005a0 <strchr>:

char*
strchr(const char *s, char c)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	8b 45 08             	mov    0x8(%ebp),%eax
 5a6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 5aa:	0f b6 10             	movzbl (%eax),%edx
 5ad:	84 d2                	test   %dl,%dl
 5af:	75 12                	jne    5c3 <strchr+0x23>
 5b1:	eb 1d                	jmp    5d0 <strchr+0x30>
 5b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5b7:	90                   	nop
 5b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 5bc:	83 c0 01             	add    $0x1,%eax
 5bf:	84 d2                	test   %dl,%dl
 5c1:	74 0d                	je     5d0 <strchr+0x30>
    if(*s == c)
 5c3:	38 d1                	cmp    %dl,%cl
 5c5:	75 f1                	jne    5b8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 5c7:	5d                   	pop    %ebp
 5c8:	c3                   	ret    
 5c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 5d0:	31 c0                	xor    %eax,%eax
}
 5d2:	5d                   	pop    %ebp
 5d3:	c3                   	ret    
 5d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5df:	90                   	nop

000005e0 <gets>:

char*
gets(char *buf, int max)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	57                   	push   %edi
 5e4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 5e5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 5e8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 5e9:	31 db                	xor    %ebx,%ebx
{
 5eb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 5ee:	eb 27                	jmp    617 <gets+0x37>
    cc = read(0, &c, 1);
 5f0:	83 ec 04             	sub    $0x4,%esp
 5f3:	6a 01                	push   $0x1
 5f5:	57                   	push   %edi
 5f6:	6a 00                	push   $0x0
 5f8:	e8 2e 01 00 00       	call   72b <read>
    if(cc < 1)
 5fd:	83 c4 10             	add    $0x10,%esp
 600:	85 c0                	test   %eax,%eax
 602:	7e 1d                	jle    621 <gets+0x41>
      break;
    buf[i++] = c;
 604:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 608:	8b 55 08             	mov    0x8(%ebp),%edx
 60b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 60f:	3c 0a                	cmp    $0xa,%al
 611:	74 1d                	je     630 <gets+0x50>
 613:	3c 0d                	cmp    $0xd,%al
 615:	74 19                	je     630 <gets+0x50>
  for(i=0; i+1 < max; ){
 617:	89 de                	mov    %ebx,%esi
 619:	83 c3 01             	add    $0x1,%ebx
 61c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 61f:	7c cf                	jl     5f0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 621:	8b 45 08             	mov    0x8(%ebp),%eax
 624:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 628:	8d 65 f4             	lea    -0xc(%ebp),%esp
 62b:	5b                   	pop    %ebx
 62c:	5e                   	pop    %esi
 62d:	5f                   	pop    %edi
 62e:	5d                   	pop    %ebp
 62f:	c3                   	ret    
  buf[i] = '\0';
 630:	8b 45 08             	mov    0x8(%ebp),%eax
 633:	89 de                	mov    %ebx,%esi
 635:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 639:	8d 65 f4             	lea    -0xc(%ebp),%esp
 63c:	5b                   	pop    %ebx
 63d:	5e                   	pop    %esi
 63e:	5f                   	pop    %edi
 63f:	5d                   	pop    %ebp
 640:	c3                   	ret    
 641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 64f:	90                   	nop

00000650 <stat>:

int
stat(const char *n, struct stat *st)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	56                   	push   %esi
 654:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 655:	83 ec 08             	sub    $0x8,%esp
 658:	6a 00                	push   $0x0
 65a:	ff 75 08             	push   0x8(%ebp)
 65d:	e8 f1 00 00 00       	call   753 <open>
  if(fd < 0)
 662:	83 c4 10             	add    $0x10,%esp
 665:	85 c0                	test   %eax,%eax
 667:	78 27                	js     690 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 669:	83 ec 08             	sub    $0x8,%esp
 66c:	ff 75 0c             	push   0xc(%ebp)
 66f:	89 c3                	mov    %eax,%ebx
 671:	50                   	push   %eax
 672:	e8 f4 00 00 00       	call   76b <fstat>
  close(fd);
 677:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 67a:	89 c6                	mov    %eax,%esi
  close(fd);
 67c:	e8 ba 00 00 00       	call   73b <close>
  return r;
 681:	83 c4 10             	add    $0x10,%esp
}
 684:	8d 65 f8             	lea    -0x8(%ebp),%esp
 687:	89 f0                	mov    %esi,%eax
 689:	5b                   	pop    %ebx
 68a:	5e                   	pop    %esi
 68b:	5d                   	pop    %ebp
 68c:	c3                   	ret    
 68d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 690:	be ff ff ff ff       	mov    $0xffffffff,%esi
 695:	eb ed                	jmp    684 <stat+0x34>
 697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 69e:	66 90                	xchg   %ax,%ax

000006a0 <atoi>:

int
atoi(const char *s)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	53                   	push   %ebx
 6a4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6a7:	0f be 02             	movsbl (%edx),%eax
 6aa:	8d 48 d0             	lea    -0x30(%eax),%ecx
 6ad:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 6b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 6b5:	77 1e                	ja     6d5 <atoi+0x35>
 6b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6be:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 6c0:	83 c2 01             	add    $0x1,%edx
 6c3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 6c6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 6ca:	0f be 02             	movsbl (%edx),%eax
 6cd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 6d0:	80 fb 09             	cmp    $0x9,%bl
 6d3:	76 eb                	jbe    6c0 <atoi+0x20>
  return n;
}
 6d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6d8:	89 c8                	mov    %ecx,%eax
 6da:	c9                   	leave  
 6db:	c3                   	ret    
 6dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	8b 45 10             	mov    0x10(%ebp),%eax
 6e7:	8b 55 08             	mov    0x8(%ebp),%edx
 6ea:	56                   	push   %esi
 6eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 6ee:	85 c0                	test   %eax,%eax
 6f0:	7e 13                	jle    705 <memmove+0x25>
 6f2:	01 d0                	add    %edx,%eax
  dst = vdst;
 6f4:	89 d7                	mov    %edx,%edi
 6f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 700:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 701:	39 f8                	cmp    %edi,%eax
 703:	75 fb                	jne    700 <memmove+0x20>
  return vdst;
}
 705:	5e                   	pop    %esi
 706:	89 d0                	mov    %edx,%eax
 708:	5f                   	pop    %edi
 709:	5d                   	pop    %ebp
 70a:	c3                   	ret    

0000070b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 70b:	b8 01 00 00 00       	mov    $0x1,%eax
 710:	cd 40                	int    $0x40
 712:	c3                   	ret    

00000713 <exit>:
SYSCALL(exit)
 713:	b8 02 00 00 00       	mov    $0x2,%eax
 718:	cd 40                	int    $0x40
 71a:	c3                   	ret    

0000071b <wait>:
SYSCALL(wait)
 71b:	b8 03 00 00 00       	mov    $0x3,%eax
 720:	cd 40                	int    $0x40
 722:	c3                   	ret    

00000723 <pipe>:
SYSCALL(pipe)
 723:	b8 04 00 00 00       	mov    $0x4,%eax
 728:	cd 40                	int    $0x40
 72a:	c3                   	ret    

0000072b <read>:
SYSCALL(read)
 72b:	b8 05 00 00 00       	mov    $0x5,%eax
 730:	cd 40                	int    $0x40
 732:	c3                   	ret    

00000733 <write>:
SYSCALL(write)
 733:	b8 10 00 00 00       	mov    $0x10,%eax
 738:	cd 40                	int    $0x40
 73a:	c3                   	ret    

0000073b <close>:
SYSCALL(close)
 73b:	b8 15 00 00 00       	mov    $0x15,%eax
 740:	cd 40                	int    $0x40
 742:	c3                   	ret    

00000743 <kill>:
SYSCALL(kill)
 743:	b8 06 00 00 00       	mov    $0x6,%eax
 748:	cd 40                	int    $0x40
 74a:	c3                   	ret    

0000074b <exec>:
SYSCALL(exec)
 74b:	b8 07 00 00 00       	mov    $0x7,%eax
 750:	cd 40                	int    $0x40
 752:	c3                   	ret    

00000753 <open>:
SYSCALL(open)
 753:	b8 0f 00 00 00       	mov    $0xf,%eax
 758:	cd 40                	int    $0x40
 75a:	c3                   	ret    

0000075b <mknod>:
SYSCALL(mknod)
 75b:	b8 11 00 00 00       	mov    $0x11,%eax
 760:	cd 40                	int    $0x40
 762:	c3                   	ret    

00000763 <unlink>:
SYSCALL(unlink)
 763:	b8 12 00 00 00       	mov    $0x12,%eax
 768:	cd 40                	int    $0x40
 76a:	c3                   	ret    

0000076b <fstat>:
SYSCALL(fstat)
 76b:	b8 08 00 00 00       	mov    $0x8,%eax
 770:	cd 40                	int    $0x40
 772:	c3                   	ret    

00000773 <link>:
SYSCALL(link)
 773:	b8 13 00 00 00       	mov    $0x13,%eax
 778:	cd 40                	int    $0x40
 77a:	c3                   	ret    

0000077b <mkdir>:
SYSCALL(mkdir)
 77b:	b8 14 00 00 00       	mov    $0x14,%eax
 780:	cd 40                	int    $0x40
 782:	c3                   	ret    

00000783 <chdir>:
SYSCALL(chdir)
 783:	b8 09 00 00 00       	mov    $0x9,%eax
 788:	cd 40                	int    $0x40
 78a:	c3                   	ret    

0000078b <dup>:
SYSCALL(dup)
 78b:	b8 0a 00 00 00       	mov    $0xa,%eax
 790:	cd 40                	int    $0x40
 792:	c3                   	ret    

00000793 <getpid>:
SYSCALL(getpid)
 793:	b8 0b 00 00 00       	mov    $0xb,%eax
 798:	cd 40                	int    $0x40
 79a:	c3                   	ret    

0000079b <sbrk>:
SYSCALL(sbrk)
 79b:	b8 0c 00 00 00       	mov    $0xc,%eax
 7a0:	cd 40                	int    $0x40
 7a2:	c3                   	ret    

000007a3 <sleep>:
SYSCALL(sleep)
 7a3:	b8 0d 00 00 00       	mov    $0xd,%eax
 7a8:	cd 40                	int    $0x40
 7aa:	c3                   	ret    

000007ab <uptime>:
SYSCALL(uptime)
 7ab:	b8 0e 00 00 00       	mov    $0xe,%eax
 7b0:	cd 40                	int    $0x40
 7b2:	c3                   	ret    

000007b3 <myfunction>:
SYSCALL(myfunction)
 7b3:	b8 16 00 00 00       	mov    $0x16,%eax
 7b8:	cd 40                	int    $0x40
 7ba:	c3                   	ret    

000007bb <getgpid>:
SYSCALL(getgpid)
 7bb:	b8 17 00 00 00       	mov    $0x17,%eax
 7c0:	cd 40                	int    $0x40
 7c2:	c3                   	ret    

000007c3 <yield>:
SYSCALL(yield)
 7c3:	b8 18 00 00 00       	mov    $0x18,%eax
 7c8:	cd 40                	int    $0x40
 7ca:	c3                   	ret    

000007cb <printpinfo>:
SYSCALL(printpinfo)
 7cb:	b8 19 00 00 00       	mov    $0x19,%eax
 7d0:	cd 40                	int    $0x40
 7d2:	c3                   	ret    

000007d3 <getlev>:
SYSCALL(getlev)
 7d3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 7d8:	cd 40                	int    $0x40
 7da:	c3                   	ret    

000007db <setpriority>:
SYSCALL(setpriority)
 7db:	b8 1b 00 00 00       	mov    $0x1b,%eax
 7e0:	cd 40                	int    $0x40
 7e2:	c3                   	ret    

000007e3 <setmonopoly>:
SYSCALL(setmonopoly)
 7e3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 7e8:	cd 40                	int    $0x40
 7ea:	c3                   	ret    

000007eb <monopolize>:
SYSCALL(monopolize)
 7eb:	b8 1d 00 00 00       	mov    $0x1d,%eax
 7f0:	cd 40                	int    $0x40
 7f2:	c3                   	ret    

000007f3 <unmonopolize>:
 7f3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 7f8:	cd 40                	int    $0x40
 7fa:	c3                   	ret    
 7fb:	66 90                	xchg   %ax,%ax
 7fd:	66 90                	xchg   %ax,%ax
 7ff:	90                   	nop

00000800 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	57                   	push   %edi
 804:	56                   	push   %esi
 805:	53                   	push   %ebx
 806:	83 ec 3c             	sub    $0x3c,%esp
 809:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 80c:	89 d1                	mov    %edx,%ecx
{
 80e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 811:	85 d2                	test   %edx,%edx
 813:	0f 89 7f 00 00 00    	jns    898 <printint+0x98>
 819:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 81d:	74 79                	je     898 <printint+0x98>
    neg = 1;
 81f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 826:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 828:	31 db                	xor    %ebx,%ebx
 82a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 82d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 830:	89 c8                	mov    %ecx,%eax
 832:	31 d2                	xor    %edx,%edx
 834:	89 cf                	mov    %ecx,%edi
 836:	f7 75 c4             	divl   -0x3c(%ebp)
 839:	0f b6 92 5c 0d 00 00 	movzbl 0xd5c(%edx),%edx
 840:	89 45 c0             	mov    %eax,-0x40(%ebp)
 843:	89 d8                	mov    %ebx,%eax
 845:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 848:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 84b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 84e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 851:	76 dd                	jbe    830 <printint+0x30>
  if(neg)
 853:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 856:	85 c9                	test   %ecx,%ecx
 858:	74 0c                	je     866 <printint+0x66>
    buf[i++] = '-';
 85a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 85f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 861:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 866:	8b 7d b8             	mov    -0x48(%ebp),%edi
 869:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 86d:	eb 07                	jmp    876 <printint+0x76>
 86f:	90                   	nop
    putc(fd, buf[i]);
 870:	0f b6 13             	movzbl (%ebx),%edx
 873:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 876:	83 ec 04             	sub    $0x4,%esp
 879:	88 55 d7             	mov    %dl,-0x29(%ebp)
 87c:	6a 01                	push   $0x1
 87e:	56                   	push   %esi
 87f:	57                   	push   %edi
 880:	e8 ae fe ff ff       	call   733 <write>
  while(--i >= 0)
 885:	83 c4 10             	add    $0x10,%esp
 888:	39 de                	cmp    %ebx,%esi
 88a:	75 e4                	jne    870 <printint+0x70>
}
 88c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 88f:	5b                   	pop    %ebx
 890:	5e                   	pop    %esi
 891:	5f                   	pop    %edi
 892:	5d                   	pop    %ebp
 893:	c3                   	ret    
 894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 898:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 89f:	eb 87                	jmp    828 <printint+0x28>
 8a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8af:	90                   	nop

000008b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 8b0:	55                   	push   %ebp
 8b1:	89 e5                	mov    %esp,%ebp
 8b3:	57                   	push   %edi
 8b4:	56                   	push   %esi
 8b5:	53                   	push   %ebx
 8b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 8bc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 8bf:	0f b6 13             	movzbl (%ebx),%edx
 8c2:	84 d2                	test   %dl,%dl
 8c4:	74 6a                	je     930 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 8c6:	8d 45 10             	lea    0x10(%ebp),%eax
 8c9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 8cc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 8cf:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 8d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 8d4:	eb 36                	jmp    90c <printf+0x5c>
 8d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8dd:	8d 76 00             	lea    0x0(%esi),%esi
 8e0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 8e3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 8e8:	83 f8 25             	cmp    $0x25,%eax
 8eb:	74 15                	je     902 <printf+0x52>
  write(fd, &c, 1);
 8ed:	83 ec 04             	sub    $0x4,%esp
 8f0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 8f3:	6a 01                	push   $0x1
 8f5:	57                   	push   %edi
 8f6:	56                   	push   %esi
 8f7:	e8 37 fe ff ff       	call   733 <write>
 8fc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 8ff:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 902:	0f b6 13             	movzbl (%ebx),%edx
 905:	83 c3 01             	add    $0x1,%ebx
 908:	84 d2                	test   %dl,%dl
 90a:	74 24                	je     930 <printf+0x80>
    c = fmt[i] & 0xff;
 90c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 90f:	85 c9                	test   %ecx,%ecx
 911:	74 cd                	je     8e0 <printf+0x30>
      }
    } else if(state == '%'){
 913:	83 f9 25             	cmp    $0x25,%ecx
 916:	75 ea                	jne    902 <printf+0x52>
      if(c == 'd'){
 918:	83 f8 25             	cmp    $0x25,%eax
 91b:	0f 84 07 01 00 00    	je     a28 <printf+0x178>
 921:	83 e8 63             	sub    $0x63,%eax
 924:	83 f8 15             	cmp    $0x15,%eax
 927:	77 17                	ja     940 <printf+0x90>
 929:	ff 24 85 04 0d 00 00 	jmp    *0xd04(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 930:	8d 65 f4             	lea    -0xc(%ebp),%esp
 933:	5b                   	pop    %ebx
 934:	5e                   	pop    %esi
 935:	5f                   	pop    %edi
 936:	5d                   	pop    %ebp
 937:	c3                   	ret    
 938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 93f:	90                   	nop
  write(fd, &c, 1);
 940:	83 ec 04             	sub    $0x4,%esp
 943:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 946:	6a 01                	push   $0x1
 948:	57                   	push   %edi
 949:	56                   	push   %esi
 94a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 94e:	e8 e0 fd ff ff       	call   733 <write>
        putc(fd, c);
 953:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 957:	83 c4 0c             	add    $0xc,%esp
 95a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 95d:	6a 01                	push   $0x1
 95f:	57                   	push   %edi
 960:	56                   	push   %esi
 961:	e8 cd fd ff ff       	call   733 <write>
        putc(fd, c);
 966:	83 c4 10             	add    $0x10,%esp
      state = 0;
 969:	31 c9                	xor    %ecx,%ecx
 96b:	eb 95                	jmp    902 <printf+0x52>
 96d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 970:	83 ec 0c             	sub    $0xc,%esp
 973:	b9 10 00 00 00       	mov    $0x10,%ecx
 978:	6a 00                	push   $0x0
 97a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 97d:	8b 10                	mov    (%eax),%edx
 97f:	89 f0                	mov    %esi,%eax
 981:	e8 7a fe ff ff       	call   800 <printint>
        ap++;
 986:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 98a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 98d:	31 c9                	xor    %ecx,%ecx
 98f:	e9 6e ff ff ff       	jmp    902 <printf+0x52>
 994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 998:	8b 45 d0             	mov    -0x30(%ebp),%eax
 99b:	8b 10                	mov    (%eax),%edx
        ap++;
 99d:	83 c0 04             	add    $0x4,%eax
 9a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 9a3:	85 d2                	test   %edx,%edx
 9a5:	0f 84 8d 00 00 00    	je     a38 <printf+0x188>
        while(*s != 0){
 9ab:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 9ae:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 9b0:	84 c0                	test   %al,%al
 9b2:	0f 84 4a ff ff ff    	je     902 <printf+0x52>
 9b8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 9bb:	89 d3                	mov    %edx,%ebx
 9bd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 9c0:	83 ec 04             	sub    $0x4,%esp
          s++;
 9c3:	83 c3 01             	add    $0x1,%ebx
 9c6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 9c9:	6a 01                	push   $0x1
 9cb:	57                   	push   %edi
 9cc:	56                   	push   %esi
 9cd:	e8 61 fd ff ff       	call   733 <write>
        while(*s != 0){
 9d2:	0f b6 03             	movzbl (%ebx),%eax
 9d5:	83 c4 10             	add    $0x10,%esp
 9d8:	84 c0                	test   %al,%al
 9da:	75 e4                	jne    9c0 <printf+0x110>
      state = 0;
 9dc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 9df:	31 c9                	xor    %ecx,%ecx
 9e1:	e9 1c ff ff ff       	jmp    902 <printf+0x52>
 9e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9ed:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 9f0:	83 ec 0c             	sub    $0xc,%esp
 9f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 9f8:	6a 01                	push   $0x1
 9fa:	e9 7b ff ff ff       	jmp    97a <printf+0xca>
 9ff:	90                   	nop
        putc(fd, *ap);
 a00:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 a03:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 a06:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 a08:	6a 01                	push   $0x1
 a0a:	57                   	push   %edi
 a0b:	56                   	push   %esi
        putc(fd, *ap);
 a0c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 a0f:	e8 1f fd ff ff       	call   733 <write>
        ap++;
 a14:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 a18:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a1b:	31 c9                	xor    %ecx,%ecx
 a1d:	e9 e0 fe ff ff       	jmp    902 <printf+0x52>
 a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 a28:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 a2b:	83 ec 04             	sub    $0x4,%esp
 a2e:	e9 2a ff ff ff       	jmp    95d <printf+0xad>
 a33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a37:	90                   	nop
          s = "(null)";
 a38:	ba fc 0c 00 00       	mov    $0xcfc,%edx
        while(*s != 0){
 a3d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 a40:	b8 28 00 00 00       	mov    $0x28,%eax
 a45:	89 d3                	mov    %edx,%ebx
 a47:	e9 74 ff ff ff       	jmp    9c0 <printf+0x110>
 a4c:	66 90                	xchg   %ax,%ax
 a4e:	66 90                	xchg   %ax,%ax

00000a50 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a50:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a51:	a1 c4 10 00 00       	mov    0x10c4,%eax
{
 a56:	89 e5                	mov    %esp,%ebp
 a58:	57                   	push   %edi
 a59:	56                   	push   %esi
 a5a:	53                   	push   %ebx
 a5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 a5e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a68:	89 c2                	mov    %eax,%edx
 a6a:	8b 00                	mov    (%eax),%eax
 a6c:	39 ca                	cmp    %ecx,%edx
 a6e:	73 30                	jae    aa0 <free+0x50>
 a70:	39 c1                	cmp    %eax,%ecx
 a72:	72 04                	jb     a78 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a74:	39 c2                	cmp    %eax,%edx
 a76:	72 f0                	jb     a68 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 a78:	8b 73 fc             	mov    -0x4(%ebx),%esi
 a7b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 a7e:	39 f8                	cmp    %edi,%eax
 a80:	74 30                	je     ab2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 a82:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 a85:	8b 42 04             	mov    0x4(%edx),%eax
 a88:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 a8b:	39 f1                	cmp    %esi,%ecx
 a8d:	74 3a                	je     ac9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 a8f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 a91:	5b                   	pop    %ebx
  freep = p;
 a92:	89 15 c4 10 00 00    	mov    %edx,0x10c4
}
 a98:	5e                   	pop    %esi
 a99:	5f                   	pop    %edi
 a9a:	5d                   	pop    %ebp
 a9b:	c3                   	ret    
 a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa0:	39 c2                	cmp    %eax,%edx
 aa2:	72 c4                	jb     a68 <free+0x18>
 aa4:	39 c1                	cmp    %eax,%ecx
 aa6:	73 c0                	jae    a68 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 aa8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 aab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 aae:	39 f8                	cmp    %edi,%eax
 ab0:	75 d0                	jne    a82 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 ab2:	03 70 04             	add    0x4(%eax),%esi
 ab5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 ab8:	8b 02                	mov    (%edx),%eax
 aba:	8b 00                	mov    (%eax),%eax
 abc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 abf:	8b 42 04             	mov    0x4(%edx),%eax
 ac2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 ac5:	39 f1                	cmp    %esi,%ecx
 ac7:	75 c6                	jne    a8f <free+0x3f>
    p->s.size += bp->s.size;
 ac9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 acc:	89 15 c4 10 00 00    	mov    %edx,0x10c4
    p->s.size += bp->s.size;
 ad2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 ad5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 ad8:	89 0a                	mov    %ecx,(%edx)
}
 ada:	5b                   	pop    %ebx
 adb:	5e                   	pop    %esi
 adc:	5f                   	pop    %edi
 add:	5d                   	pop    %ebp
 ade:	c3                   	ret    
 adf:	90                   	nop

00000ae0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ae0:	55                   	push   %ebp
 ae1:	89 e5                	mov    %esp,%ebp
 ae3:	57                   	push   %edi
 ae4:	56                   	push   %esi
 ae5:	53                   	push   %ebx
 ae6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 aec:	8b 3d c4 10 00 00    	mov    0x10c4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 af2:	8d 70 07             	lea    0x7(%eax),%esi
 af5:	c1 ee 03             	shr    $0x3,%esi
 af8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 afb:	85 ff                	test   %edi,%edi
 afd:	0f 84 9d 00 00 00    	je     ba0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b03:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 b05:	8b 4a 04             	mov    0x4(%edx),%ecx
 b08:	39 f1                	cmp    %esi,%ecx
 b0a:	73 6a                	jae    b76 <malloc+0x96>
 b0c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 b11:	39 de                	cmp    %ebx,%esi
 b13:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 b16:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 b1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 b20:	eb 17                	jmp    b39 <malloc+0x59>
 b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b28:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 b2a:	8b 48 04             	mov    0x4(%eax),%ecx
 b2d:	39 f1                	cmp    %esi,%ecx
 b2f:	73 4f                	jae    b80 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b31:	8b 3d c4 10 00 00    	mov    0x10c4,%edi
 b37:	89 c2                	mov    %eax,%edx
 b39:	39 d7                	cmp    %edx,%edi
 b3b:	75 eb                	jne    b28 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 b3d:	83 ec 0c             	sub    $0xc,%esp
 b40:	ff 75 e4             	push   -0x1c(%ebp)
 b43:	e8 53 fc ff ff       	call   79b <sbrk>
  if(p == (char*)-1)
 b48:	83 c4 10             	add    $0x10,%esp
 b4b:	83 f8 ff             	cmp    $0xffffffff,%eax
 b4e:	74 1c                	je     b6c <malloc+0x8c>
  hp->s.size = nu;
 b50:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 b53:	83 ec 0c             	sub    $0xc,%esp
 b56:	83 c0 08             	add    $0x8,%eax
 b59:	50                   	push   %eax
 b5a:	e8 f1 fe ff ff       	call   a50 <free>
  return freep;
 b5f:	8b 15 c4 10 00 00    	mov    0x10c4,%edx
      if((p = morecore(nunits)) == 0)
 b65:	83 c4 10             	add    $0x10,%esp
 b68:	85 d2                	test   %edx,%edx
 b6a:	75 bc                	jne    b28 <malloc+0x48>
        return 0;
  }
}
 b6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 b6f:	31 c0                	xor    %eax,%eax
}
 b71:	5b                   	pop    %ebx
 b72:	5e                   	pop    %esi
 b73:	5f                   	pop    %edi
 b74:	5d                   	pop    %ebp
 b75:	c3                   	ret    
    if(p->s.size >= nunits){
 b76:	89 d0                	mov    %edx,%eax
 b78:	89 fa                	mov    %edi,%edx
 b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 b80:	39 ce                	cmp    %ecx,%esi
 b82:	74 4c                	je     bd0 <malloc+0xf0>
        p->s.size -= nunits;
 b84:	29 f1                	sub    %esi,%ecx
 b86:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 b89:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 b8c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 b8f:	89 15 c4 10 00 00    	mov    %edx,0x10c4
}
 b95:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 b98:	83 c0 08             	add    $0x8,%eax
}
 b9b:	5b                   	pop    %ebx
 b9c:	5e                   	pop    %esi
 b9d:	5f                   	pop    %edi
 b9e:	5d                   	pop    %ebp
 b9f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 ba0:	c7 05 c4 10 00 00 c8 	movl   $0x10c8,0x10c4
 ba7:	10 00 00 
    base.s.size = 0;
 baa:	bf c8 10 00 00       	mov    $0x10c8,%edi
    base.s.ptr = freep = prevp = &base;
 baf:	c7 05 c8 10 00 00 c8 	movl   $0x10c8,0x10c8
 bb6:	10 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bb9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 bbb:	c7 05 cc 10 00 00 00 	movl   $0x0,0x10cc
 bc2:	00 00 00 
    if(p->s.size >= nunits){
 bc5:	e9 42 ff ff ff       	jmp    b0c <malloc+0x2c>
 bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 bd0:	8b 08                	mov    (%eax),%ecx
 bd2:	89 0a                	mov    %ecx,(%edx)
 bd4:	eb b9                	jmp    b8f <malloc+0xaf>

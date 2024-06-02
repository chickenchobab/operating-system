
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 e4 14 80       	mov    $0x8014e4d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 33 10 80       	mov    $0x80103380,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 77 10 80       	push   $0x80107760
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 95 46 00 00       	call   801046f0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 77 10 80       	push   $0x80107767
80100097:	50                   	push   %eax
80100098:	e8 23 45 00 00       	call   801045c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 d7 47 00 00       	call   801048c0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 f9 46 00 00       	call   80104860 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 44 00 00       	call   80104600 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 6e 77 10 80       	push   $0x8010776e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 dd 44 00 00       	call   801046a0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 7f 77 10 80       	push   $0x8010777f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 9c 44 00 00       	call   801046a0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 4c 44 00 00       	call   80104660 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 a0 46 00 00       	call   801048c0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 ef 45 00 00       	jmp    80104860 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 86 77 10 80       	push   $0x80107786
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 1b 46 00 00       	call   801048c0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
        return -1;
      }
      // release(&cons.lock);
      // cprintf("%d(%s) slp\n", myproc()->pid, myproc()->name);
      // acquire(&cons.lock);
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 8e 40 00 00       	call   80104360 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 a9 39 00 00       	call   80103c90 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 65 45 00 00       	call   80104860 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 0f 45 00 00       	call   80104860 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 72 28 00 00       	call   80102c10 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 8d 77 10 80       	push   $0x8010778d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 2f 81 10 80 	movl   $0x8010812f,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 43 43 00 00       	call   80104710 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 a1 77 10 80       	push   $0x801077a1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 d1 5b 00 00       	call   80105ff0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 e6 5a 00 00       	call   80105ff0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 da 5a 00 00       	call   80105ff0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 ce 5a 00 00       	call   80105ff0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 ca 44 00 00       	call   80104a20 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 15 44 00 00       	call   80104980 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 a5 77 10 80       	push   $0x801077a5
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 10 43 00 00       	call   801048c0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 77 42 00 00       	call   80104860 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 d0 77 10 80 	movzbl -0x7fef8830(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 d3 40 00 00       	call   801048c0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf b8 77 10 80       	mov    $0x801077b8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 00 40 00 00       	call   80104860 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 bf 77 10 80       	push   $0x801077bf
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 28 40 00 00       	call   801048c0 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 8b 3e 00 00       	call   80104860 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 ed 3a 00 00       	jmp    80104500 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 d7 39 00 00       	call   80104420 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 c8 77 10 80       	push   $0x801077c8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 7b 3c 00 00       	call   801046f0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 cf 31 00 00       	call   80103c90 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 b4 25 00 00       	call   80103080 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 dc 25 00 00       	call   801030f0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 67 66 00 00       	call   801071a0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 18 64 00 00       	call   80106fc0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 f2 62 00 00       	call   80106ed0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 00 65 00 00       	call   80107120 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 9a 24 00 00       	call   801030f0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 59 63 00 00       	call   80106fc0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 b8 65 00 00       	call   80107240 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 a8 3e 00 00       	call   80104b80 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 94 3e 00 00       	call   80104b80 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 e3 66 00 00       	call   801073e0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 0a 64 00 00       	call   80107120 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 78 66 00 00       	call   801073e0 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 9a 3d 00 00       	call   80104b40 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 6e 5f 00 00       	call   80106d40 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 46 63 00 00       	call   80107120 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 07 23 00 00       	call   801030f0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 e1 77 10 80       	push   $0x801077e1
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 ed 77 10 80       	push   $0x801077ed
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 cb 38 00 00       	call   801046f0 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 7a 3a 00 00       	call   801048c0 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 ea 39 00 00       	call   80104860 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 d1 39 00 00       	call   80104860 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 0c 3a 00 00       	call   801048c0 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 8f 39 00 00       	call   80104860 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 f4 77 10 80       	push   $0x801077f4
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 ba 39 00 00       	call   801048c0 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 1f 39 00 00       	call   80104860 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 ed 38 00 00       	jmp    80104860 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 03 21 00 00       	call   80103080 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 59 21 00 00       	jmp    801030f0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 a2 28 00 00       	call   80103850 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 fc 77 10 80       	push   $0x801077fc
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 5e 29 00 00       	jmp    801039f0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 06 78 10 80       	push   $0x80107806
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 e2 1f 00 00       	call   801030f0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 4d 1f 00 00       	call   80103080 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 86 1f 00 00       	call   801030f0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 0f 78 10 80       	push   $0x8010780f
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 42 27 00 00       	jmp    801038f0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 15 78 10 80       	push   $0x80107815
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 4e 20 00 00       	call   80103260 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 1f 78 10 80       	push   $0x8010781f
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 32 78 10 80       	push   $0x80107832
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 5e 1f 00 00       	call   80103260 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 56 36 00 00       	call   80104980 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 2e 1f 00 00       	call   80103260 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 51 35 00 00       	call   801048c0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 84 34 00 00       	call   80104860 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 56 34 00 00       	call   80104860 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 48 78 10 80       	push   $0x80107848
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 96 1d 00 00       	call   80103260 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 58 78 10 80       	push   $0x80107858
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 da 34 00 00       	call   80104a20 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 6b 78 10 80       	push   $0x8010786b
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 75 31 00 00       	call   801046f0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 72 78 10 80       	push   $0x80107872
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 2c 30 00 00       	call   801045c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 25 11 80       	push   $0x801125b4
801015bc:	e8 5f 34 00 00       	call   80104a20 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 25 11 80    	push   0x801125cc
801015cf:	ff 35 c8 25 11 80    	push   0x801125c8
801015d5:	ff 35 c4 25 11 80    	push   0x801125c4
801015db:	ff 35 c0 25 11 80    	push   0x801125c0
801015e1:	ff 35 bc 25 11 80    	push   0x801125bc
801015e7:	ff 35 b8 25 11 80    	push   0x801125b8
801015ed:	ff 35 b4 25 11 80    	push   0x801125b4
801015f3:	68 d8 78 10 80       	push   $0x801078d8
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 ed 32 00 00       	call   80104980 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 bb 1b 00 00       	call   80103260 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 78 78 10 80       	push   $0x80107878
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 ea 32 00 00       	call   80104a20 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 22 1b 00 00       	call   80103260 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 09 11 80       	push   $0x80110960
8010175f:	e8 5c 31 00 00       	call   801048c0 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 ec 30 00 00       	call   80104860 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 59 2e 00 00       	call   80104600 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 03 32 00 00       	call   80104a20 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 90 78 10 80       	push   $0x80107890
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 8a 78 10 80       	push   $0x8010788a
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 28 2e 00 00       	call   801046a0 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 cc 2d 00 00       	jmp    80104660 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 9f 78 10 80       	push   $0x8010789f
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 3b 2d 00 00       	call   80104600 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 81 2d 00 00       	call   80104660 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 d5 2f 00 00       	call   801048c0 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 5b 2f 00 00       	jmp    80104860 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 ab 2f 00 00       	call   801048c0 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 3c 2f 00 00       	call   80104860 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 78 2c 00 00       	call   801046a0 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 21 2c 00 00       	call   80104660 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 9f 78 10 80       	push   $0x8010789f
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 e4 2e 00 00       	call   80104a20 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 e8 2d 00 00       	call   80104a20 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 20 16 00 00       	call   80103260 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 bd 2d 00 00       	call   80104a90 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 5e 2d 00 00       	call   80104a90 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 b9 78 10 80       	push   $0x801078b9
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 a7 78 10 80       	push   $0x801078a7
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 e1 1e 00 00       	call   80103c90 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 01 2b 00 00       	call   801048c0 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 91 2a 00 00       	call   80104860 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 f4 2b 00 00       	call   80104a20 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 0f 28 00 00       	call   801046a0 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 ad 27 00 00       	call   80104660 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 40 2b 00 00       	call   80104a20 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 70 27 00 00       	call   801046a0 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 11 27 00 00       	call   80104660 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 2e 27 00 00       	call   801046a0 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 0b 27 00 00       	call   801046a0 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 b4 26 00 00       	call   80104660 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 9f 78 10 80       	push   $0x8010789f
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 9e 2a 00 00       	call   80104ae0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 c8 78 10 80       	push   $0x801078c8
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 ce 7e 10 80       	push   $0x80107ece
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 34 79 10 80       	push   $0x80107934
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 2b 79 10 80       	push   $0x8010792b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 46 79 10 80       	push   $0x80107946
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 1b 25 00 00       	call   801046f0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 a7 14 80       	mov    0x8014a784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 26 11 80       	push   $0x80112600
8010224e:	e8 6d 26 00 00       	call   801048c0 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 6e 21 00 00       	call   80104420 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 26 11 80       	push   $0x80112600
801022cb:	e8 90 25 00 00       	call   80104860 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 ad 23 00 00       	call   801046a0 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 26 11 80       	push   $0x80112600
80102328:	e8 93 25 00 00       	call   801048c0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 26 11 80       	push   $0x80112600
80102368:	53                   	push   %ebx
80102369:	e8 f2 1f 00 00       	call   80104360 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 d5 24 00 00       	jmp    80104860 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 75 79 10 80       	push   $0x80107975
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 60 79 10 80       	push   $0x80107960
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 4a 79 10 80       	push   $0x8010794a
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 a7 14 80 	movzbl 0x8014a780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 94 79 10 80       	push   $0x80107994
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	56                   	push   %esi
801024c4:	8b 75 08             	mov    0x8(%ebp),%esi
801024c7:	53                   	push   %ebx
  struct run *r;
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024c8:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
801024ce:	0f 85 b5 00 00 00    	jne    80102589 <kfree+0xc9>
801024d4:	81 fe d0 e4 14 80    	cmp    $0x8014e4d0,%esi
801024da:	0f 82 a9 00 00 00    	jb     80102589 <kfree+0xc9>
801024e0:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
801024e6:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
801024ec:	0f 87 97 00 00 00    	ja     80102589 <kfree+0xc9>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  
  if(kmem.use_lock)
801024f2:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024f8:	85 d2                	test   %edx,%edx
801024fa:	75 34                	jne    80102530 <kfree+0x70>
    acquire(&kmem.lock);

  r = (struct run*)v;

  if (kmem.refc[V2P(v) / PGSIZE] > 0)
801024fc:	c1 eb 0c             	shr    $0xc,%ebx
801024ff:	83 c3 10             	add    $0x10,%ebx
80102502:	8b 04 9d 40 26 11 80 	mov    -0x7feed9c0(,%ebx,4),%eax
80102509:	85 c0                	test   %eax,%eax
8010250b:	7e 0a                	jle    80102517 <kfree+0x57>
    kmem.refc[V2P(v) / PGSIZE]--;
8010250d:	83 e8 01             	sub    $0x1,%eax
80102510:	89 04 9d 40 26 11 80 	mov    %eax,-0x7feed9c0(,%ebx,4)
  if (kmem.refc[V2P(v) / PGSIZE] == 0){
80102517:	85 c0                	test   %eax,%eax
80102519:	74 45                	je     80102560 <kfree+0xa0>
    kmem.fpc = kmem.fpc + 1;
    r->next = kmem.freelist;
    kmem.freelist = r;
  }  

  if(kmem.use_lock)
8010251b:	a1 74 26 11 80       	mov    0x80112674,%eax
80102520:	85 c0                	test   %eax,%eax
80102522:	75 24                	jne    80102548 <kfree+0x88>
    release(&kmem.lock);
}
80102524:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102527:	5b                   	pop    %ebx
80102528:	5e                   	pop    %esi
80102529:	5d                   	pop    %ebp
8010252a:	c3                   	ret    
8010252b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010252f:	90                   	nop
    acquire(&kmem.lock);
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 40 26 11 80       	push   $0x80112640
80102538:	e8 83 23 00 00       	call   801048c0 <acquire>
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	eb ba                	jmp    801024fc <kfree+0x3c>
80102542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102548:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010254f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102552:	5b                   	pop    %ebx
80102553:	5e                   	pop    %esi
80102554:	5d                   	pop    %ebp
    release(&kmem.lock);
80102555:	e9 06 23 00 00       	jmp    80104860 <release>
8010255a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memset(v, 1, PGSIZE);
80102560:	83 ec 04             	sub    $0x4,%esp
80102563:	68 00 10 00 00       	push   $0x1000
80102568:	6a 01                	push   $0x1
8010256a:	56                   	push   %esi
8010256b:	e8 10 24 00 00       	call   80104980 <memset>
    r->next = kmem.freelist;
80102570:	a1 78 26 11 80       	mov    0x80112678,%eax
    kmem.fpc = kmem.fpc + 1;
80102575:	83 05 7c 26 11 80 01 	addl   $0x1,0x8011267c
    kmem.freelist = r;
8010257c:	83 c4 10             	add    $0x10,%esp
    r->next = kmem.freelist;
8010257f:	89 06                	mov    %eax,(%esi)
    kmem.freelist = r;
80102581:	89 35 78 26 11 80    	mov    %esi,0x80112678
80102587:	eb 92                	jmp    8010251b <kfree+0x5b>
    panic("kfree");
80102589:	83 ec 0c             	sub    $0xc,%esp
8010258c:	68 c6 79 10 80       	push   $0x801079c6
80102591:	e8 ea dd ff ff       	call   80100380 <panic>
80102596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010259d:	8d 76 00             	lea    0x0(%esi),%esi

801025a0 <freerange>:
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	57                   	push   %edi
801025a4:	56                   	push   %esi
801025a5:	53                   	push   %ebx
801025a6:	83 ec 10             	sub    $0x10,%esp
801025a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  cprintf("v:%d, p:%d\n", sizeof(struct run), sizeof(struct run*));
801025ac:	6a 04                	push   $0x4
801025ae:	6a 04                	push   $0x4
801025b0:	68 cc 79 10 80       	push   $0x801079cc
801025b5:	e8 e6 e0 ff ff       	call   801006a0 <cprintf>
  p = (char*)PGROUNDUP((uint)vstart);
801025ba:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801025bd:	83 c4 10             	add    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801025c0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801025cc:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
801025d2:	39 fe                	cmp    %edi,%esi
801025d4:	73 10                	jae    801025e6 <freerange+0x46>
801025d6:	eb 37                	jmp    8010260f <freerange+0x6f>
801025d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop
801025e0:	81 c7 00 10 00 00    	add    $0x1000,%edi
    kfree(p);
801025e6:	83 ec 0c             	sub    $0xc,%esp
    kmem.refc[(uint)p / PGSIZE] = 0;
801025e9:	89 d8                	mov    %ebx,%eax
    kfree(p);
801025eb:	53                   	push   %ebx
    kmem.refc[(uint)p / PGSIZE] = 0;
801025ec:	c1 e8 0c             	shr    $0xc,%eax
801025ef:	c7 04 85 80 26 11 80 	movl   $0x0,-0x7feed980(,%eax,4)
801025f6:	00 00 00 00 
    kfree(p);
801025fa:	e8 c1 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801025ff:	89 d8                	mov    %ebx,%eax
80102601:	83 c4 10             	add    $0x10,%esp
80102604:	89 fb                	mov    %edi,%ebx
80102606:	05 00 20 00 00       	add    $0x2000,%eax
8010260b:	39 c6                	cmp    %eax,%esi
8010260d:	73 d1                	jae    801025e0 <freerange+0x40>
}
8010260f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102612:	5b                   	pop    %ebx
80102613:	5e                   	pop    %esi
80102614:	5f                   	pop    %edi
80102615:	5d                   	pop    %ebp
80102616:	c3                   	ret    
80102617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010261e:	66 90                	xchg   %ax,%ax

80102620 <kinit2>:
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	57                   	push   %edi
80102624:	56                   	push   %esi
80102625:	53                   	push   %ebx
80102626:	83 ec 10             	sub    $0x10,%esp
80102629:	8b 75 0c             	mov    0xc(%ebp),%esi
  cprintf("v:%d, p:%d\n", sizeof(struct run), sizeof(struct run*));
8010262c:	6a 04                	push   $0x4
8010262e:	6a 04                	push   $0x4
80102630:	68 cc 79 10 80       	push   $0x801079cc
80102635:	e8 66 e0 ff ff       	call   801006a0 <cprintf>
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010263d:	83 c4 10             	add    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102640:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102646:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010264c:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
80102652:	39 fe                	cmp    %edi,%esi
80102654:	73 10                	jae    80102666 <kinit2+0x46>
80102656:	eb 37                	jmp    8010268f <kinit2+0x6f>
80102658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010265f:	90                   	nop
80102660:	81 c7 00 10 00 00    	add    $0x1000,%edi
    kfree(p);
80102666:	83 ec 0c             	sub    $0xc,%esp
    kmem.refc[(uint)p / PGSIZE] = 0;
80102669:	89 d8                	mov    %ebx,%eax
    kfree(p);
8010266b:	53                   	push   %ebx
    kmem.refc[(uint)p / PGSIZE] = 0;
8010266c:	c1 e8 0c             	shr    $0xc,%eax
8010266f:	c7 04 85 80 26 11 80 	movl   $0x0,-0x7feed980(,%eax,4)
80102676:	00 00 00 00 
    kfree(p);
8010267a:	e8 41 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010267f:	89 d8                	mov    %ebx,%eax
80102681:	83 c4 10             	add    $0x10,%esp
80102684:	89 fb                	mov    %edi,%ebx
80102686:	05 00 20 00 00       	add    $0x2000,%eax
8010268b:	39 c6                	cmp    %eax,%esi
8010268d:	73 d1                	jae    80102660 <kinit2+0x40>
  kmem.use_lock = 1;
8010268f:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102696:	00 00 00 
}
80102699:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010269c:	5b                   	pop    %ebx
8010269d:	5e                   	pop    %esi
8010269e:	5f                   	pop    %edi
8010269f:	5d                   	pop    %ebp
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026af:	90                   	nop

801026b0 <kinit1>:
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	57                   	push   %edi
801026b4:	56                   	push   %esi
801026b5:	53                   	push   %ebx
801026b6:	83 ec 14             	sub    $0x14,%esp
801026b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801026bc:	68 d8 79 10 80       	push   $0x801079d8
801026c1:	68 40 26 11 80       	push   $0x80112640
801026c6:	e8 25 20 00 00       	call   801046f0 <initlock>
  cprintf("v:%d, p:%d\n", sizeof(struct run), sizeof(struct run*));
801026cb:	83 c4 0c             	add    $0xc,%esp
  kmem.use_lock = 0;
801026ce:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801026d5:	00 00 00 
  cprintf("v:%d, p:%d\n", sizeof(struct run), sizeof(struct run*));
801026d8:	6a 04                	push   $0x4
801026da:	6a 04                	push   $0x4
801026dc:	68 cc 79 10 80       	push   $0x801079cc
  kmem.fpc = 0;
801026e1:	c7 05 7c 26 11 80 00 	movl   $0x0,0x8011267c
801026e8:	00 00 00 
  cprintf("v:%d, p:%d\n", sizeof(struct run), sizeof(struct run*));
801026eb:	e8 b0 df ff ff       	call   801006a0 <cprintf>
  p = (char*)PGROUNDUP((uint)vstart);
801026f0:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801026f3:	83 c4 10             	add    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801026f6:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026fc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102702:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
80102708:	39 fe                	cmp    %edi,%esi
8010270a:	73 0a                	jae    80102716 <kinit1+0x66>
8010270c:	eb 31                	jmp    8010273f <kinit1+0x8f>
8010270e:	66 90                	xchg   %ax,%ax
80102710:	81 c7 00 10 00 00    	add    $0x1000,%edi
    kfree(p);
80102716:	83 ec 0c             	sub    $0xc,%esp
    kmem.refc[(uint)p / PGSIZE] = 0;
80102719:	89 d8                	mov    %ebx,%eax
    kfree(p);
8010271b:	53                   	push   %ebx
    kmem.refc[(uint)p / PGSIZE] = 0;
8010271c:	c1 e8 0c             	shr    $0xc,%eax
8010271f:	c7 04 85 80 26 11 80 	movl   $0x0,-0x7feed980(,%eax,4)
80102726:	00 00 00 00 
    kfree(p);
8010272a:	e8 91 fd ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010272f:	89 d8                	mov    %ebx,%eax
80102731:	83 c4 10             	add    $0x10,%esp
80102734:	89 fb                	mov    %edi,%ebx
80102736:	05 00 20 00 00       	add    $0x2000,%eax
8010273b:	39 c6                	cmp    %eax,%esi
8010273d:	73 d1                	jae    80102710 <kinit1+0x60>
}
8010273f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102742:	5b                   	pop    %ebx
80102743:	5e                   	pop    %esi
80102744:	5f                   	pop    %edi
80102745:	5d                   	pop    %ebp
80102746:	c3                   	ret    
80102747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010274e:	66 90                	xchg   %ax,%ax

80102750 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102756:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010275c:	85 d2                	test   %edx,%edx
8010275e:	75 50                	jne    801027b0 <kalloc+0x60>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102760:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r){
80102765:	85 c0                	test   %eax,%eax
80102767:	74 27                	je     80102790 <kalloc+0x40>
    kmem.fpc = kmem.fpc - 1;
80102769:	83 2d 7c 26 11 80 01 	subl   $0x1,0x8011267c
    kmem.freelist = r->next;
80102770:	8b 08                	mov    (%eax),%ecx
80102772:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
    kmem.refc[V2P((char*)r) / PGSIZE] = 1;
80102778:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010277e:	c1 e9 0c             	shr    $0xc,%ecx
80102781:	c7 04 8d 80 26 11 80 	movl   $0x1,-0x7feed980(,%ecx,4)
80102788:	01 00 00 00 
  }
  if(kmem.use_lock)
8010278c:	85 d2                	test   %edx,%edx
8010278e:	75 08                	jne    80102798 <kalloc+0x48>
    release(&kmem.lock);
  return (char*)r;
}
80102790:	c9                   	leave  
80102791:	c3                   	ret    
80102792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102798:	83 ec 0c             	sub    $0xc,%esp
8010279b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010279e:	68 40 26 11 80       	push   $0x80112640
801027a3:	e8 b8 20 00 00       	call   80104860 <release>
  return (char*)r;
801027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801027ab:	83 c4 10             	add    $0x10,%esp
}
801027ae:	c9                   	leave  
801027af:	c3                   	ret    
    acquire(&kmem.lock);
801027b0:	83 ec 0c             	sub    $0xc,%esp
801027b3:	68 40 26 11 80       	push   $0x80112640
801027b8:	e8 03 21 00 00       	call   801048c0 <acquire>
  r = kmem.freelist;
801027bd:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801027c2:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r){
801027c8:	83 c4 10             	add    $0x10,%esp
801027cb:	85 c0                	test   %eax,%eax
801027cd:	75 9a                	jne    80102769 <kalloc+0x19>
801027cf:	eb bb                	jmp    8010278c <kalloc+0x3c>
801027d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027df:	90                   	nop

801027e0 <incr_refc>:

void 
incr_refc(uint pa)
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	53                   	push   %ebx
801027e4:	83 ec 04             	sub    $0x4,%esp
801027e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *v = P2V(pa);
801027ea:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx

  if((uint)v % PGSIZE || v < end || pa >= PHYSTOP)
801027f0:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801027f6:	0f 95 c0             	setne  %al
801027f9:	81 fa d0 e4 14 80    	cmp    $0x8014e4d0,%edx
801027ff:	0f 92 c2             	setb   %dl
80102802:	08 d0                	or     %dl,%al
80102804:	75 5e                	jne    80102864 <incr_refc+0x84>
80102806:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
8010280c:	77 56                	ja     80102864 <incr_refc+0x84>
    panic("incr_refc");

  if(kmem.use_lock)
8010280e:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102814:	85 d2                	test   %edx,%edx
80102816:	75 18                	jne    80102830 <incr_refc+0x50>
    acquire(&kmem.lock);
  
  kmem.refc[pa / PGSIZE]++;
80102818:	c1 eb 0c             	shr    $0xc,%ebx
8010281b:	83 04 9d 80 26 11 80 	addl   $0x1,-0x7feed980(,%ebx,4)
80102822:	01 

  if(kmem.use_lock)
    release(&kmem.lock);
}
80102823:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102826:	c9                   	leave  
80102827:	c3                   	ret    
80102828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010282f:	90                   	nop
    acquire(&kmem.lock);
80102830:	83 ec 0c             	sub    $0xc,%esp
  kmem.refc[pa / PGSIZE]++;
80102833:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102836:	68 40 26 11 80       	push   $0x80112640
8010283b:	e8 80 20 00 00       	call   801048c0 <acquire>
  if(kmem.use_lock)
80102840:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.refc[pa / PGSIZE]++;
80102845:	83 04 9d 80 26 11 80 	addl   $0x1,-0x7feed980(,%ebx,4)
8010284c:	01 
  if(kmem.use_lock)
8010284d:	83 c4 10             	add    $0x10,%esp
80102850:	85 c0                	test   %eax,%eax
80102852:	74 cf                	je     80102823 <incr_refc+0x43>
    release(&kmem.lock);
80102854:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010285b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010285e:	c9                   	leave  
    release(&kmem.lock);
8010285f:	e9 fc 1f 00 00       	jmp    80104860 <release>
    panic("incr_refc");
80102864:	83 ec 0c             	sub    $0xc,%esp
80102867:	68 dd 79 10 80       	push   $0x801079dd
8010286c:	e8 0f db ff ff       	call   80100380 <panic>
80102871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010287f:	90                   	nop

80102880 <decr_refc>:

void 
decr_refc(uint pa)
{
80102880:	55                   	push   %ebp
80102881:	89 e5                	mov    %esp,%ebp
80102883:	53                   	push   %ebx
80102884:	83 ec 04             	sub    $0x4,%esp
80102887:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *v = P2V(pa);
8010288a:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx

  if((uint)v % PGSIZE || v < end || pa >= PHYSTOP)
80102890:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102896:	0f 95 c0             	setne  %al
80102899:	81 fa d0 e4 14 80    	cmp    $0x8014e4d0,%edx
8010289f:	0f 92 c2             	setb   %dl
801028a2:	08 d0                	or     %dl,%al
801028a4:	75 5e                	jne    80102904 <decr_refc+0x84>
801028a6:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
801028ac:	77 56                	ja     80102904 <decr_refc+0x84>
    panic("incr_refc");

  if(kmem.use_lock)
801028ae:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801028b4:	85 d2                	test   %edx,%edx
801028b6:	75 18                	jne    801028d0 <decr_refc+0x50>
    acquire(&kmem.lock);
  
  kmem.refc[pa / PGSIZE]--;
801028b8:	c1 eb 0c             	shr    $0xc,%ebx
801028bb:	83 2c 9d 80 26 11 80 	subl   $0x1,-0x7feed980(,%ebx,4)
801028c2:	01 

  if(kmem.use_lock)
    release(&kmem.lock);
}
801028c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028c6:	c9                   	leave  
801028c7:	c3                   	ret    
801028c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028cf:	90                   	nop
    acquire(&kmem.lock);
801028d0:	83 ec 0c             	sub    $0xc,%esp
  kmem.refc[pa / PGSIZE]--;
801028d3:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
801028d6:	68 40 26 11 80       	push   $0x80112640
801028db:	e8 e0 1f 00 00       	call   801048c0 <acquire>
  if(kmem.use_lock)
801028e0:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.refc[pa / PGSIZE]--;
801028e5:	83 2c 9d 80 26 11 80 	subl   $0x1,-0x7feed980(,%ebx,4)
801028ec:	01 
  if(kmem.use_lock)
801028ed:	83 c4 10             	add    $0x10,%esp
801028f0:	85 c0                	test   %eax,%eax
801028f2:	74 cf                	je     801028c3 <decr_refc+0x43>
    release(&kmem.lock);
801028f4:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801028fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028fe:	c9                   	leave  
    release(&kmem.lock);
801028ff:	e9 5c 1f 00 00       	jmp    80104860 <release>
    panic("incr_refc");
80102904:	83 ec 0c             	sub    $0xc,%esp
80102907:	68 dd 79 10 80       	push   $0x801079dd
8010290c:	e8 6f da ff ff       	call   80100380 <panic>
80102911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291f:	90                   	nop

80102920 <get_refc>:

int 
get_refc(uint pa)
{
80102920:	55                   	push   %ebp
80102921:	89 e5                	mov    %esp,%ebp
80102923:	53                   	push   %ebx
80102924:	83 ec 14             	sub    $0x14,%esp
80102927:	8b 45 08             	mov    0x8(%ebp),%eax
  int refc;
  char *v = P2V(pa);
8010292a:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx

  if((uint)v % PGSIZE || v < end || pa >= PHYSTOP)
80102930:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102935:	0f 95 c2             	setne  %dl
80102938:	81 f9 d0 e4 14 80    	cmp    $0x8014e4d0,%ecx
8010293e:	0f 92 c1             	setb   %cl
80102941:	08 ca                	or     %cl,%dl
80102943:	75 67                	jne    801029ac <get_refc+0x8c>
80102945:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
8010294a:	77 60                	ja     801029ac <get_refc+0x8c>
    panic("get_refc");

  if(kmem.use_lock)
8010294c:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
    acquire(&kmem.lock);
  
  refc = kmem.refc[pa / PGSIZE];
80102952:	c1 e8 0c             	shr    $0xc,%eax
80102955:	89 c3                	mov    %eax,%ebx
  if(kmem.use_lock)
80102957:	85 c9                	test   %ecx,%ecx
80102959:	75 15                	jne    80102970 <get_refc+0x50>
  refc = kmem.refc[pa / PGSIZE];
8010295b:	8b 04 85 80 26 11 80 	mov    -0x7feed980(,%eax,4),%eax

  if(kmem.use_lock)
    release(&kmem.lock);
  
  return refc;
}
80102962:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102965:	c9                   	leave  
80102966:	c3                   	ret    
80102967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010296e:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
80102970:	83 ec 0c             	sub    $0xc,%esp
80102973:	68 40 26 11 80       	push   $0x80112640
80102978:	e8 43 1f 00 00       	call   801048c0 <acquire>
  if(kmem.use_lock)
8010297d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  refc = kmem.refc[pa / PGSIZE];
80102983:	8b 04 9d 80 26 11 80 	mov    -0x7feed980(,%ebx,4),%eax
  if(kmem.use_lock)
8010298a:	83 c4 10             	add    $0x10,%esp
8010298d:	85 d2                	test   %edx,%edx
8010298f:	74 d1                	je     80102962 <get_refc+0x42>
    release(&kmem.lock);
80102991:	83 ec 0c             	sub    $0xc,%esp
80102994:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102997:	68 40 26 11 80       	push   $0x80112640
8010299c:	e8 bf 1e 00 00       	call   80104860 <release>
  return refc;
801029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801029a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    release(&kmem.lock);
801029a7:	83 c4 10             	add    $0x10,%esp
}
801029aa:	c9                   	leave  
801029ab:	c3                   	ret    
    panic("get_refc");
801029ac:	83 ec 0c             	sub    $0xc,%esp
801029af:	68 e7 79 10 80       	push   $0x801079e7
801029b4:	e8 c7 d9 ff ff       	call   80100380 <panic>
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801029c0 <sys_countfp>:

int 
sys_countfp(void)
{ 
  int fpc;
  if(kmem.use_lock)
801029c0:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
    acquire(&kmem.lock);
  fpc = kmem.fpc;
801029c6:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  if(kmem.use_lock)
801029cb:	85 c9                	test   %ecx,%ecx
801029cd:	75 01                	jne    801029d0 <sys_countfp+0x10>
  if (kmem.use_lock)
    release(&kmem.lock);
  return fpc;
}
801029cf:	c3                   	ret    
{ 
801029d0:	55                   	push   %ebp
801029d1:	89 e5                	mov    %esp,%ebp
801029d3:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801029d6:	68 40 26 11 80       	push   $0x80112640
801029db:	e8 e0 1e 00 00       	call   801048c0 <acquire>
  if (kmem.use_lock)
801029e0:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  fpc = kmem.fpc;
801029e6:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  if (kmem.use_lock)
801029eb:	83 c4 10             	add    $0x10,%esp
801029ee:	85 d2                	test   %edx,%edx
801029f0:	74 16                	je     80102a08 <sys_countfp+0x48>
    release(&kmem.lock);
801029f2:	83 ec 0c             	sub    $0xc,%esp
801029f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029f8:	68 40 26 11 80       	push   $0x80112640
801029fd:	e8 5e 1e 00 00       	call   80104860 <release>
80102a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a05:	83 c4 10             	add    $0x10,%esp
}
80102a08:	c9                   	leave  
80102a09:	c3                   	ret    
80102a0a:	66 90                	xchg   %ax,%ax
80102a0c:	66 90                	xchg   %ax,%ax
80102a0e:	66 90                	xchg   %ax,%ax

80102a10 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	ba 64 00 00 00       	mov    $0x64,%edx
80102a15:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102a16:	a8 01                	test   $0x1,%al
80102a18:	0f 84 c2 00 00 00    	je     80102ae0 <kbdgetc+0xd0>
{
80102a1e:	55                   	push   %ebp
80102a1f:	ba 60 00 00 00       	mov    $0x60,%edx
80102a24:	89 e5                	mov    %esp,%ebp
80102a26:	53                   	push   %ebx
80102a27:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102a28:	8b 1d 80 a6 14 80    	mov    0x8014a680,%ebx
  data = inb(KBDATAP);
80102a2e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102a31:	3c e0                	cmp    $0xe0,%al
80102a33:	74 5b                	je     80102a90 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102a35:	89 da                	mov    %ebx,%edx
80102a37:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102a3a:	84 c0                	test   %al,%al
80102a3c:	78 62                	js     80102aa0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102a3e:	85 d2                	test   %edx,%edx
80102a40:	74 09                	je     80102a4b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102a42:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102a45:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102a48:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102a4b:	0f b6 91 20 7b 10 80 	movzbl -0x7fef84e0(%ecx),%edx
  shift ^= togglecode[data];
80102a52:	0f b6 81 20 7a 10 80 	movzbl -0x7fef85e0(%ecx),%eax
  shift |= shiftcode[data];
80102a59:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102a5b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a5d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102a5f:	89 15 80 a6 14 80    	mov    %edx,0x8014a680
  c = charcode[shift & (CTL | SHIFT)][data];
80102a65:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102a68:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a6b:	8b 04 85 00 7a 10 80 	mov    -0x7fef8600(,%eax,4),%eax
80102a72:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102a76:	74 0b                	je     80102a83 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102a78:	8d 50 9f             	lea    -0x61(%eax),%edx
80102a7b:	83 fa 19             	cmp    $0x19,%edx
80102a7e:	77 48                	ja     80102ac8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102a80:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a86:	c9                   	leave  
80102a87:	c3                   	ret    
80102a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a8f:	90                   	nop
    shift |= E0ESC;
80102a90:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102a93:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102a95:	89 1d 80 a6 14 80    	mov    %ebx,0x8014a680
}
80102a9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a9e:	c9                   	leave  
80102a9f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102aa0:	83 e0 7f             	and    $0x7f,%eax
80102aa3:	85 d2                	test   %edx,%edx
80102aa5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102aa8:	0f b6 81 20 7b 10 80 	movzbl -0x7fef84e0(%ecx),%eax
80102aaf:	83 c8 40             	or     $0x40,%eax
80102ab2:	0f b6 c0             	movzbl %al,%eax
80102ab5:	f7 d0                	not    %eax
80102ab7:	21 d8                	and    %ebx,%eax
}
80102ab9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102abc:	a3 80 a6 14 80       	mov    %eax,0x8014a680
    return 0;
80102ac1:	31 c0                	xor    %eax,%eax
}
80102ac3:	c9                   	leave  
80102ac4:	c3                   	ret    
80102ac5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102ac8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102acb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ad1:	c9                   	leave  
      c += 'a' - 'A';
80102ad2:	83 f9 1a             	cmp    $0x1a,%ecx
80102ad5:	0f 42 c2             	cmovb  %edx,%eax
}
80102ad8:	c3                   	ret    
80102ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ae5:	c3                   	ret    
80102ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aed:	8d 76 00             	lea    0x0(%esi),%esi

80102af0 <kbdintr>:

void
kbdintr(void)
{
80102af0:	55                   	push   %ebp
80102af1:	89 e5                	mov    %esp,%ebp
80102af3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102af6:	68 10 2a 10 80       	push   $0x80102a10
80102afb:	e8 80 dd ff ff       	call   80100880 <consoleintr>
}
80102b00:	83 c4 10             	add    $0x10,%esp
80102b03:	c9                   	leave  
80102b04:	c3                   	ret    
80102b05:	66 90                	xchg   %ax,%ax
80102b07:	66 90                	xchg   %ax,%ax
80102b09:	66 90                	xchg   %ax,%ax
80102b0b:	66 90                	xchg   %ax,%ax
80102b0d:	66 90                	xchg   %ax,%ax
80102b0f:	90                   	nop

80102b10 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102b10:	a1 84 a6 14 80       	mov    0x8014a684,%eax
80102b15:	85 c0                	test   %eax,%eax
80102b17:	0f 84 cb 00 00 00    	je     80102be8 <lapicinit+0xd8>
  lapic[index] = value;
80102b1d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102b24:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b27:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b2a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102b31:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b34:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b37:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102b3e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102b41:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b44:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102b4b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102b4e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b51:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102b58:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b5b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b5e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102b65:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b68:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b6b:	8b 50 30             	mov    0x30(%eax),%edx
80102b6e:	c1 ea 10             	shr    $0x10,%edx
80102b71:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102b77:	75 77                	jne    80102bf0 <lapicinit+0xe0>
  lapic[index] = value;
80102b79:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102b80:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b83:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b86:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b8d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b90:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b93:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b9a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b9d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ba0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ba7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102baa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bad:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102bb4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bba:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102bc1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc4:	8b 50 20             	mov    0x20(%eax),%edx
80102bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bce:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102bd0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102bd6:	80 e6 10             	and    $0x10,%dh
80102bd9:	75 f5                	jne    80102bd0 <lapicinit+0xc0>
  lapic[index] = value;
80102bdb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102be2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102be5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102be8:	c3                   	ret    
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102bf0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102bf7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bfa:	8b 50 20             	mov    0x20(%eax),%edx
}
80102bfd:	e9 77 ff ff ff       	jmp    80102b79 <lapicinit+0x69>
80102c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c10 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102c10:	a1 84 a6 14 80       	mov    0x8014a684,%eax
80102c15:	85 c0                	test   %eax,%eax
80102c17:	74 07                	je     80102c20 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102c19:	8b 40 20             	mov    0x20(%eax),%eax
80102c1c:	c1 e8 18             	shr    $0x18,%eax
80102c1f:	c3                   	ret    
    return 0;
80102c20:	31 c0                	xor    %eax,%eax
}
80102c22:	c3                   	ret    
80102c23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c30 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102c30:	a1 84 a6 14 80       	mov    0x8014a684,%eax
80102c35:	85 c0                	test   %eax,%eax
80102c37:	74 0d                	je     80102c46 <lapiceoi+0x16>
  lapic[index] = value;
80102c39:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c40:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c43:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102c46:	c3                   	ret    
80102c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c4e:	66 90                	xchg   %ax,%ax

80102c50 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102c50:	c3                   	ret    
80102c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop

80102c60 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c60:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c61:	b8 0f 00 00 00       	mov    $0xf,%eax
80102c66:	ba 70 00 00 00       	mov    $0x70,%edx
80102c6b:	89 e5                	mov    %esp,%ebp
80102c6d:	53                   	push   %ebx
80102c6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102c71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c74:	ee                   	out    %al,(%dx)
80102c75:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c7a:	ba 71 00 00 00       	mov    $0x71,%edx
80102c7f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102c80:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102c82:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102c85:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102c8b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c8d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102c90:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102c92:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c95:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102c98:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102c9e:	a1 84 a6 14 80       	mov    0x8014a684,%eax
80102ca3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ca9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cac:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102cb3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cb6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cb9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102cc0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cc3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cc6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ccc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ccf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cd5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cd8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cde:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ce1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ce7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102cea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ced:	c9                   	leave  
80102cee:	c3                   	ret    
80102cef:	90                   	nop

80102cf0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102cf0:	55                   	push   %ebp
80102cf1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102cf6:	ba 70 00 00 00       	mov    $0x70,%edx
80102cfb:	89 e5                	mov    %esp,%ebp
80102cfd:	57                   	push   %edi
80102cfe:	56                   	push   %esi
80102cff:	53                   	push   %ebx
80102d00:	83 ec 4c             	sub    $0x4c,%esp
80102d03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d04:	ba 71 00 00 00       	mov    $0x71,%edx
80102d09:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102d0a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d0d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102d12:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102d15:	8d 76 00             	lea    0x0(%esi),%esi
80102d18:	31 c0                	xor    %eax,%eax
80102d1a:	89 da                	mov    %ebx,%edx
80102d1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d1d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102d22:	89 ca                	mov    %ecx,%edx
80102d24:	ec                   	in     (%dx),%al
80102d25:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d28:	89 da                	mov    %ebx,%edx
80102d2a:	b8 02 00 00 00       	mov    $0x2,%eax
80102d2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d30:	89 ca                	mov    %ecx,%edx
80102d32:	ec                   	in     (%dx),%al
80102d33:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d36:	89 da                	mov    %ebx,%edx
80102d38:	b8 04 00 00 00       	mov    $0x4,%eax
80102d3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d3e:	89 ca                	mov    %ecx,%edx
80102d40:	ec                   	in     (%dx),%al
80102d41:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d44:	89 da                	mov    %ebx,%edx
80102d46:	b8 07 00 00 00       	mov    $0x7,%eax
80102d4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d4c:	89 ca                	mov    %ecx,%edx
80102d4e:	ec                   	in     (%dx),%al
80102d4f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d52:	89 da                	mov    %ebx,%edx
80102d54:	b8 08 00 00 00       	mov    $0x8,%eax
80102d59:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d5a:	89 ca                	mov    %ecx,%edx
80102d5c:	ec                   	in     (%dx),%al
80102d5d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d5f:	89 da                	mov    %ebx,%edx
80102d61:	b8 09 00 00 00       	mov    $0x9,%eax
80102d66:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d67:	89 ca                	mov    %ecx,%edx
80102d69:	ec                   	in     (%dx),%al
80102d6a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d6c:	89 da                	mov    %ebx,%edx
80102d6e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d74:	89 ca                	mov    %ecx,%edx
80102d76:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102d77:	84 c0                	test   %al,%al
80102d79:	78 9d                	js     80102d18 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102d7b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102d7f:	89 fa                	mov    %edi,%edx
80102d81:	0f b6 fa             	movzbl %dl,%edi
80102d84:	89 f2                	mov    %esi,%edx
80102d86:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102d89:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102d8d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d90:	89 da                	mov    %ebx,%edx
80102d92:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102d95:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102d98:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102d9c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102d9f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102da2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102da6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102da9:	31 c0                	xor    %eax,%eax
80102dab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dac:	89 ca                	mov    %ecx,%edx
80102dae:	ec                   	in     (%dx),%al
80102daf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db2:	89 da                	mov    %ebx,%edx
80102db4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102db7:	b8 02 00 00 00       	mov    $0x2,%eax
80102dbc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dbd:	89 ca                	mov    %ecx,%edx
80102dbf:	ec                   	in     (%dx),%al
80102dc0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc3:	89 da                	mov    %ebx,%edx
80102dc5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102dc8:	b8 04 00 00 00       	mov    $0x4,%eax
80102dcd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dce:	89 ca                	mov    %ecx,%edx
80102dd0:	ec                   	in     (%dx),%al
80102dd1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dd4:	89 da                	mov    %ebx,%edx
80102dd6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102dd9:	b8 07 00 00 00       	mov    $0x7,%eax
80102dde:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ddf:	89 ca                	mov    %ecx,%edx
80102de1:	ec                   	in     (%dx),%al
80102de2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102de5:	89 da                	mov    %ebx,%edx
80102de7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102dea:	b8 08 00 00 00       	mov    $0x8,%eax
80102def:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102df0:	89 ca                	mov    %ecx,%edx
80102df2:	ec                   	in     (%dx),%al
80102df3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102df6:	89 da                	mov    %ebx,%edx
80102df8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102dfb:	b8 09 00 00 00       	mov    $0x9,%eax
80102e00:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e01:	89 ca                	mov    %ecx,%edx
80102e03:	ec                   	in     (%dx),%al
80102e04:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e07:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102e0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e0d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102e10:	6a 18                	push   $0x18
80102e12:	50                   	push   %eax
80102e13:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102e16:	50                   	push   %eax
80102e17:	e8 b4 1b 00 00       	call   801049d0 <memcmp>
80102e1c:	83 c4 10             	add    $0x10,%esp
80102e1f:	85 c0                	test   %eax,%eax
80102e21:	0f 85 f1 fe ff ff    	jne    80102d18 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102e27:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102e2b:	75 78                	jne    80102ea5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102e2d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e30:	89 c2                	mov    %eax,%edx
80102e32:	83 e0 0f             	and    $0xf,%eax
80102e35:	c1 ea 04             	shr    $0x4,%edx
80102e38:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e3b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102e41:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e44:	89 c2                	mov    %eax,%edx
80102e46:	83 e0 0f             	and    $0xf,%eax
80102e49:	c1 ea 04             	shr    $0x4,%edx
80102e4c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e4f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e52:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102e55:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e58:	89 c2                	mov    %eax,%edx
80102e5a:	83 e0 0f             	and    $0xf,%eax
80102e5d:	c1 ea 04             	shr    $0x4,%edx
80102e60:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e63:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e66:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102e69:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e6c:	89 c2                	mov    %eax,%edx
80102e6e:	83 e0 0f             	and    $0xf,%eax
80102e71:	c1 ea 04             	shr    $0x4,%edx
80102e74:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e77:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e7a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102e7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e80:	89 c2                	mov    %eax,%edx
80102e82:	83 e0 0f             	and    $0xf,%eax
80102e85:	c1 ea 04             	shr    $0x4,%edx
80102e88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e8e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102e91:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e94:	89 c2                	mov    %eax,%edx
80102e96:	83 e0 0f             	and    $0xf,%eax
80102e99:	c1 ea 04             	shr    $0x4,%edx
80102e9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ea2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ea5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ea8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102eab:	89 06                	mov    %eax,(%esi)
80102ead:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102eb0:	89 46 04             	mov    %eax,0x4(%esi)
80102eb3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102eb6:	89 46 08             	mov    %eax,0x8(%esi)
80102eb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ebc:	89 46 0c             	mov    %eax,0xc(%esi)
80102ebf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ec2:	89 46 10             	mov    %eax,0x10(%esi)
80102ec5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ec8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102ecb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ed2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ed5:	5b                   	pop    %ebx
80102ed6:	5e                   	pop    %esi
80102ed7:	5f                   	pop    %edi
80102ed8:	5d                   	pop    %ebp
80102ed9:	c3                   	ret    
80102eda:	66 90                	xchg   %ax,%ax
80102edc:	66 90                	xchg   %ax,%ax
80102ede:	66 90                	xchg   %ax,%ax

80102ee0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ee0:	8b 0d e8 a6 14 80    	mov    0x8014a6e8,%ecx
80102ee6:	85 c9                	test   %ecx,%ecx
80102ee8:	0f 8e 8a 00 00 00    	jle    80102f78 <install_trans+0x98>
{
80102eee:	55                   	push   %ebp
80102eef:	89 e5                	mov    %esp,%ebp
80102ef1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ef2:	31 ff                	xor    %edi,%edi
{
80102ef4:	56                   	push   %esi
80102ef5:	53                   	push   %ebx
80102ef6:	83 ec 0c             	sub    $0xc,%esp
80102ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102f00:	a1 d4 a6 14 80       	mov    0x8014a6d4,%eax
80102f05:	83 ec 08             	sub    $0x8,%esp
80102f08:	01 f8                	add    %edi,%eax
80102f0a:	83 c0 01             	add    $0x1,%eax
80102f0d:	50                   	push   %eax
80102f0e:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80102f14:	e8 b7 d1 ff ff       	call   801000d0 <bread>
80102f19:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f1b:	58                   	pop    %eax
80102f1c:	5a                   	pop    %edx
80102f1d:	ff 34 bd ec a6 14 80 	push   -0x7feb5914(,%edi,4)
80102f24:	ff 35 e4 a6 14 80    	push   0x8014a6e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f2a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f2d:	e8 9e d1 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f32:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f35:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f37:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f3a:	68 00 02 00 00       	push   $0x200
80102f3f:	50                   	push   %eax
80102f40:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102f43:	50                   	push   %eax
80102f44:	e8 d7 1a 00 00       	call   80104a20 <memmove>
    bwrite(dbuf);  // write dst to disk
80102f49:	89 1c 24             	mov    %ebx,(%esp)
80102f4c:	e8 5f d2 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102f51:	89 34 24             	mov    %esi,(%esp)
80102f54:	e8 97 d2 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102f59:	89 1c 24             	mov    %ebx,(%esp)
80102f5c:	e8 8f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f61:	83 c4 10             	add    $0x10,%esp
80102f64:	39 3d e8 a6 14 80    	cmp    %edi,0x8014a6e8
80102f6a:	7f 94                	jg     80102f00 <install_trans+0x20>
  }
}
80102f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f6f:	5b                   	pop    %ebx
80102f70:	5e                   	pop    %esi
80102f71:	5f                   	pop    %edi
80102f72:	5d                   	pop    %ebp
80102f73:	c3                   	ret    
80102f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f78:	c3                   	ret    
80102f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	53                   	push   %ebx
80102f84:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f87:	ff 35 d4 a6 14 80    	push   0x8014a6d4
80102f8d:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80102f93:	e8 38 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102f98:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f9b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102f9d:	a1 e8 a6 14 80       	mov    0x8014a6e8,%eax
80102fa2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102fa5:	85 c0                	test   %eax,%eax
80102fa7:	7e 19                	jle    80102fc2 <write_head+0x42>
80102fa9:	31 d2                	xor    %edx,%edx
80102fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102faf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102fb0:	8b 0c 95 ec a6 14 80 	mov    -0x7feb5914(,%edx,4),%ecx
80102fb7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102fbb:	83 c2 01             	add    $0x1,%edx
80102fbe:	39 d0                	cmp    %edx,%eax
80102fc0:	75 ee                	jne    80102fb0 <write_head+0x30>
  }
  bwrite(buf);
80102fc2:	83 ec 0c             	sub    $0xc,%esp
80102fc5:	53                   	push   %ebx
80102fc6:	e8 e5 d1 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102fcb:	89 1c 24             	mov    %ebx,(%esp)
80102fce:	e8 1d d2 ff ff       	call   801001f0 <brelse>
}
80102fd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fd6:	83 c4 10             	add    $0x10,%esp
80102fd9:	c9                   	leave  
80102fda:	c3                   	ret    
80102fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fdf:	90                   	nop

80102fe0 <initlog>:
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	53                   	push   %ebx
80102fe4:	83 ec 2c             	sub    $0x2c,%esp
80102fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102fea:	68 20 7c 10 80       	push   $0x80107c20
80102fef:	68 a0 a6 14 80       	push   $0x8014a6a0
80102ff4:	e8 f7 16 00 00       	call   801046f0 <initlock>
  readsb(dev, &sb);
80102ff9:	58                   	pop    %eax
80102ffa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ffd:	5a                   	pop    %edx
80102ffe:	50                   	push   %eax
80102fff:	53                   	push   %ebx
80103000:	e8 1b e5 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80103005:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103008:	59                   	pop    %ecx
  log.dev = dev;
80103009:	89 1d e4 a6 14 80    	mov    %ebx,0x8014a6e4
  log.size = sb.nlog;
8010300f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103012:	a3 d4 a6 14 80       	mov    %eax,0x8014a6d4
  log.size = sb.nlog;
80103017:	89 15 d8 a6 14 80    	mov    %edx,0x8014a6d8
  struct buf *buf = bread(log.dev, log.start);
8010301d:	5a                   	pop    %edx
8010301e:	50                   	push   %eax
8010301f:	53                   	push   %ebx
80103020:	e8 ab d0 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103025:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103028:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010302b:	89 1d e8 a6 14 80    	mov    %ebx,0x8014a6e8
  for (i = 0; i < log.lh.n; i++) {
80103031:	85 db                	test   %ebx,%ebx
80103033:	7e 1d                	jle    80103052 <initlog+0x72>
80103035:	31 d2                	xor    %edx,%edx
80103037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010303e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80103040:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80103044:	89 0c 95 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010304b:	83 c2 01             	add    $0x1,%edx
8010304e:	39 d3                	cmp    %edx,%ebx
80103050:	75 ee                	jne    80103040 <initlog+0x60>
  brelse(buf);
80103052:	83 ec 0c             	sub    $0xc,%esp
80103055:	50                   	push   %eax
80103056:	e8 95 d1 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010305b:	e8 80 fe ff ff       	call   80102ee0 <install_trans>
  log.lh.n = 0;
80103060:	c7 05 e8 a6 14 80 00 	movl   $0x0,0x8014a6e8
80103067:	00 00 00 
  write_head(); // clear the log
8010306a:	e8 11 ff ff ff       	call   80102f80 <write_head>
}
8010306f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103072:	83 c4 10             	add    $0x10,%esp
80103075:	c9                   	leave  
80103076:	c3                   	ret    
80103077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010307e:	66 90                	xchg   %ax,%ax

80103080 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103086:	68 a0 a6 14 80       	push   $0x8014a6a0
8010308b:	e8 30 18 00 00       	call   801048c0 <acquire>
80103090:	83 c4 10             	add    $0x10,%esp
80103093:	eb 18                	jmp    801030ad <begin_op+0x2d>
80103095:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103098:	83 ec 08             	sub    $0x8,%esp
8010309b:	68 a0 a6 14 80       	push   $0x8014a6a0
801030a0:	68 a0 a6 14 80       	push   $0x8014a6a0
801030a5:	e8 b6 12 00 00       	call   80104360 <sleep>
801030aa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801030ad:	a1 e0 a6 14 80       	mov    0x8014a6e0,%eax
801030b2:	85 c0                	test   %eax,%eax
801030b4:	75 e2                	jne    80103098 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801030b6:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
801030bb:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
801030c1:	83 c0 01             	add    $0x1,%eax
801030c4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801030c7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801030ca:	83 fa 1e             	cmp    $0x1e,%edx
801030cd:	7f c9                	jg     80103098 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801030cf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801030d2:	a3 dc a6 14 80       	mov    %eax,0x8014a6dc
      release(&log.lock);
801030d7:	68 a0 a6 14 80       	push   $0x8014a6a0
801030dc:	e8 7f 17 00 00       	call   80104860 <release>
      break;
    }
  }
}
801030e1:	83 c4 10             	add    $0x10,%esp
801030e4:	c9                   	leave  
801030e5:	c3                   	ret    
801030e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ed:	8d 76 00             	lea    0x0(%esi),%esi

801030f0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	57                   	push   %edi
801030f4:	56                   	push   %esi
801030f5:	53                   	push   %ebx
801030f6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801030f9:	68 a0 a6 14 80       	push   $0x8014a6a0
801030fe:	e8 bd 17 00 00       	call   801048c0 <acquire>
  log.outstanding -= 1;
80103103:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
  if(log.committing)
80103108:	8b 35 e0 a6 14 80    	mov    0x8014a6e0,%esi
8010310e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103111:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103114:	89 1d dc a6 14 80    	mov    %ebx,0x8014a6dc
  if(log.committing)
8010311a:	85 f6                	test   %esi,%esi
8010311c:	0f 85 22 01 00 00    	jne    80103244 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103122:	85 db                	test   %ebx,%ebx
80103124:	0f 85 f6 00 00 00    	jne    80103220 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010312a:	c7 05 e0 a6 14 80 01 	movl   $0x1,0x8014a6e0
80103131:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103134:	83 ec 0c             	sub    $0xc,%esp
80103137:	68 a0 a6 14 80       	push   $0x8014a6a0
8010313c:	e8 1f 17 00 00       	call   80104860 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103141:	8b 0d e8 a6 14 80    	mov    0x8014a6e8,%ecx
80103147:	83 c4 10             	add    $0x10,%esp
8010314a:	85 c9                	test   %ecx,%ecx
8010314c:	7f 42                	jg     80103190 <end_op+0xa0>
    acquire(&log.lock);
8010314e:	83 ec 0c             	sub    $0xc,%esp
80103151:	68 a0 a6 14 80       	push   $0x8014a6a0
80103156:	e8 65 17 00 00       	call   801048c0 <acquire>
    wakeup(&log);
8010315b:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
    log.committing = 0;
80103162:	c7 05 e0 a6 14 80 00 	movl   $0x0,0x8014a6e0
80103169:	00 00 00 
    wakeup(&log);
8010316c:	e8 af 12 00 00       	call   80104420 <wakeup>
    release(&log.lock);
80103171:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
80103178:	e8 e3 16 00 00       	call   80104860 <release>
8010317d:	83 c4 10             	add    $0x10,%esp
}
80103180:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103183:	5b                   	pop    %ebx
80103184:	5e                   	pop    %esi
80103185:	5f                   	pop    %edi
80103186:	5d                   	pop    %ebp
80103187:	c3                   	ret    
80103188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010318f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103190:	a1 d4 a6 14 80       	mov    0x8014a6d4,%eax
80103195:	83 ec 08             	sub    $0x8,%esp
80103198:	01 d8                	add    %ebx,%eax
8010319a:	83 c0 01             	add    $0x1,%eax
8010319d:	50                   	push   %eax
8010319e:	ff 35 e4 a6 14 80    	push   0x8014a6e4
801031a4:	e8 27 cf ff ff       	call   801000d0 <bread>
801031a9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031ab:	58                   	pop    %eax
801031ac:	5a                   	pop    %edx
801031ad:	ff 34 9d ec a6 14 80 	push   -0x7feb5914(,%ebx,4)
801031b4:	ff 35 e4 a6 14 80    	push   0x8014a6e4
  for (tail = 0; tail < log.lh.n; tail++) {
801031ba:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031bd:	e8 0e cf ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801031c2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031c5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801031c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801031ca:	68 00 02 00 00       	push   $0x200
801031cf:	50                   	push   %eax
801031d0:	8d 46 5c             	lea    0x5c(%esi),%eax
801031d3:	50                   	push   %eax
801031d4:	e8 47 18 00 00       	call   80104a20 <memmove>
    bwrite(to);  // write the log
801031d9:	89 34 24             	mov    %esi,(%esp)
801031dc:	e8 cf cf ff ff       	call   801001b0 <bwrite>
    brelse(from);
801031e1:	89 3c 24             	mov    %edi,(%esp)
801031e4:	e8 07 d0 ff ff       	call   801001f0 <brelse>
    brelse(to);
801031e9:	89 34 24             	mov    %esi,(%esp)
801031ec:	e8 ff cf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801031f1:	83 c4 10             	add    $0x10,%esp
801031f4:	3b 1d e8 a6 14 80    	cmp    0x8014a6e8,%ebx
801031fa:	7c 94                	jl     80103190 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801031fc:	e8 7f fd ff ff       	call   80102f80 <write_head>
    install_trans(); // Now install writes to home locations
80103201:	e8 da fc ff ff       	call   80102ee0 <install_trans>
    log.lh.n = 0;
80103206:	c7 05 e8 a6 14 80 00 	movl   $0x0,0x8014a6e8
8010320d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103210:	e8 6b fd ff ff       	call   80102f80 <write_head>
80103215:	e9 34 ff ff ff       	jmp    8010314e <end_op+0x5e>
8010321a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103220:	83 ec 0c             	sub    $0xc,%esp
80103223:	68 a0 a6 14 80       	push   $0x8014a6a0
80103228:	e8 f3 11 00 00       	call   80104420 <wakeup>
  release(&log.lock);
8010322d:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
80103234:	e8 27 16 00 00       	call   80104860 <release>
80103239:	83 c4 10             	add    $0x10,%esp
}
8010323c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010323f:	5b                   	pop    %ebx
80103240:	5e                   	pop    %esi
80103241:	5f                   	pop    %edi
80103242:	5d                   	pop    %ebp
80103243:	c3                   	ret    
    panic("log.committing");
80103244:	83 ec 0c             	sub    $0xc,%esp
80103247:	68 24 7c 10 80       	push   $0x80107c24
8010324c:	e8 2f d1 ff ff       	call   80100380 <panic>
80103251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010325f:	90                   	nop

80103260 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	53                   	push   %ebx
80103264:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103267:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
{
8010326d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103270:	83 fa 1d             	cmp    $0x1d,%edx
80103273:	0f 8f 85 00 00 00    	jg     801032fe <log_write+0x9e>
80103279:	a1 d8 a6 14 80       	mov    0x8014a6d8,%eax
8010327e:	83 e8 01             	sub    $0x1,%eax
80103281:	39 c2                	cmp    %eax,%edx
80103283:	7d 79                	jge    801032fe <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103285:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
8010328a:	85 c0                	test   %eax,%eax
8010328c:	7e 7d                	jle    8010330b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010328e:	83 ec 0c             	sub    $0xc,%esp
80103291:	68 a0 a6 14 80       	push   $0x8014a6a0
80103296:	e8 25 16 00 00       	call   801048c0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010329b:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
801032a1:	83 c4 10             	add    $0x10,%esp
801032a4:	85 d2                	test   %edx,%edx
801032a6:	7e 4a                	jle    801032f2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032a8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801032ab:	31 c0                	xor    %eax,%eax
801032ad:	eb 08                	jmp    801032b7 <log_write+0x57>
801032af:	90                   	nop
801032b0:	83 c0 01             	add    $0x1,%eax
801032b3:	39 c2                	cmp    %eax,%edx
801032b5:	74 29                	je     801032e0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032b7:	39 0c 85 ec a6 14 80 	cmp    %ecx,-0x7feb5914(,%eax,4)
801032be:	75 f0                	jne    801032b0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801032c0:	89 0c 85 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801032c7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801032ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801032cd:	c7 45 08 a0 a6 14 80 	movl   $0x8014a6a0,0x8(%ebp)
}
801032d4:	c9                   	leave  
  release(&log.lock);
801032d5:	e9 86 15 00 00       	jmp    80104860 <release>
801032da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801032e0:	89 0c 95 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%edx,4)
    log.lh.n++;
801032e7:	83 c2 01             	add    $0x1,%edx
801032ea:	89 15 e8 a6 14 80    	mov    %edx,0x8014a6e8
801032f0:	eb d5                	jmp    801032c7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801032f2:	8b 43 08             	mov    0x8(%ebx),%eax
801032f5:	a3 ec a6 14 80       	mov    %eax,0x8014a6ec
  if (i == log.lh.n)
801032fa:	75 cb                	jne    801032c7 <log_write+0x67>
801032fc:	eb e9                	jmp    801032e7 <log_write+0x87>
    panic("too big a transaction");
801032fe:	83 ec 0c             	sub    $0xc,%esp
80103301:	68 33 7c 10 80       	push   $0x80107c33
80103306:	e8 75 d0 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010330b:	83 ec 0c             	sub    $0xc,%esp
8010330e:	68 49 7c 10 80       	push   $0x80107c49
80103313:	e8 68 d0 ff ff       	call   80100380 <panic>
80103318:	66 90                	xchg   %ax,%ax
8010331a:	66 90                	xchg   %ax,%ax
8010331c:	66 90                	xchg   %ax,%ax
8010331e:	66 90                	xchg   %ax,%ax

80103320 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	53                   	push   %ebx
80103324:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103327:	e8 44 09 00 00       	call   80103c70 <cpuid>
8010332c:	89 c3                	mov    %eax,%ebx
8010332e:	e8 3d 09 00 00       	call   80103c70 <cpuid>
80103333:	83 ec 04             	sub    $0x4,%esp
80103336:	53                   	push   %ebx
80103337:	50                   	push   %eax
80103338:	68 64 7c 10 80       	push   $0x80107c64
8010333d:	e8 5e d3 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103342:	e8 b9 28 00 00       	call   80105c00 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103347:	e8 c4 08 00 00       	call   80103c10 <mycpu>
8010334c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010334e:	b8 01 00 00 00       	mov    $0x1,%eax
80103353:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010335a:	e8 f1 0b 00 00       	call   80103f50 <scheduler>
8010335f:	90                   	nop

80103360 <mpenter>:
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103366:	e8 c5 39 00 00       	call   80106d30 <switchkvm>
  seginit();
8010336b:	e8 30 39 00 00       	call   80106ca0 <seginit>
  lapicinit();
80103370:	e8 9b f7 ff ff       	call   80102b10 <lapicinit>
  mpmain();
80103375:	e8 a6 ff ff ff       	call   80103320 <mpmain>
8010337a:	66 90                	xchg   %ax,%ax
8010337c:	66 90                	xchg   %ax,%ax
8010337e:	66 90                	xchg   %ax,%ax

80103380 <main>:
{
80103380:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103384:	83 e4 f0             	and    $0xfffffff0,%esp
80103387:	ff 71 fc             	push   -0x4(%ecx)
8010338a:	55                   	push   %ebp
8010338b:	89 e5                	mov    %esp,%ebp
8010338d:	53                   	push   %ebx
8010338e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010338f:	83 ec 08             	sub    $0x8,%esp
80103392:	68 00 00 40 80       	push   $0x80400000
80103397:	68 d0 e4 14 80       	push   $0x8014e4d0
8010339c:	e8 0f f3 ff ff       	call   801026b0 <kinit1>
  kvmalloc();      // kernel page table
801033a1:	e8 7a 3e 00 00       	call   80107220 <kvmalloc>
  mpinit();        // detect other processors
801033a6:	e8 85 01 00 00       	call   80103530 <mpinit>
  lapicinit();     // interrupt controller
801033ab:	e8 60 f7 ff ff       	call   80102b10 <lapicinit>
  seginit();       // segment descriptors
801033b0:	e8 eb 38 00 00       	call   80106ca0 <seginit>
  picinit();       // disable pic
801033b5:	e8 76 03 00 00       	call   80103730 <picinit>
  ioapicinit();    // another interrupt controller
801033ba:	e8 11 f0 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
801033bf:	e8 9c d6 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801033c4:	e8 47 2b 00 00       	call   80105f10 <uartinit>
  pinit();         // process table
801033c9:	e8 22 08 00 00       	call   80103bf0 <pinit>
  tvinit();        // trap vectors
801033ce:	e8 ad 27 00 00       	call   80105b80 <tvinit>
  binit();         // buffer cache
801033d3:	e8 68 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
801033d8:	e8 33 da ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801033dd:	e8 de ed ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801033e2:	83 c4 0c             	add    $0xc,%esp
801033e5:	68 8a 00 00 00       	push   $0x8a
801033ea:	68 8c b4 10 80       	push   $0x8010b48c
801033ef:	68 00 70 00 80       	push   $0x80007000
801033f4:	e8 27 16 00 00       	call   80104a20 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	69 05 84 a7 14 80 b0 	imul   $0xb0,0x8014a784,%eax
80103403:	00 00 00 
80103406:	05 a0 a7 14 80       	add    $0x8014a7a0,%eax
8010340b:	3d a0 a7 14 80       	cmp    $0x8014a7a0,%eax
80103410:	76 7e                	jbe    80103490 <main+0x110>
80103412:	bb a0 a7 14 80       	mov    $0x8014a7a0,%ebx
80103417:	eb 20                	jmp    80103439 <main+0xb9>
80103419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103420:	69 05 84 a7 14 80 b0 	imul   $0xb0,0x8014a784,%eax
80103427:	00 00 00 
8010342a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103430:	05 a0 a7 14 80       	add    $0x8014a7a0,%eax
80103435:	39 c3                	cmp    %eax,%ebx
80103437:	73 57                	jae    80103490 <main+0x110>
    if(c == mycpu())  // We've started already.
80103439:	e8 d2 07 00 00       	call   80103c10 <mycpu>
8010343e:	39 c3                	cmp    %eax,%ebx
80103440:	74 de                	je     80103420 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103442:	e8 09 f3 ff ff       	call   80102750 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103447:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010344a:	c7 05 f8 6f 00 80 60 	movl   $0x80103360,0x80006ff8
80103451:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103454:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010345b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010345e:	05 00 10 00 00       	add    $0x1000,%eax
80103463:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103468:	0f b6 03             	movzbl (%ebx),%eax
8010346b:	68 00 70 00 00       	push   $0x7000
80103470:	50                   	push   %eax
80103471:	e8 ea f7 ff ff       	call   80102c60 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103476:	83 c4 10             	add    $0x10,%esp
80103479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103480:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103486:	85 c0                	test   %eax,%eax
80103488:	74 f6                	je     80103480 <main+0x100>
8010348a:	eb 94                	jmp    80103420 <main+0xa0>
8010348c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103490:	83 ec 08             	sub    $0x8,%esp
80103493:	68 00 00 00 8e       	push   $0x8e000000
80103498:	68 00 00 40 80       	push   $0x80400000
8010349d:	e8 7e f1 ff ff       	call   80102620 <kinit2>
  userinit();      // first user process
801034a2:	e8 19 08 00 00       	call   80103cc0 <userinit>
  mpmain();        // finish this processor's setup
801034a7:	e8 74 fe ff ff       	call   80103320 <mpmain>
801034ac:	66 90                	xchg   %ax,%ax
801034ae:	66 90                	xchg   %ax,%ax

801034b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	57                   	push   %edi
801034b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801034b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801034bb:	53                   	push   %ebx
  e = addr+len;
801034bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801034bf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801034c2:	39 de                	cmp    %ebx,%esi
801034c4:	72 10                	jb     801034d6 <mpsearch1+0x26>
801034c6:	eb 50                	jmp    80103518 <mpsearch1+0x68>
801034c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034cf:	90                   	nop
801034d0:	89 fe                	mov    %edi,%esi
801034d2:	39 fb                	cmp    %edi,%ebx
801034d4:	76 42                	jbe    80103518 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034d6:	83 ec 04             	sub    $0x4,%esp
801034d9:	8d 7e 10             	lea    0x10(%esi),%edi
801034dc:	6a 04                	push   $0x4
801034de:	68 78 7c 10 80       	push   $0x80107c78
801034e3:	56                   	push   %esi
801034e4:	e8 e7 14 00 00       	call   801049d0 <memcmp>
801034e9:	83 c4 10             	add    $0x10,%esp
801034ec:	85 c0                	test   %eax,%eax
801034ee:	75 e0                	jne    801034d0 <mpsearch1+0x20>
801034f0:	89 f2                	mov    %esi,%edx
801034f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801034f8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801034fb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801034fe:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103500:	39 fa                	cmp    %edi,%edx
80103502:	75 f4                	jne    801034f8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103504:	84 c0                	test   %al,%al
80103506:	75 c8                	jne    801034d0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010350b:	89 f0                	mov    %esi,%eax
8010350d:	5b                   	pop    %ebx
8010350e:	5e                   	pop    %esi
8010350f:	5f                   	pop    %edi
80103510:	5d                   	pop    %ebp
80103511:	c3                   	ret    
80103512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103518:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010351b:	31 f6                	xor    %esi,%esi
}
8010351d:	5b                   	pop    %ebx
8010351e:	89 f0                	mov    %esi,%eax
80103520:	5e                   	pop    %esi
80103521:	5f                   	pop    %edi
80103522:	5d                   	pop    %ebp
80103523:	c3                   	ret    
80103524:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010352b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010352f:	90                   	nop

80103530 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	57                   	push   %edi
80103534:	56                   	push   %esi
80103535:	53                   	push   %ebx
80103536:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103539:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103540:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103547:	c1 e0 08             	shl    $0x8,%eax
8010354a:	09 d0                	or     %edx,%eax
8010354c:	c1 e0 04             	shl    $0x4,%eax
8010354f:	75 1b                	jne    8010356c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103551:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103558:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010355f:	c1 e0 08             	shl    $0x8,%eax
80103562:	09 d0                	or     %edx,%eax
80103564:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103567:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010356c:	ba 00 04 00 00       	mov    $0x400,%edx
80103571:	e8 3a ff ff ff       	call   801034b0 <mpsearch1>
80103576:	89 c3                	mov    %eax,%ebx
80103578:	85 c0                	test   %eax,%eax
8010357a:	0f 84 40 01 00 00    	je     801036c0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103580:	8b 73 04             	mov    0x4(%ebx),%esi
80103583:	85 f6                	test   %esi,%esi
80103585:	0f 84 25 01 00 00    	je     801036b0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010358b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010358e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103594:	6a 04                	push   $0x4
80103596:	68 7d 7c 10 80       	push   $0x80107c7d
8010359b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010359c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010359f:	e8 2c 14 00 00       	call   801049d0 <memcmp>
801035a4:	83 c4 10             	add    $0x10,%esp
801035a7:	85 c0                	test   %eax,%eax
801035a9:	0f 85 01 01 00 00    	jne    801036b0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801035af:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801035b6:	3c 01                	cmp    $0x1,%al
801035b8:	74 08                	je     801035c2 <mpinit+0x92>
801035ba:	3c 04                	cmp    $0x4,%al
801035bc:	0f 85 ee 00 00 00    	jne    801036b0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801035c2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801035c9:	66 85 d2             	test   %dx,%dx
801035cc:	74 22                	je     801035f0 <mpinit+0xc0>
801035ce:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801035d1:	89 f0                	mov    %esi,%eax
  sum = 0;
801035d3:	31 d2                	xor    %edx,%edx
801035d5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035d8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801035df:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801035e2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801035e4:	39 c7                	cmp    %eax,%edi
801035e6:	75 f0                	jne    801035d8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801035e8:	84 d2                	test   %dl,%dl
801035ea:	0f 85 c0 00 00 00    	jne    801036b0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801035f0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801035f6:	a3 84 a6 14 80       	mov    %eax,0x8014a684
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035fb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103602:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103608:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010360d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103610:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103613:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103617:	90                   	nop
80103618:	39 d0                	cmp    %edx,%eax
8010361a:	73 15                	jae    80103631 <mpinit+0x101>
    switch(*p){
8010361c:	0f b6 08             	movzbl (%eax),%ecx
8010361f:	80 f9 02             	cmp    $0x2,%cl
80103622:	74 4c                	je     80103670 <mpinit+0x140>
80103624:	77 3a                	ja     80103660 <mpinit+0x130>
80103626:	84 c9                	test   %cl,%cl
80103628:	74 56                	je     80103680 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010362a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010362d:	39 d0                	cmp    %edx,%eax
8010362f:	72 eb                	jb     8010361c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103631:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103634:	85 f6                	test   %esi,%esi
80103636:	0f 84 d9 00 00 00    	je     80103715 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010363c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103640:	74 15                	je     80103657 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103642:	b8 70 00 00 00       	mov    $0x70,%eax
80103647:	ba 22 00 00 00       	mov    $0x22,%edx
8010364c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010364d:	ba 23 00 00 00       	mov    $0x23,%edx
80103652:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103653:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103656:	ee                   	out    %al,(%dx)
  }
}
80103657:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010365a:	5b                   	pop    %ebx
8010365b:	5e                   	pop    %esi
8010365c:	5f                   	pop    %edi
8010365d:	5d                   	pop    %ebp
8010365e:	c3                   	ret    
8010365f:	90                   	nop
    switch(*p){
80103660:	83 e9 03             	sub    $0x3,%ecx
80103663:	80 f9 01             	cmp    $0x1,%cl
80103666:	76 c2                	jbe    8010362a <mpinit+0xfa>
80103668:	31 f6                	xor    %esi,%esi
8010366a:	eb ac                	jmp    80103618 <mpinit+0xe8>
8010366c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103670:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103674:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103677:	88 0d 80 a7 14 80    	mov    %cl,0x8014a780
      continue;
8010367d:	eb 99                	jmp    80103618 <mpinit+0xe8>
8010367f:	90                   	nop
      if(ncpu < NCPU) {
80103680:	8b 0d 84 a7 14 80    	mov    0x8014a784,%ecx
80103686:	83 f9 07             	cmp    $0x7,%ecx
80103689:	7f 19                	jg     801036a4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010368b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103691:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103695:	83 c1 01             	add    $0x1,%ecx
80103698:	89 0d 84 a7 14 80    	mov    %ecx,0x8014a784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010369e:	88 9f a0 a7 14 80    	mov    %bl,-0x7feb5860(%edi)
      p += sizeof(struct mpproc);
801036a4:	83 c0 14             	add    $0x14,%eax
      continue;
801036a7:	e9 6c ff ff ff       	jmp    80103618 <mpinit+0xe8>
801036ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	68 82 7c 10 80       	push   $0x80107c82
801036b8:	e8 c3 cc ff ff       	call   80100380 <panic>
801036bd:	8d 76 00             	lea    0x0(%esi),%esi
{
801036c0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801036c5:	eb 13                	jmp    801036da <mpinit+0x1aa>
801036c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036ce:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801036d0:	89 f3                	mov    %esi,%ebx
801036d2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801036d8:	74 d6                	je     801036b0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036da:	83 ec 04             	sub    $0x4,%esp
801036dd:	8d 73 10             	lea    0x10(%ebx),%esi
801036e0:	6a 04                	push   $0x4
801036e2:	68 78 7c 10 80       	push   $0x80107c78
801036e7:	53                   	push   %ebx
801036e8:	e8 e3 12 00 00       	call   801049d0 <memcmp>
801036ed:	83 c4 10             	add    $0x10,%esp
801036f0:	85 c0                	test   %eax,%eax
801036f2:	75 dc                	jne    801036d0 <mpinit+0x1a0>
801036f4:	89 da                	mov    %ebx,%edx
801036f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036fd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103700:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103703:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103706:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103708:	39 d6                	cmp    %edx,%esi
8010370a:	75 f4                	jne    80103700 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010370c:	84 c0                	test   %al,%al
8010370e:	75 c0                	jne    801036d0 <mpinit+0x1a0>
80103710:	e9 6b fe ff ff       	jmp    80103580 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103715:	83 ec 0c             	sub    $0xc,%esp
80103718:	68 9c 7c 10 80       	push   $0x80107c9c
8010371d:	e8 5e cc ff ff       	call   80100380 <panic>
80103722:	66 90                	xchg   %ax,%ax
80103724:	66 90                	xchg   %ax,%ax
80103726:	66 90                	xchg   %ax,%ax
80103728:	66 90                	xchg   %ax,%ax
8010372a:	66 90                	xchg   %ax,%ax
8010372c:	66 90                	xchg   %ax,%ax
8010372e:	66 90                	xchg   %ax,%ax

80103730 <picinit>:
80103730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103735:	ba 21 00 00 00       	mov    $0x21,%edx
8010373a:	ee                   	out    %al,(%dx)
8010373b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103740:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103741:	c3                   	ret    
80103742:	66 90                	xchg   %ax,%ax
80103744:	66 90                	xchg   %ax,%ax
80103746:	66 90                	xchg   %ax,%ax
80103748:	66 90                	xchg   %ax,%ax
8010374a:	66 90                	xchg   %ax,%ax
8010374c:	66 90                	xchg   %ax,%ax
8010374e:	66 90                	xchg   %ax,%ax

80103750 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	57                   	push   %edi
80103754:	56                   	push   %esi
80103755:	53                   	push   %ebx
80103756:	83 ec 0c             	sub    $0xc,%esp
80103759:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010375c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010375f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103765:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010376b:	e8 c0 d6 ff ff       	call   80100e30 <filealloc>
80103770:	89 03                	mov    %eax,(%ebx)
80103772:	85 c0                	test   %eax,%eax
80103774:	0f 84 a8 00 00 00    	je     80103822 <pipealloc+0xd2>
8010377a:	e8 b1 d6 ff ff       	call   80100e30 <filealloc>
8010377f:	89 06                	mov    %eax,(%esi)
80103781:	85 c0                	test   %eax,%eax
80103783:	0f 84 87 00 00 00    	je     80103810 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103789:	e8 c2 ef ff ff       	call   80102750 <kalloc>
8010378e:	89 c7                	mov    %eax,%edi
80103790:	85 c0                	test   %eax,%eax
80103792:	0f 84 b0 00 00 00    	je     80103848 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103798:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010379f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801037a2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801037a5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801037ac:	00 00 00 
  p->nwrite = 0;
801037af:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801037b6:	00 00 00 
  p->nread = 0;
801037b9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801037c0:	00 00 00 
  initlock(&p->lock, "pipe");
801037c3:	68 bb 7c 10 80       	push   $0x80107cbb
801037c8:	50                   	push   %eax
801037c9:	e8 22 0f 00 00       	call   801046f0 <initlock>
  (*f0)->type = FD_PIPE;
801037ce:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801037d0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801037d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801037d9:	8b 03                	mov    (%ebx),%eax
801037db:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801037df:	8b 03                	mov    (%ebx),%eax
801037e1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801037e5:	8b 03                	mov    (%ebx),%eax
801037e7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801037ea:	8b 06                	mov    (%esi),%eax
801037ec:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801037f2:	8b 06                	mov    (%esi),%eax
801037f4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801037f8:	8b 06                	mov    (%esi),%eax
801037fa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801037fe:	8b 06                	mov    (%esi),%eax
80103800:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103803:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103806:	31 c0                	xor    %eax,%eax
}
80103808:	5b                   	pop    %ebx
80103809:	5e                   	pop    %esi
8010380a:	5f                   	pop    %edi
8010380b:	5d                   	pop    %ebp
8010380c:	c3                   	ret    
8010380d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103810:	8b 03                	mov    (%ebx),%eax
80103812:	85 c0                	test   %eax,%eax
80103814:	74 1e                	je     80103834 <pipealloc+0xe4>
    fileclose(*f0);
80103816:	83 ec 0c             	sub    $0xc,%esp
80103819:	50                   	push   %eax
8010381a:	e8 d1 d6 ff ff       	call   80100ef0 <fileclose>
8010381f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103822:	8b 06                	mov    (%esi),%eax
80103824:	85 c0                	test   %eax,%eax
80103826:	74 0c                	je     80103834 <pipealloc+0xe4>
    fileclose(*f1);
80103828:	83 ec 0c             	sub    $0xc,%esp
8010382b:	50                   	push   %eax
8010382c:	e8 bf d6 ff ff       	call   80100ef0 <fileclose>
80103831:	83 c4 10             	add    $0x10,%esp
}
80103834:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103837:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010383c:	5b                   	pop    %ebx
8010383d:	5e                   	pop    %esi
8010383e:	5f                   	pop    %edi
8010383f:	5d                   	pop    %ebp
80103840:	c3                   	ret    
80103841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103848:	8b 03                	mov    (%ebx),%eax
8010384a:	85 c0                	test   %eax,%eax
8010384c:	75 c8                	jne    80103816 <pipealloc+0xc6>
8010384e:	eb d2                	jmp    80103822 <pipealloc+0xd2>

80103850 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	56                   	push   %esi
80103854:	53                   	push   %ebx
80103855:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103858:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010385b:	83 ec 0c             	sub    $0xc,%esp
8010385e:	53                   	push   %ebx
8010385f:	e8 5c 10 00 00       	call   801048c0 <acquire>
  if(writable){
80103864:	83 c4 10             	add    $0x10,%esp
80103867:	85 f6                	test   %esi,%esi
80103869:	74 65                	je     801038d0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010386b:	83 ec 0c             	sub    $0xc,%esp
8010386e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103874:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010387b:	00 00 00 
    wakeup(&p->nread);
8010387e:	50                   	push   %eax
8010387f:	e8 9c 0b 00 00       	call   80104420 <wakeup>
80103884:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103887:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010388d:	85 d2                	test   %edx,%edx
8010388f:	75 0a                	jne    8010389b <pipeclose+0x4b>
80103891:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103897:	85 c0                	test   %eax,%eax
80103899:	74 15                	je     801038b0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010389b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010389e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038a1:	5b                   	pop    %ebx
801038a2:	5e                   	pop    %esi
801038a3:	5d                   	pop    %ebp
    release(&p->lock);
801038a4:	e9 b7 0f 00 00       	jmp    80104860 <release>
801038a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801038b0:	83 ec 0c             	sub    $0xc,%esp
801038b3:	53                   	push   %ebx
801038b4:	e8 a7 0f 00 00       	call   80104860 <release>
    kfree((char*)p);
801038b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801038bc:	83 c4 10             	add    $0x10,%esp
}
801038bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038c2:	5b                   	pop    %ebx
801038c3:	5e                   	pop    %esi
801038c4:	5d                   	pop    %ebp
    kfree((char*)p);
801038c5:	e9 f6 eb ff ff       	jmp    801024c0 <kfree>
801038ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801038d0:	83 ec 0c             	sub    $0xc,%esp
801038d3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801038d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801038e0:	00 00 00 
    wakeup(&p->nwrite);
801038e3:	50                   	push   %eax
801038e4:	e8 37 0b 00 00       	call   80104420 <wakeup>
801038e9:	83 c4 10             	add    $0x10,%esp
801038ec:	eb 99                	jmp    80103887 <pipeclose+0x37>
801038ee:	66 90                	xchg   %ax,%ax

801038f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	57                   	push   %edi
801038f4:	56                   	push   %esi
801038f5:	53                   	push   %ebx
801038f6:	83 ec 28             	sub    $0x28,%esp
801038f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801038fc:	53                   	push   %ebx
801038fd:	e8 be 0f 00 00       	call   801048c0 <acquire>
  for(i = 0; i < n; i++){
80103902:	8b 45 10             	mov    0x10(%ebp),%eax
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	85 c0                	test   %eax,%eax
8010390a:	0f 8e c0 00 00 00    	jle    801039d0 <pipewrite+0xe0>
80103910:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103913:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103919:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010391f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103922:	03 45 10             	add    0x10(%ebp),%eax
80103925:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103928:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010392e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103934:	89 ca                	mov    %ecx,%edx
80103936:	05 00 02 00 00       	add    $0x200,%eax
8010393b:	39 c1                	cmp    %eax,%ecx
8010393d:	74 3f                	je     8010397e <pipewrite+0x8e>
8010393f:	eb 67                	jmp    801039a8 <pipewrite+0xb8>
80103941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103948:	e8 43 03 00 00       	call   80103c90 <myproc>
8010394d:	8b 48 24             	mov    0x24(%eax),%ecx
80103950:	85 c9                	test   %ecx,%ecx
80103952:	75 34                	jne    80103988 <pipewrite+0x98>
      wakeup(&p->nread);
80103954:	83 ec 0c             	sub    $0xc,%esp
80103957:	57                   	push   %edi
80103958:	e8 c3 0a 00 00       	call   80104420 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010395d:	58                   	pop    %eax
8010395e:	5a                   	pop    %edx
8010395f:	53                   	push   %ebx
80103960:	56                   	push   %esi
80103961:	e8 fa 09 00 00       	call   80104360 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103966:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010396c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103972:	83 c4 10             	add    $0x10,%esp
80103975:	05 00 02 00 00       	add    $0x200,%eax
8010397a:	39 c2                	cmp    %eax,%edx
8010397c:	75 2a                	jne    801039a8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010397e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103984:	85 c0                	test   %eax,%eax
80103986:	75 c0                	jne    80103948 <pipewrite+0x58>
        release(&p->lock);
80103988:	83 ec 0c             	sub    $0xc,%esp
8010398b:	53                   	push   %ebx
8010398c:	e8 cf 0e 00 00       	call   80104860 <release>
        return -1;
80103991:	83 c4 10             	add    $0x10,%esp
80103994:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103999:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010399c:	5b                   	pop    %ebx
8010399d:	5e                   	pop    %esi
8010399e:	5f                   	pop    %edi
8010399f:	5d                   	pop    %ebp
801039a0:	c3                   	ret    
801039a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801039a8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801039ab:	8d 4a 01             	lea    0x1(%edx),%ecx
801039ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801039b4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801039ba:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801039bd:	83 c6 01             	add    $0x1,%esi
801039c0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801039c3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801039c7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801039ca:	0f 85 58 ff ff ff    	jne    80103928 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801039d0:	83 ec 0c             	sub    $0xc,%esp
801039d3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801039d9:	50                   	push   %eax
801039da:	e8 41 0a 00 00       	call   80104420 <wakeup>
  release(&p->lock);
801039df:	89 1c 24             	mov    %ebx,(%esp)
801039e2:	e8 79 0e 00 00       	call   80104860 <release>
  return n;
801039e7:	8b 45 10             	mov    0x10(%ebp),%eax
801039ea:	83 c4 10             	add    $0x10,%esp
801039ed:	eb aa                	jmp    80103999 <pipewrite+0xa9>
801039ef:	90                   	nop

801039f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	57                   	push   %edi
801039f4:	56                   	push   %esi
801039f5:	53                   	push   %ebx
801039f6:	83 ec 18             	sub    $0x18,%esp
801039f9:	8b 75 08             	mov    0x8(%ebp),%esi
801039fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801039ff:	56                   	push   %esi
80103a00:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103a06:	e8 b5 0e 00 00       	call   801048c0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a0b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103a11:	83 c4 10             	add    $0x10,%esp
80103a14:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103a1a:	74 2f                	je     80103a4b <piperead+0x5b>
80103a1c:	eb 37                	jmp    80103a55 <piperead+0x65>
80103a1e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103a20:	e8 6b 02 00 00       	call   80103c90 <myproc>
80103a25:	8b 48 24             	mov    0x24(%eax),%ecx
80103a28:	85 c9                	test   %ecx,%ecx
80103a2a:	0f 85 80 00 00 00    	jne    80103ab0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103a30:	83 ec 08             	sub    $0x8,%esp
80103a33:	56                   	push   %esi
80103a34:	53                   	push   %ebx
80103a35:	e8 26 09 00 00       	call   80104360 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a3a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103a40:	83 c4 10             	add    $0x10,%esp
80103a43:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103a49:	75 0a                	jne    80103a55 <piperead+0x65>
80103a4b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103a51:	85 c0                	test   %eax,%eax
80103a53:	75 cb                	jne    80103a20 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a55:	8b 55 10             	mov    0x10(%ebp),%edx
80103a58:	31 db                	xor    %ebx,%ebx
80103a5a:	85 d2                	test   %edx,%edx
80103a5c:	7f 20                	jg     80103a7e <piperead+0x8e>
80103a5e:	eb 2c                	jmp    80103a8c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103a60:	8d 48 01             	lea    0x1(%eax),%ecx
80103a63:	25 ff 01 00 00       	and    $0x1ff,%eax
80103a68:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103a6e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103a73:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a76:	83 c3 01             	add    $0x1,%ebx
80103a79:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103a7c:	74 0e                	je     80103a8c <piperead+0x9c>
    if(p->nread == p->nwrite)
80103a7e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103a84:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103a8a:	75 d4                	jne    80103a60 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103a8c:	83 ec 0c             	sub    $0xc,%esp
80103a8f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103a95:	50                   	push   %eax
80103a96:	e8 85 09 00 00       	call   80104420 <wakeup>
  release(&p->lock);
80103a9b:	89 34 24             	mov    %esi,(%esp)
80103a9e:	e8 bd 0d 00 00       	call   80104860 <release>
  return i;
80103aa3:	83 c4 10             	add    $0x10,%esp
}
80103aa6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103aa9:	89 d8                	mov    %ebx,%eax
80103aab:	5b                   	pop    %ebx
80103aac:	5e                   	pop    %esi
80103aad:	5f                   	pop    %edi
80103aae:	5d                   	pop    %ebp
80103aaf:	c3                   	ret    
      release(&p->lock);
80103ab0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ab3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103ab8:	56                   	push   %esi
80103ab9:	e8 a2 0d 00 00       	call   80104860 <release>
      return -1;
80103abe:	83 c4 10             	add    $0x10,%esp
}
80103ac1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ac4:	89 d8                	mov    %ebx,%eax
80103ac6:	5b                   	pop    %ebx
80103ac7:	5e                   	pop    %esi
80103ac8:	5f                   	pop    %edi
80103ac9:	5d                   	pop    %ebp
80103aca:	c3                   	ret    
80103acb:	66 90                	xchg   %ax,%ax
80103acd:	66 90                	xchg   %ax,%ax
80103acf:	90                   	nop

80103ad0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ad4:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
{
80103ad9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103adc:	68 20 ad 14 80       	push   $0x8014ad20
80103ae1:	e8 da 0d 00 00       	call   801048c0 <acquire>
80103ae6:	83 c4 10             	add    $0x10,%esp
80103ae9:	eb 10                	jmp    80103afb <allocproc+0x2b>
80103aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103aef:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103af0:	83 c3 7c             	add    $0x7c,%ebx
80103af3:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
80103af9:	74 75                	je     80103b70 <allocproc+0xa0>
    if(p->state == UNUSED)
80103afb:	8b 43 0c             	mov    0xc(%ebx),%eax
80103afe:	85 c0                	test   %eax,%eax
80103b00:	75 ee                	jne    80103af0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103b02:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103b07:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103b0a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103b11:	89 43 10             	mov    %eax,0x10(%ebx)
80103b14:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103b17:	68 20 ad 14 80       	push   $0x8014ad20
  p->pid = nextpid++;
80103b1c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103b22:	e8 39 0d 00 00       	call   80104860 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103b27:	e8 24 ec ff ff       	call   80102750 <kalloc>
80103b2c:	83 c4 10             	add    $0x10,%esp
80103b2f:	89 43 08             	mov    %eax,0x8(%ebx)
80103b32:	85 c0                	test   %eax,%eax
80103b34:	74 53                	je     80103b89 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b36:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103b3c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103b3f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103b44:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103b47:	c7 40 14 72 5b 10 80 	movl   $0x80105b72,0x14(%eax)
  p->context = (struct context*)sp;
80103b4e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103b51:	6a 14                	push   $0x14
80103b53:	6a 00                	push   $0x0
80103b55:	50                   	push   %eax
80103b56:	e8 25 0e 00 00       	call   80104980 <memset>
  p->context->eip = (uint)forkret;
80103b5b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103b5e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b61:	c7 40 10 a0 3b 10 80 	movl   $0x80103ba0,0x10(%eax)
}
80103b68:	89 d8                	mov    %ebx,%eax
80103b6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b6d:	c9                   	leave  
80103b6e:	c3                   	ret    
80103b6f:	90                   	nop
  release(&ptable.lock);
80103b70:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103b73:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103b75:	68 20 ad 14 80       	push   $0x8014ad20
80103b7a:	e8 e1 0c 00 00       	call   80104860 <release>
}
80103b7f:	89 d8                	mov    %ebx,%eax
  return 0;
80103b81:	83 c4 10             	add    $0x10,%esp
}
80103b84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b87:	c9                   	leave  
80103b88:	c3                   	ret    
    p->state = UNUSED;
80103b89:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103b90:	31 db                	xor    %ebx,%ebx
}
80103b92:	89 d8                	mov    %ebx,%eax
80103b94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b97:	c9                   	leave  
80103b98:	c3                   	ret    
80103b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ba0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103ba6:	68 20 ad 14 80       	push   $0x8014ad20
80103bab:	e8 b0 0c 00 00       	call   80104860 <release>

  if (first) {
80103bb0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103bb5:	83 c4 10             	add    $0x10,%esp
80103bb8:	85 c0                	test   %eax,%eax
80103bba:	75 04                	jne    80103bc0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103bbc:	c9                   	leave  
80103bbd:	c3                   	ret    
80103bbe:	66 90                	xchg   %ax,%ax
    first = 0;
80103bc0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103bc7:	00 00 00 
    iinit(ROOTDEV);
80103bca:	83 ec 0c             	sub    $0xc,%esp
80103bcd:	6a 01                	push   $0x1
80103bcf:	e8 8c d9 ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103bd4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103bdb:	e8 00 f4 ff ff       	call   80102fe0 <initlog>
}
80103be0:	83 c4 10             	add    $0x10,%esp
80103be3:	c9                   	leave  
80103be4:	c3                   	ret    
80103be5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103bf0 <pinit>:
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103bf6:	68 c0 7c 10 80       	push   $0x80107cc0
80103bfb:	68 20 ad 14 80       	push   $0x8014ad20
80103c00:	e8 eb 0a 00 00       	call   801046f0 <initlock>
}
80103c05:	83 c4 10             	add    $0x10,%esp
80103c08:	c9                   	leave  
80103c09:	c3                   	ret    
80103c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c10 <mycpu>:
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	56                   	push   %esi
80103c14:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c15:	9c                   	pushf  
80103c16:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c17:	f6 c4 02             	test   $0x2,%ah
80103c1a:	75 46                	jne    80103c62 <mycpu+0x52>
  apicid = lapicid();
80103c1c:	e8 ef ef ff ff       	call   80102c10 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103c21:	8b 35 84 a7 14 80    	mov    0x8014a784,%esi
80103c27:	85 f6                	test   %esi,%esi
80103c29:	7e 2a                	jle    80103c55 <mycpu+0x45>
80103c2b:	31 d2                	xor    %edx,%edx
80103c2d:	eb 08                	jmp    80103c37 <mycpu+0x27>
80103c2f:	90                   	nop
80103c30:	83 c2 01             	add    $0x1,%edx
80103c33:	39 f2                	cmp    %esi,%edx
80103c35:	74 1e                	je     80103c55 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103c37:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103c3d:	0f b6 99 a0 a7 14 80 	movzbl -0x7feb5860(%ecx),%ebx
80103c44:	39 c3                	cmp    %eax,%ebx
80103c46:	75 e8                	jne    80103c30 <mycpu+0x20>
}
80103c48:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103c4b:	8d 81 a0 a7 14 80    	lea    -0x7feb5860(%ecx),%eax
}
80103c51:	5b                   	pop    %ebx
80103c52:	5e                   	pop    %esi
80103c53:	5d                   	pop    %ebp
80103c54:	c3                   	ret    
  panic("unknown apicid\n");
80103c55:	83 ec 0c             	sub    $0xc,%esp
80103c58:	68 c7 7c 10 80       	push   $0x80107cc7
80103c5d:	e8 1e c7 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103c62:	83 ec 0c             	sub    $0xc,%esp
80103c65:	68 a4 7d 10 80       	push   $0x80107da4
80103c6a:	e8 11 c7 ff ff       	call   80100380 <panic>
80103c6f:	90                   	nop

80103c70 <cpuid>:
cpuid() {
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c76:	e8 95 ff ff ff       	call   80103c10 <mycpu>
}
80103c7b:	c9                   	leave  
  return mycpu()-cpus;
80103c7c:	2d a0 a7 14 80       	sub    $0x8014a7a0,%eax
80103c81:	c1 f8 04             	sar    $0x4,%eax
80103c84:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c8a:	c3                   	ret    
80103c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c8f:	90                   	nop

80103c90 <myproc>:
myproc(void) {
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	53                   	push   %ebx
80103c94:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103c97:	e8 d4 0a 00 00       	call   80104770 <pushcli>
  c = mycpu();
80103c9c:	e8 6f ff ff ff       	call   80103c10 <mycpu>
  p = c->proc;
80103ca1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ca7:	e8 14 0b 00 00       	call   801047c0 <popcli>
}
80103cac:	89 d8                	mov    %ebx,%eax
80103cae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cb1:	c9                   	leave  
80103cb2:	c3                   	ret    
80103cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103cc0 <userinit>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	53                   	push   %ebx
80103cc4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103cc7:	e8 04 fe ff ff       	call   80103ad0 <allocproc>
80103ccc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103cce:	a3 54 cc 14 80       	mov    %eax,0x8014cc54
  if((p->pgdir = setupkvm()) == 0)
80103cd3:	e8 c8 34 00 00       	call   801071a0 <setupkvm>
80103cd8:	89 43 04             	mov    %eax,0x4(%ebx)
80103cdb:	85 c0                	test   %eax,%eax
80103cdd:	0f 84 bd 00 00 00    	je     80103da0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ce3:	83 ec 04             	sub    $0x4,%esp
80103ce6:	68 2c 00 00 00       	push   $0x2c
80103ceb:	68 60 b4 10 80       	push   $0x8010b460
80103cf0:	50                   	push   %eax
80103cf1:	e8 5a 31 00 00       	call   80106e50 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103cf6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103cf9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103cff:	6a 4c                	push   $0x4c
80103d01:	6a 00                	push   $0x0
80103d03:	ff 73 18             	push   0x18(%ebx)
80103d06:	e8 75 0c 00 00       	call   80104980 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d0b:	8b 43 18             	mov    0x18(%ebx),%eax
80103d0e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d13:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d16:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d1b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d1f:	8b 43 18             	mov    0x18(%ebx),%eax
80103d22:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103d26:	8b 43 18             	mov    0x18(%ebx),%eax
80103d29:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d2d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d31:	8b 43 18             	mov    0x18(%ebx),%eax
80103d34:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d38:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d3c:	8b 43 18             	mov    0x18(%ebx),%eax
80103d3f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d46:	8b 43 18             	mov    0x18(%ebx),%eax
80103d49:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d50:	8b 43 18             	mov    0x18(%ebx),%eax
80103d53:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d5a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d5d:	6a 10                	push   $0x10
80103d5f:	68 f0 7c 10 80       	push   $0x80107cf0
80103d64:	50                   	push   %eax
80103d65:	e8 d6 0d 00 00       	call   80104b40 <safestrcpy>
  p->cwd = namei("/");
80103d6a:	c7 04 24 f9 7c 10 80 	movl   $0x80107cf9,(%esp)
80103d71:	e8 2a e3 ff ff       	call   801020a0 <namei>
80103d76:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103d79:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103d80:	e8 3b 0b 00 00       	call   801048c0 <acquire>
  p->state = RUNNABLE;
80103d85:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103d8c:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103d93:	e8 c8 0a 00 00       	call   80104860 <release>
}
80103d98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d9b:	83 c4 10             	add    $0x10,%esp
80103d9e:	c9                   	leave  
80103d9f:	c3                   	ret    
    panic("userinit: out of memory?");
80103da0:	83 ec 0c             	sub    $0xc,%esp
80103da3:	68 d7 7c 10 80       	push   $0x80107cd7
80103da8:	e8 d3 c5 ff ff       	call   80100380 <panic>
80103dad:	8d 76 00             	lea    0x0(%esi),%esi

80103db0 <growproc>:
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	56                   	push   %esi
80103db4:	53                   	push   %ebx
80103db5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103db8:	e8 b3 09 00 00       	call   80104770 <pushcli>
  c = mycpu();
80103dbd:	e8 4e fe ff ff       	call   80103c10 <mycpu>
  p = c->proc;
80103dc2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dc8:	e8 f3 09 00 00       	call   801047c0 <popcli>
  sz = curproc->sz;
80103dcd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103dcf:	85 f6                	test   %esi,%esi
80103dd1:	7f 1d                	jg     80103df0 <growproc+0x40>
  } else if(n < 0){
80103dd3:	75 3b                	jne    80103e10 <growproc+0x60>
  switchuvm(curproc);
80103dd5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103dd8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103dda:	53                   	push   %ebx
80103ddb:	e8 60 2f 00 00       	call   80106d40 <switchuvm>
  return 0;
80103de0:	83 c4 10             	add    $0x10,%esp
80103de3:	31 c0                	xor    %eax,%eax
}
80103de5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103de8:	5b                   	pop    %ebx
80103de9:	5e                   	pop    %esi
80103dea:	5d                   	pop    %ebp
80103deb:	c3                   	ret    
80103dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103df0:	83 ec 04             	sub    $0x4,%esp
80103df3:	01 c6                	add    %eax,%esi
80103df5:	56                   	push   %esi
80103df6:	50                   	push   %eax
80103df7:	ff 73 04             	push   0x4(%ebx)
80103dfa:	e8 c1 31 00 00       	call   80106fc0 <allocuvm>
80103dff:	83 c4 10             	add    $0x10,%esp
80103e02:	85 c0                	test   %eax,%eax
80103e04:	75 cf                	jne    80103dd5 <growproc+0x25>
      return -1;
80103e06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e0b:	eb d8                	jmp    80103de5 <growproc+0x35>
80103e0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e10:	83 ec 04             	sub    $0x4,%esp
80103e13:	01 c6                	add    %eax,%esi
80103e15:	56                   	push   %esi
80103e16:	50                   	push   %eax
80103e17:	ff 73 04             	push   0x4(%ebx)
80103e1a:	e8 d1 32 00 00       	call   801070f0 <deallocuvm>
80103e1f:	83 c4 10             	add    $0x10,%esp
80103e22:	85 c0                	test   %eax,%eax
80103e24:	75 af                	jne    80103dd5 <growproc+0x25>
80103e26:	eb de                	jmp    80103e06 <growproc+0x56>
80103e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e2f:	90                   	nop

80103e30 <fork>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	57                   	push   %edi
80103e34:	56                   	push   %esi
80103e35:	53                   	push   %ebx
80103e36:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103e39:	e8 32 09 00 00       	call   80104770 <pushcli>
  c = mycpu();
80103e3e:	e8 cd fd ff ff       	call   80103c10 <mycpu>
  p = c->proc;
80103e43:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e49:	e8 72 09 00 00       	call   801047c0 <popcli>
  if((np = allocproc()) == 0){
80103e4e:	e8 7d fc ff ff       	call   80103ad0 <allocproc>
80103e53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e56:	85 c0                	test   %eax,%eax
80103e58:	0f 84 b7 00 00 00    	je     80103f15 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103e5e:	83 ec 08             	sub    $0x8,%esp
80103e61:	ff 33                	push   (%ebx)
80103e63:	89 c7                	mov    %eax,%edi
80103e65:	ff 73 04             	push   0x4(%ebx)
80103e68:	e8 23 34 00 00       	call   80107290 <copyuvm>
80103e6d:	83 c4 10             	add    $0x10,%esp
80103e70:	89 47 04             	mov    %eax,0x4(%edi)
80103e73:	85 c0                	test   %eax,%eax
80103e75:	0f 84 a1 00 00 00    	je     80103f1c <fork+0xec>
  np->sz = curproc->sz;
80103e7b:	8b 03                	mov    (%ebx),%eax
80103e7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e80:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103e82:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103e85:	89 c8                	mov    %ecx,%eax
80103e87:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103e8a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e8f:	8b 73 18             	mov    0x18(%ebx),%esi
80103e92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e94:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e96:	8b 40 18             	mov    0x18(%eax),%eax
80103e99:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103ea0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ea4:	85 c0                	test   %eax,%eax
80103ea6:	74 13                	je     80103ebb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ea8:	83 ec 0c             	sub    $0xc,%esp
80103eab:	50                   	push   %eax
80103eac:	e8 ef cf ff ff       	call   80100ea0 <filedup>
80103eb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103eb4:	83 c4 10             	add    $0x10,%esp
80103eb7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103ebb:	83 c6 01             	add    $0x1,%esi
80103ebe:	83 fe 10             	cmp    $0x10,%esi
80103ec1:	75 dd                	jne    80103ea0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103ec3:	83 ec 0c             	sub    $0xc,%esp
80103ec6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ec9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103ecc:	e8 7f d8 ff ff       	call   80101750 <idup>
80103ed1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ed4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103ed7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103eda:	8d 47 6c             	lea    0x6c(%edi),%eax
80103edd:	6a 10                	push   $0x10
80103edf:	53                   	push   %ebx
80103ee0:	50                   	push   %eax
80103ee1:	e8 5a 0c 00 00       	call   80104b40 <safestrcpy>
  pid = np->pid;
80103ee6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103ee9:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103ef0:	e8 cb 09 00 00       	call   801048c0 <acquire>
  np->state = RUNNABLE;
80103ef5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103efc:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103f03:	e8 58 09 00 00       	call   80104860 <release>
  return pid;
80103f08:	83 c4 10             	add    $0x10,%esp
}
80103f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f0e:	89 d8                	mov    %ebx,%eax
80103f10:	5b                   	pop    %ebx
80103f11:	5e                   	pop    %esi
80103f12:	5f                   	pop    %edi
80103f13:	5d                   	pop    %ebp
80103f14:	c3                   	ret    
    return -1;
80103f15:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f1a:	eb ef                	jmp    80103f0b <fork+0xdb>
    kfree(np->kstack);
80103f1c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103f1f:	83 ec 0c             	sub    $0xc,%esp
80103f22:	ff 73 08             	push   0x8(%ebx)
80103f25:	e8 96 e5 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103f2a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103f31:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103f34:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103f3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f40:	eb c9                	jmp    80103f0b <fork+0xdb>
80103f42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f50 <scheduler>:
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	57                   	push   %edi
80103f54:	56                   	push   %esi
80103f55:	53                   	push   %ebx
80103f56:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103f59:	e8 b2 fc ff ff       	call   80103c10 <mycpu>
  c->proc = 0;
80103f5e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f65:	00 00 00 
  struct cpu *c = mycpu();
80103f68:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103f6a:	8d 78 04             	lea    0x4(%eax),%edi
80103f6d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103f70:	fb                   	sti    
    acquire(&ptable.lock);
80103f71:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f74:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
    acquire(&ptable.lock);
80103f79:	68 20 ad 14 80       	push   $0x8014ad20
80103f7e:	e8 3d 09 00 00       	call   801048c0 <acquire>
80103f83:	83 c4 10             	add    $0x10,%esp
80103f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f8d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103f90:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f94:	75 33                	jne    80103fc9 <scheduler+0x79>
      switchuvm(p);
80103f96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f9f:	53                   	push   %ebx
80103fa0:	e8 9b 2d 00 00       	call   80106d40 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103fa5:	58                   	pop    %eax
80103fa6:	5a                   	pop    %edx
80103fa7:	ff 73 1c             	push   0x1c(%ebx)
80103faa:	57                   	push   %edi
      p->state = RUNNING;
80103fab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103fb2:	e8 e4 0b 00 00       	call   80104b9b <swtch>
      switchkvm();
80103fb7:	e8 74 2d 00 00       	call   80106d30 <switchkvm>
      c->proc = 0;
80103fbc:	83 c4 10             	add    $0x10,%esp
80103fbf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103fc6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fc9:	83 c3 7c             	add    $0x7c,%ebx
80103fcc:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
80103fd2:	75 bc                	jne    80103f90 <scheduler+0x40>
    release(&ptable.lock);
80103fd4:	83 ec 0c             	sub    $0xc,%esp
80103fd7:	68 20 ad 14 80       	push   $0x8014ad20
80103fdc:	e8 7f 08 00 00       	call   80104860 <release>
    sti();
80103fe1:	83 c4 10             	add    $0x10,%esp
80103fe4:	eb 8a                	jmp    80103f70 <scheduler+0x20>
80103fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fed:	8d 76 00             	lea    0x0(%esi),%esi

80103ff0 <sched>:
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	56                   	push   %esi
80103ff4:	53                   	push   %ebx
  pushcli();
80103ff5:	e8 76 07 00 00       	call   80104770 <pushcli>
  c = mycpu();
80103ffa:	e8 11 fc ff ff       	call   80103c10 <mycpu>
  p = c->proc;
80103fff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104005:	e8 b6 07 00 00       	call   801047c0 <popcli>
  if(!holding(&ptable.lock))
8010400a:	83 ec 0c             	sub    $0xc,%esp
8010400d:	68 20 ad 14 80       	push   $0x8014ad20
80104012:	e8 09 08 00 00       	call   80104820 <holding>
80104017:	83 c4 10             	add    $0x10,%esp
8010401a:	85 c0                	test   %eax,%eax
8010401c:	74 4f                	je     8010406d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010401e:	e8 ed fb ff ff       	call   80103c10 <mycpu>
80104023:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010402a:	75 68                	jne    80104094 <sched+0xa4>
  if(p->state == RUNNING)
8010402c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104030:	74 55                	je     80104087 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104032:	9c                   	pushf  
80104033:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104034:	f6 c4 02             	test   $0x2,%ah
80104037:	75 41                	jne    8010407a <sched+0x8a>
  intena = mycpu()->intena;
80104039:	e8 d2 fb ff ff       	call   80103c10 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010403e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104041:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104047:	e8 c4 fb ff ff       	call   80103c10 <mycpu>
8010404c:	83 ec 08             	sub    $0x8,%esp
8010404f:	ff 70 04             	push   0x4(%eax)
80104052:	53                   	push   %ebx
80104053:	e8 43 0b 00 00       	call   80104b9b <swtch>
  mycpu()->intena = intena;
80104058:	e8 b3 fb ff ff       	call   80103c10 <mycpu>
}
8010405d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104060:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104066:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104069:	5b                   	pop    %ebx
8010406a:	5e                   	pop    %esi
8010406b:	5d                   	pop    %ebp
8010406c:	c3                   	ret    
    panic("sched ptable.lock");
8010406d:	83 ec 0c             	sub    $0xc,%esp
80104070:	68 fb 7c 10 80       	push   $0x80107cfb
80104075:	e8 06 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010407a:	83 ec 0c             	sub    $0xc,%esp
8010407d:	68 27 7d 10 80       	push   $0x80107d27
80104082:	e8 f9 c2 ff ff       	call   80100380 <panic>
    panic("sched running");
80104087:	83 ec 0c             	sub    $0xc,%esp
8010408a:	68 19 7d 10 80       	push   $0x80107d19
8010408f:	e8 ec c2 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104094:	83 ec 0c             	sub    $0xc,%esp
80104097:	68 0d 7d 10 80       	push   $0x80107d0d
8010409c:	e8 df c2 ff ff       	call   80100380 <panic>
801040a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040af:	90                   	nop

801040b0 <exit>:
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	57                   	push   %edi
801040b4:	56                   	push   %esi
801040b5:	53                   	push   %ebx
801040b6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801040b9:	e8 d2 fb ff ff       	call   80103c90 <myproc>
  if(curproc == initproc)
801040be:	39 05 54 cc 14 80    	cmp    %eax,0x8014cc54
801040c4:	0f 84 fd 00 00 00    	je     801041c7 <exit+0x117>
801040ca:	89 c3                	mov    %eax,%ebx
801040cc:	8d 70 28             	lea    0x28(%eax),%esi
801040cf:	8d 78 68             	lea    0x68(%eax),%edi
801040d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801040d8:	8b 06                	mov    (%esi),%eax
801040da:	85 c0                	test   %eax,%eax
801040dc:	74 12                	je     801040f0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801040de:	83 ec 0c             	sub    $0xc,%esp
801040e1:	50                   	push   %eax
801040e2:	e8 09 ce ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
801040e7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801040ed:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801040f0:	83 c6 04             	add    $0x4,%esi
801040f3:	39 f7                	cmp    %esi,%edi
801040f5:	75 e1                	jne    801040d8 <exit+0x28>
  begin_op();
801040f7:	e8 84 ef ff ff       	call   80103080 <begin_op>
  iput(curproc->cwd);
801040fc:	83 ec 0c             	sub    $0xc,%esp
801040ff:	ff 73 68             	push   0x68(%ebx)
80104102:	e8 a9 d7 ff ff       	call   801018b0 <iput>
  end_op();
80104107:	e8 e4 ef ff ff       	call   801030f0 <end_op>
  curproc->cwd = 0;
8010410c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104113:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
8010411a:	e8 a1 07 00 00       	call   801048c0 <acquire>
  wakeup1(curproc->parent);
8010411f:	8b 53 14             	mov    0x14(%ebx),%edx
80104122:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104125:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
8010412a:	eb 0e                	jmp    8010413a <exit+0x8a>
8010412c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104130:	83 c0 7c             	add    $0x7c,%eax
80104133:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104138:	74 1c                	je     80104156 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010413a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010413e:	75 f0                	jne    80104130 <exit+0x80>
80104140:	3b 50 20             	cmp    0x20(%eax),%edx
80104143:	75 eb                	jne    80104130 <exit+0x80>
      p->state = RUNNABLE;
80104145:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010414c:	83 c0 7c             	add    $0x7c,%eax
8010414f:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104154:	75 e4                	jne    8010413a <exit+0x8a>
      p->parent = initproc;
80104156:	8b 0d 54 cc 14 80    	mov    0x8014cc54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010415c:	ba 54 ad 14 80       	mov    $0x8014ad54,%edx
80104161:	eb 10                	jmp    80104173 <exit+0xc3>
80104163:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104167:	90                   	nop
80104168:	83 c2 7c             	add    $0x7c,%edx
8010416b:	81 fa 54 cc 14 80    	cmp    $0x8014cc54,%edx
80104171:	74 3b                	je     801041ae <exit+0xfe>
    if(p->parent == curproc){
80104173:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104176:	75 f0                	jne    80104168 <exit+0xb8>
      if(p->state == ZOMBIE)
80104178:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010417c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010417f:	75 e7                	jne    80104168 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104181:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
80104186:	eb 12                	jmp    8010419a <exit+0xea>
80104188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010418f:	90                   	nop
80104190:	83 c0 7c             	add    $0x7c,%eax
80104193:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104198:	74 ce                	je     80104168 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010419a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010419e:	75 f0                	jne    80104190 <exit+0xe0>
801041a0:	3b 48 20             	cmp    0x20(%eax),%ecx
801041a3:	75 eb                	jne    80104190 <exit+0xe0>
      p->state = RUNNABLE;
801041a5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801041ac:	eb e2                	jmp    80104190 <exit+0xe0>
  curproc->state = ZOMBIE;
801041ae:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801041b5:	e8 36 fe ff ff       	call   80103ff0 <sched>
  panic("zombie exit");
801041ba:	83 ec 0c             	sub    $0xc,%esp
801041bd:	68 48 7d 10 80       	push   $0x80107d48
801041c2:	e8 b9 c1 ff ff       	call   80100380 <panic>
    panic("init exiting");
801041c7:	83 ec 0c             	sub    $0xc,%esp
801041ca:	68 3b 7d 10 80       	push   $0x80107d3b
801041cf:	e8 ac c1 ff ff       	call   80100380 <panic>
801041d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041df:	90                   	nop

801041e0 <wait>:
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	56                   	push   %esi
801041e4:	53                   	push   %ebx
  pushcli();
801041e5:	e8 86 05 00 00       	call   80104770 <pushcli>
  c = mycpu();
801041ea:	e8 21 fa ff ff       	call   80103c10 <mycpu>
  p = c->proc;
801041ef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041f5:	e8 c6 05 00 00       	call   801047c0 <popcli>
  acquire(&ptable.lock);
801041fa:	83 ec 0c             	sub    $0xc,%esp
801041fd:	68 20 ad 14 80       	push   $0x8014ad20
80104202:	e8 b9 06 00 00       	call   801048c0 <acquire>
80104207:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010420a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010420c:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
80104211:	eb 10                	jmp    80104223 <wait+0x43>
80104213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104217:	90                   	nop
80104218:	83 c3 7c             	add    $0x7c,%ebx
8010421b:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
80104221:	74 1b                	je     8010423e <wait+0x5e>
      if(p->parent != curproc)
80104223:	39 73 14             	cmp    %esi,0x14(%ebx)
80104226:	75 f0                	jne    80104218 <wait+0x38>
      if(p->state == ZOMBIE){
80104228:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010422c:	74 62                	je     80104290 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010422e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104231:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104236:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
8010423c:	75 e5                	jne    80104223 <wait+0x43>
    if(!havekids || curproc->killed){
8010423e:	85 c0                	test   %eax,%eax
80104240:	0f 84 a0 00 00 00    	je     801042e6 <wait+0x106>
80104246:	8b 46 24             	mov    0x24(%esi),%eax
80104249:	85 c0                	test   %eax,%eax
8010424b:	0f 85 95 00 00 00    	jne    801042e6 <wait+0x106>
  pushcli();
80104251:	e8 1a 05 00 00       	call   80104770 <pushcli>
  c = mycpu();
80104256:	e8 b5 f9 ff ff       	call   80103c10 <mycpu>
  p = c->proc;
8010425b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104261:	e8 5a 05 00 00       	call   801047c0 <popcli>
  if(p == 0)
80104266:	85 db                	test   %ebx,%ebx
80104268:	0f 84 8f 00 00 00    	je     801042fd <wait+0x11d>
  p->chan = chan;
8010426e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104271:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104278:	e8 73 fd ff ff       	call   80103ff0 <sched>
  p->chan = 0;
8010427d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104284:	eb 84                	jmp    8010420a <wait+0x2a>
80104286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010428d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104290:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104293:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104296:	ff 73 08             	push   0x8(%ebx)
80104299:	e8 22 e2 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010429e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801042a5:	5a                   	pop    %edx
801042a6:	ff 73 04             	push   0x4(%ebx)
801042a9:	e8 72 2e 00 00       	call   80107120 <freevm>
        p->pid = 0;
801042ae:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801042b5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801042bc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801042c0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801042c7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801042ce:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
801042d5:	e8 86 05 00 00       	call   80104860 <release>
        return pid;
801042da:	83 c4 10             	add    $0x10,%esp
}
801042dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042e0:	89 f0                	mov    %esi,%eax
801042e2:	5b                   	pop    %ebx
801042e3:	5e                   	pop    %esi
801042e4:	5d                   	pop    %ebp
801042e5:	c3                   	ret    
      release(&ptable.lock);
801042e6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801042e9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801042ee:	68 20 ad 14 80       	push   $0x8014ad20
801042f3:	e8 68 05 00 00       	call   80104860 <release>
      return -1;
801042f8:	83 c4 10             	add    $0x10,%esp
801042fb:	eb e0                	jmp    801042dd <wait+0xfd>
    panic("sleep");
801042fd:	83 ec 0c             	sub    $0xc,%esp
80104300:	68 54 7d 10 80       	push   $0x80107d54
80104305:	e8 76 c0 ff ff       	call   80100380 <panic>
8010430a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104310 <yield>:
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	53                   	push   %ebx
80104314:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104317:	68 20 ad 14 80       	push   $0x8014ad20
8010431c:	e8 9f 05 00 00       	call   801048c0 <acquire>
  pushcli();
80104321:	e8 4a 04 00 00       	call   80104770 <pushcli>
  c = mycpu();
80104326:	e8 e5 f8 ff ff       	call   80103c10 <mycpu>
  p = c->proc;
8010432b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104331:	e8 8a 04 00 00       	call   801047c0 <popcli>
  myproc()->state = RUNNABLE;
80104336:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010433d:	e8 ae fc ff ff       	call   80103ff0 <sched>
  release(&ptable.lock);
80104342:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80104349:	e8 12 05 00 00       	call   80104860 <release>
}
8010434e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104351:	83 c4 10             	add    $0x10,%esp
80104354:	c9                   	leave  
80104355:	c3                   	ret    
80104356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010435d:	8d 76 00             	lea    0x0(%esi),%esi

80104360 <sleep>:
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	57                   	push   %edi
80104364:	56                   	push   %esi
80104365:	53                   	push   %ebx
80104366:	83 ec 0c             	sub    $0xc,%esp
80104369:	8b 7d 08             	mov    0x8(%ebp),%edi
8010436c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010436f:	e8 fc 03 00 00       	call   80104770 <pushcli>
  c = mycpu();
80104374:	e8 97 f8 ff ff       	call   80103c10 <mycpu>
  p = c->proc;
80104379:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010437f:	e8 3c 04 00 00       	call   801047c0 <popcli>
  if(p == 0)
80104384:	85 db                	test   %ebx,%ebx
80104386:	0f 84 87 00 00 00    	je     80104413 <sleep+0xb3>
  if(lk == 0)
8010438c:	85 f6                	test   %esi,%esi
8010438e:	74 76                	je     80104406 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104390:	81 fe 20 ad 14 80    	cmp    $0x8014ad20,%esi
80104396:	74 50                	je     801043e8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104398:	83 ec 0c             	sub    $0xc,%esp
8010439b:	68 20 ad 14 80       	push   $0x8014ad20
801043a0:	e8 1b 05 00 00       	call   801048c0 <acquire>
    release(lk);
801043a5:	89 34 24             	mov    %esi,(%esp)
801043a8:	e8 b3 04 00 00       	call   80104860 <release>
  p->chan = chan;
801043ad:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043b0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043b7:	e8 34 fc ff ff       	call   80103ff0 <sched>
  p->chan = 0;
801043bc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801043c3:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
801043ca:	e8 91 04 00 00       	call   80104860 <release>
    acquire(lk);
801043cf:	89 75 08             	mov    %esi,0x8(%ebp)
801043d2:	83 c4 10             	add    $0x10,%esp
}
801043d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043d8:	5b                   	pop    %ebx
801043d9:	5e                   	pop    %esi
801043da:	5f                   	pop    %edi
801043db:	5d                   	pop    %ebp
    acquire(lk);
801043dc:	e9 df 04 00 00       	jmp    801048c0 <acquire>
801043e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801043e8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043f2:	e8 f9 fb ff ff       	call   80103ff0 <sched>
  p->chan = 0;
801043f7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801043fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104401:	5b                   	pop    %ebx
80104402:	5e                   	pop    %esi
80104403:	5f                   	pop    %edi
80104404:	5d                   	pop    %ebp
80104405:	c3                   	ret    
    panic("sleep without lk");
80104406:	83 ec 0c             	sub    $0xc,%esp
80104409:	68 5a 7d 10 80       	push   $0x80107d5a
8010440e:	e8 6d bf ff ff       	call   80100380 <panic>
    panic("sleep");
80104413:	83 ec 0c             	sub    $0xc,%esp
80104416:	68 54 7d 10 80       	push   $0x80107d54
8010441b:	e8 60 bf ff ff       	call   80100380 <panic>

80104420 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	53                   	push   %ebx
80104424:	83 ec 10             	sub    $0x10,%esp
80104427:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010442a:	68 20 ad 14 80       	push   $0x8014ad20
8010442f:	e8 8c 04 00 00       	call   801048c0 <acquire>
80104434:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104437:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
8010443c:	eb 0c                	jmp    8010444a <wakeup+0x2a>
8010443e:	66 90                	xchg   %ax,%ax
80104440:	83 c0 7c             	add    $0x7c,%eax
80104443:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104448:	74 1c                	je     80104466 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010444a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010444e:	75 f0                	jne    80104440 <wakeup+0x20>
80104450:	3b 58 20             	cmp    0x20(%eax),%ebx
80104453:	75 eb                	jne    80104440 <wakeup+0x20>
      p->state = RUNNABLE;
80104455:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010445c:	83 c0 7c             	add    $0x7c,%eax
8010445f:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104464:	75 e4                	jne    8010444a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104466:	c7 45 08 20 ad 14 80 	movl   $0x8014ad20,0x8(%ebp)
}
8010446d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104470:	c9                   	leave  
  release(&ptable.lock);
80104471:	e9 ea 03 00 00       	jmp    80104860 <release>
80104476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010447d:	8d 76 00             	lea    0x0(%esi),%esi

80104480 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	53                   	push   %ebx
80104484:	83 ec 10             	sub    $0x10,%esp
80104487:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010448a:	68 20 ad 14 80       	push   $0x8014ad20
8010448f:	e8 2c 04 00 00       	call   801048c0 <acquire>
80104494:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104497:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
8010449c:	eb 0c                	jmp    801044aa <kill+0x2a>
8010449e:	66 90                	xchg   %ax,%ax
801044a0:	83 c0 7c             	add    $0x7c,%eax
801044a3:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
801044a8:	74 36                	je     801044e0 <kill+0x60>
    if(p->pid == pid){
801044aa:	39 58 10             	cmp    %ebx,0x10(%eax)
801044ad:	75 f1                	jne    801044a0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801044af:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801044b3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801044ba:	75 07                	jne    801044c3 <kill+0x43>
        p->state = RUNNABLE;
801044bc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801044c3:	83 ec 0c             	sub    $0xc,%esp
801044c6:	68 20 ad 14 80       	push   $0x8014ad20
801044cb:	e8 90 03 00 00       	call   80104860 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801044d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801044d3:	83 c4 10             	add    $0x10,%esp
801044d6:	31 c0                	xor    %eax,%eax
}
801044d8:	c9                   	leave  
801044d9:	c3                   	ret    
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801044e0:	83 ec 0c             	sub    $0xc,%esp
801044e3:	68 20 ad 14 80       	push   $0x8014ad20
801044e8:	e8 73 03 00 00       	call   80104860 <release>
}
801044ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801044f0:	83 c4 10             	add    $0x10,%esp
801044f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044f8:	c9                   	leave  
801044f9:	c3                   	ret    
801044fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104500 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	57                   	push   %edi
80104504:	56                   	push   %esi
80104505:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104508:	53                   	push   %ebx
80104509:	bb c0 ad 14 80       	mov    $0x8014adc0,%ebx
8010450e:	83 ec 3c             	sub    $0x3c,%esp
80104511:	eb 24                	jmp    80104537 <procdump+0x37>
80104513:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104517:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104518:	83 ec 0c             	sub    $0xc,%esp
8010451b:	68 2f 81 10 80       	push   $0x8010812f
80104520:	e8 7b c1 ff ff       	call   801006a0 <cprintf>
80104525:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104528:	83 c3 7c             	add    $0x7c,%ebx
8010452b:	81 fb c0 cc 14 80    	cmp    $0x8014ccc0,%ebx
80104531:	0f 84 81 00 00 00    	je     801045b8 <procdump+0xb8>
    if(p->state == UNUSED)
80104537:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010453a:	85 c0                	test   %eax,%eax
8010453c:	74 ea                	je     80104528 <procdump+0x28>
      state = "???";
8010453e:	ba 6b 7d 10 80       	mov    $0x80107d6b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104543:	83 f8 05             	cmp    $0x5,%eax
80104546:	77 11                	ja     80104559 <procdump+0x59>
80104548:	8b 14 85 cc 7d 10 80 	mov    -0x7fef8234(,%eax,4),%edx
      state = "???";
8010454f:	b8 6b 7d 10 80       	mov    $0x80107d6b,%eax
80104554:	85 d2                	test   %edx,%edx
80104556:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104559:	53                   	push   %ebx
8010455a:	52                   	push   %edx
8010455b:	ff 73 a4             	push   -0x5c(%ebx)
8010455e:	68 6f 7d 10 80       	push   $0x80107d6f
80104563:	e8 38 c1 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104568:	83 c4 10             	add    $0x10,%esp
8010456b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010456f:	75 a7                	jne    80104518 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104571:	83 ec 08             	sub    $0x8,%esp
80104574:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104577:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010457a:	50                   	push   %eax
8010457b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010457e:	8b 40 0c             	mov    0xc(%eax),%eax
80104581:	83 c0 08             	add    $0x8,%eax
80104584:	50                   	push   %eax
80104585:	e8 86 01 00 00       	call   80104710 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010458a:	83 c4 10             	add    $0x10,%esp
8010458d:	8d 76 00             	lea    0x0(%esi),%esi
80104590:	8b 17                	mov    (%edi),%edx
80104592:	85 d2                	test   %edx,%edx
80104594:	74 82                	je     80104518 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104596:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104599:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010459c:	52                   	push   %edx
8010459d:	68 a1 77 10 80       	push   $0x801077a1
801045a2:	e8 f9 c0 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801045a7:	83 c4 10             	add    $0x10,%esp
801045aa:	39 fe                	cmp    %edi,%esi
801045ac:	75 e2                	jne    80104590 <procdump+0x90>
801045ae:	e9 65 ff ff ff       	jmp    80104518 <procdump+0x18>
801045b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045b7:	90                   	nop
  }
}
801045b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045bb:	5b                   	pop    %ebx
801045bc:	5e                   	pop    %esi
801045bd:	5f                   	pop    %edi
801045be:	5d                   	pop    %ebp
801045bf:	c3                   	ret    

801045c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	53                   	push   %ebx
801045c4:	83 ec 0c             	sub    $0xc,%esp
801045c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801045ca:	68 e4 7d 10 80       	push   $0x80107de4
801045cf:	8d 43 04             	lea    0x4(%ebx),%eax
801045d2:	50                   	push   %eax
801045d3:	e8 18 01 00 00       	call   801046f0 <initlock>
  lk->name = name;
801045d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801045db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045e1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801045e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801045eb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801045ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045f1:	c9                   	leave  
801045f2:	c3                   	ret    
801045f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104600 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	56                   	push   %esi
80104604:	53                   	push   %ebx
80104605:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104608:	8d 73 04             	lea    0x4(%ebx),%esi
8010460b:	83 ec 0c             	sub    $0xc,%esp
8010460e:	56                   	push   %esi
8010460f:	e8 ac 02 00 00       	call   801048c0 <acquire>
  while (lk->locked) {
80104614:	8b 13                	mov    (%ebx),%edx
80104616:	83 c4 10             	add    $0x10,%esp
80104619:	85 d2                	test   %edx,%edx
8010461b:	74 16                	je     80104633 <acquiresleep+0x33>
8010461d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104620:	83 ec 08             	sub    $0x8,%esp
80104623:	56                   	push   %esi
80104624:	53                   	push   %ebx
80104625:	e8 36 fd ff ff       	call   80104360 <sleep>
  while (lk->locked) {
8010462a:	8b 03                	mov    (%ebx),%eax
8010462c:	83 c4 10             	add    $0x10,%esp
8010462f:	85 c0                	test   %eax,%eax
80104631:	75 ed                	jne    80104620 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104633:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104639:	e8 52 f6 ff ff       	call   80103c90 <myproc>
8010463e:	8b 40 10             	mov    0x10(%eax),%eax
80104641:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104644:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104647:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010464a:	5b                   	pop    %ebx
8010464b:	5e                   	pop    %esi
8010464c:	5d                   	pop    %ebp
  release(&lk->lk);
8010464d:	e9 0e 02 00 00       	jmp    80104860 <release>
80104652:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104660 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	56                   	push   %esi
80104664:	53                   	push   %ebx
80104665:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104668:	8d 73 04             	lea    0x4(%ebx),%esi
8010466b:	83 ec 0c             	sub    $0xc,%esp
8010466e:	56                   	push   %esi
8010466f:	e8 4c 02 00 00       	call   801048c0 <acquire>
  lk->locked = 0;
80104674:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010467a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104681:	89 1c 24             	mov    %ebx,(%esp)
80104684:	e8 97 fd ff ff       	call   80104420 <wakeup>
  release(&lk->lk);
80104689:	89 75 08             	mov    %esi,0x8(%ebp)
8010468c:	83 c4 10             	add    $0x10,%esp
}
8010468f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104692:	5b                   	pop    %ebx
80104693:	5e                   	pop    %esi
80104694:	5d                   	pop    %ebp
  release(&lk->lk);
80104695:	e9 c6 01 00 00       	jmp    80104860 <release>
8010469a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	57                   	push   %edi
801046a4:	31 ff                	xor    %edi,%edi
801046a6:	56                   	push   %esi
801046a7:	53                   	push   %ebx
801046a8:	83 ec 18             	sub    $0x18,%esp
801046ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801046ae:	8d 73 04             	lea    0x4(%ebx),%esi
801046b1:	56                   	push   %esi
801046b2:	e8 09 02 00 00       	call   801048c0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801046b7:	8b 03                	mov    (%ebx),%eax
801046b9:	83 c4 10             	add    $0x10,%esp
801046bc:	85 c0                	test   %eax,%eax
801046be:	75 18                	jne    801046d8 <holdingsleep+0x38>
  release(&lk->lk);
801046c0:	83 ec 0c             	sub    $0xc,%esp
801046c3:	56                   	push   %esi
801046c4:	e8 97 01 00 00       	call   80104860 <release>
  return r;
}
801046c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046cc:	89 f8                	mov    %edi,%eax
801046ce:	5b                   	pop    %ebx
801046cf:	5e                   	pop    %esi
801046d0:	5f                   	pop    %edi
801046d1:	5d                   	pop    %ebp
801046d2:	c3                   	ret    
801046d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046d7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801046d8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801046db:	e8 b0 f5 ff ff       	call   80103c90 <myproc>
801046e0:	39 58 10             	cmp    %ebx,0x10(%eax)
801046e3:	0f 94 c0             	sete   %al
801046e6:	0f b6 c0             	movzbl %al,%eax
801046e9:	89 c7                	mov    %eax,%edi
801046eb:	eb d3                	jmp    801046c0 <holdingsleep+0x20>
801046ed:	66 90                	xchg   %ax,%ax
801046ef:	90                   	nop

801046f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801046f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801046f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801046ff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104702:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104709:	5d                   	pop    %ebp
8010470a:	c3                   	ret    
8010470b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010470f:	90                   	nop

80104710 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104710:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104711:	31 d2                	xor    %edx,%edx
{
80104713:	89 e5                	mov    %esp,%ebp
80104715:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104716:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104719:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010471c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010471f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104720:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104726:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010472c:	77 1a                	ja     80104748 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010472e:	8b 58 04             	mov    0x4(%eax),%ebx
80104731:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104734:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104737:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104739:	83 fa 0a             	cmp    $0xa,%edx
8010473c:	75 e2                	jne    80104720 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010473e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104741:	c9                   	leave  
80104742:	c3                   	ret    
80104743:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104747:	90                   	nop
  for(; i < 10; i++)
80104748:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010474b:	8d 51 28             	lea    0x28(%ecx),%edx
8010474e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104750:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104756:	83 c0 04             	add    $0x4,%eax
80104759:	39 d0                	cmp    %edx,%eax
8010475b:	75 f3                	jne    80104750 <getcallerpcs+0x40>
}
8010475d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104760:	c9                   	leave  
80104761:	c3                   	ret    
80104762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104770 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	53                   	push   %ebx
80104774:	83 ec 04             	sub    $0x4,%esp
80104777:	9c                   	pushf  
80104778:	5b                   	pop    %ebx
  asm volatile("cli");
80104779:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010477a:	e8 91 f4 ff ff       	call   80103c10 <mycpu>
8010477f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104785:	85 c0                	test   %eax,%eax
80104787:	74 17                	je     801047a0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104789:	e8 82 f4 ff ff       	call   80103c10 <mycpu>
8010478e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104795:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104798:	c9                   	leave  
80104799:	c3                   	ret    
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801047a0:	e8 6b f4 ff ff       	call   80103c10 <mycpu>
801047a5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801047ab:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801047b1:	eb d6                	jmp    80104789 <pushcli+0x19>
801047b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047c0 <popcli>:

void
popcli(void)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047c6:	9c                   	pushf  
801047c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801047c8:	f6 c4 02             	test   $0x2,%ah
801047cb:	75 35                	jne    80104802 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801047cd:	e8 3e f4 ff ff       	call   80103c10 <mycpu>
801047d2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801047d9:	78 34                	js     8010480f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047db:	e8 30 f4 ff ff       	call   80103c10 <mycpu>
801047e0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801047e6:	85 d2                	test   %edx,%edx
801047e8:	74 06                	je     801047f0 <popcli+0x30>
    sti();
}
801047ea:	c9                   	leave  
801047eb:	c3                   	ret    
801047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047f0:	e8 1b f4 ff ff       	call   80103c10 <mycpu>
801047f5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801047fb:	85 c0                	test   %eax,%eax
801047fd:	74 eb                	je     801047ea <popcli+0x2a>
  asm volatile("sti");
801047ff:	fb                   	sti    
}
80104800:	c9                   	leave  
80104801:	c3                   	ret    
    panic("popcli - interruptible");
80104802:	83 ec 0c             	sub    $0xc,%esp
80104805:	68 ef 7d 10 80       	push   $0x80107def
8010480a:	e8 71 bb ff ff       	call   80100380 <panic>
    panic("popcli");
8010480f:	83 ec 0c             	sub    $0xc,%esp
80104812:	68 06 7e 10 80       	push   $0x80107e06
80104817:	e8 64 bb ff ff       	call   80100380 <panic>
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104820 <holding>:
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	56                   	push   %esi
80104824:	53                   	push   %ebx
80104825:	8b 75 08             	mov    0x8(%ebp),%esi
80104828:	31 db                	xor    %ebx,%ebx
  pushcli();
8010482a:	e8 41 ff ff ff       	call   80104770 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010482f:	8b 06                	mov    (%esi),%eax
80104831:	85 c0                	test   %eax,%eax
80104833:	75 0b                	jne    80104840 <holding+0x20>
  popcli();
80104835:	e8 86 ff ff ff       	call   801047c0 <popcli>
}
8010483a:	89 d8                	mov    %ebx,%eax
8010483c:	5b                   	pop    %ebx
8010483d:	5e                   	pop    %esi
8010483e:	5d                   	pop    %ebp
8010483f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104840:	8b 5e 08             	mov    0x8(%esi),%ebx
80104843:	e8 c8 f3 ff ff       	call   80103c10 <mycpu>
80104848:	39 c3                	cmp    %eax,%ebx
8010484a:	0f 94 c3             	sete   %bl
  popcli();
8010484d:	e8 6e ff ff ff       	call   801047c0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104852:	0f b6 db             	movzbl %bl,%ebx
}
80104855:	89 d8                	mov    %ebx,%eax
80104857:	5b                   	pop    %ebx
80104858:	5e                   	pop    %esi
80104859:	5d                   	pop    %ebp
8010485a:	c3                   	ret    
8010485b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010485f:	90                   	nop

80104860 <release>:
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	53                   	push   %ebx
80104865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104868:	e8 03 ff ff ff       	call   80104770 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010486d:	8b 03                	mov    (%ebx),%eax
8010486f:	85 c0                	test   %eax,%eax
80104871:	75 15                	jne    80104888 <release+0x28>
  popcli();
80104873:	e8 48 ff ff ff       	call   801047c0 <popcli>
    panic("release");
80104878:	83 ec 0c             	sub    $0xc,%esp
8010487b:	68 0d 7e 10 80       	push   $0x80107e0d
80104880:	e8 fb ba ff ff       	call   80100380 <panic>
80104885:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104888:	8b 73 08             	mov    0x8(%ebx),%esi
8010488b:	e8 80 f3 ff ff       	call   80103c10 <mycpu>
80104890:	39 c6                	cmp    %eax,%esi
80104892:	75 df                	jne    80104873 <release+0x13>
  popcli();
80104894:	e8 27 ff ff ff       	call   801047c0 <popcli>
  lk->pcs[0] = 0;
80104899:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801048a0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801048a7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801048ac:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801048b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048b5:	5b                   	pop    %ebx
801048b6:	5e                   	pop    %esi
801048b7:	5d                   	pop    %ebp
  popcli();
801048b8:	e9 03 ff ff ff       	jmp    801047c0 <popcli>
801048bd:	8d 76 00             	lea    0x0(%esi),%esi

801048c0 <acquire>:
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	53                   	push   %ebx
801048c4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801048c7:	e8 a4 fe ff ff       	call   80104770 <pushcli>
  if(holding(lk))
801048cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801048cf:	e8 9c fe ff ff       	call   80104770 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048d4:	8b 03                	mov    (%ebx),%eax
801048d6:	85 c0                	test   %eax,%eax
801048d8:	75 7e                	jne    80104958 <acquire+0x98>
  popcli();
801048da:	e8 e1 fe ff ff       	call   801047c0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801048df:	b9 01 00 00 00       	mov    $0x1,%ecx
801048e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801048e8:	8b 55 08             	mov    0x8(%ebp),%edx
801048eb:	89 c8                	mov    %ecx,%eax
801048ed:	f0 87 02             	lock xchg %eax,(%edx)
801048f0:	85 c0                	test   %eax,%eax
801048f2:	75 f4                	jne    801048e8 <acquire+0x28>
  __sync_synchronize();
801048f4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801048f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048fc:	e8 0f f3 ff ff       	call   80103c10 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104901:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104904:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104906:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104909:	31 c0                	xor    %eax,%eax
8010490b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010490f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104910:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104916:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010491c:	77 1a                	ja     80104938 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010491e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104921:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104925:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104928:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010492a:	83 f8 0a             	cmp    $0xa,%eax
8010492d:	75 e1                	jne    80104910 <acquire+0x50>
}
8010492f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104932:	c9                   	leave  
80104933:	c3                   	ret    
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104938:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010493c:	8d 51 34             	lea    0x34(%ecx),%edx
8010493f:	90                   	nop
    pcs[i] = 0;
80104940:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104946:	83 c0 04             	add    $0x4,%eax
80104949:	39 c2                	cmp    %eax,%edx
8010494b:	75 f3                	jne    80104940 <acquire+0x80>
}
8010494d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104950:	c9                   	leave  
80104951:	c3                   	ret    
80104952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104958:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010495b:	e8 b0 f2 ff ff       	call   80103c10 <mycpu>
80104960:	39 c3                	cmp    %eax,%ebx
80104962:	0f 85 72 ff ff ff    	jne    801048da <acquire+0x1a>
  popcli();
80104968:	e8 53 fe ff ff       	call   801047c0 <popcli>
    panic("acquire");
8010496d:	83 ec 0c             	sub    $0xc,%esp
80104970:	68 15 7e 10 80       	push   $0x80107e15
80104975:	e8 06 ba ff ff       	call   80100380 <panic>
8010497a:	66 90                	xchg   %ax,%ax
8010497c:	66 90                	xchg   %ax,%ax
8010497e:	66 90                	xchg   %ax,%ax

80104980 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	57                   	push   %edi
80104984:	8b 55 08             	mov    0x8(%ebp),%edx
80104987:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010498a:	53                   	push   %ebx
8010498b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010498e:	89 d7                	mov    %edx,%edi
80104990:	09 cf                	or     %ecx,%edi
80104992:	83 e7 03             	and    $0x3,%edi
80104995:	75 29                	jne    801049c0 <memset+0x40>
    c &= 0xFF;
80104997:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010499a:	c1 e0 18             	shl    $0x18,%eax
8010499d:	89 fb                	mov    %edi,%ebx
8010499f:	c1 e9 02             	shr    $0x2,%ecx
801049a2:	c1 e3 10             	shl    $0x10,%ebx
801049a5:	09 d8                	or     %ebx,%eax
801049a7:	09 f8                	or     %edi,%eax
801049a9:	c1 e7 08             	shl    $0x8,%edi
801049ac:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801049ae:	89 d7                	mov    %edx,%edi
801049b0:	fc                   	cld    
801049b1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801049b3:	5b                   	pop    %ebx
801049b4:	89 d0                	mov    %edx,%eax
801049b6:	5f                   	pop    %edi
801049b7:	5d                   	pop    %ebp
801049b8:	c3                   	ret    
801049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801049c0:	89 d7                	mov    %edx,%edi
801049c2:	fc                   	cld    
801049c3:	f3 aa                	rep stos %al,%es:(%edi)
801049c5:	5b                   	pop    %ebx
801049c6:	89 d0                	mov    %edx,%eax
801049c8:	5f                   	pop    %edi
801049c9:	5d                   	pop    %ebp
801049ca:	c3                   	ret    
801049cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049cf:	90                   	nop

801049d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	8b 75 10             	mov    0x10(%ebp),%esi
801049d7:	8b 55 08             	mov    0x8(%ebp),%edx
801049da:	53                   	push   %ebx
801049db:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049de:	85 f6                	test   %esi,%esi
801049e0:	74 2e                	je     80104a10 <memcmp+0x40>
801049e2:	01 c6                	add    %eax,%esi
801049e4:	eb 14                	jmp    801049fa <memcmp+0x2a>
801049e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801049f0:	83 c0 01             	add    $0x1,%eax
801049f3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801049f6:	39 f0                	cmp    %esi,%eax
801049f8:	74 16                	je     80104a10 <memcmp+0x40>
    if(*s1 != *s2)
801049fa:	0f b6 0a             	movzbl (%edx),%ecx
801049fd:	0f b6 18             	movzbl (%eax),%ebx
80104a00:	38 d9                	cmp    %bl,%cl
80104a02:	74 ec                	je     801049f0 <memcmp+0x20>
      return *s1 - *s2;
80104a04:	0f b6 c1             	movzbl %cl,%eax
80104a07:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104a09:	5b                   	pop    %ebx
80104a0a:	5e                   	pop    %esi
80104a0b:	5d                   	pop    %ebp
80104a0c:	c3                   	ret    
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi
80104a10:	5b                   	pop    %ebx
  return 0;
80104a11:	31 c0                	xor    %eax,%eax
}
80104a13:	5e                   	pop    %esi
80104a14:	5d                   	pop    %ebp
80104a15:	c3                   	ret    
80104a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi

80104a20 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	57                   	push   %edi
80104a24:	8b 55 08             	mov    0x8(%ebp),%edx
80104a27:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a2a:	56                   	push   %esi
80104a2b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a2e:	39 d6                	cmp    %edx,%esi
80104a30:	73 26                	jae    80104a58 <memmove+0x38>
80104a32:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104a35:	39 fa                	cmp    %edi,%edx
80104a37:	73 1f                	jae    80104a58 <memmove+0x38>
80104a39:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104a3c:	85 c9                	test   %ecx,%ecx
80104a3e:	74 0c                	je     80104a4c <memmove+0x2c>
      *--d = *--s;
80104a40:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a44:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104a47:	83 e8 01             	sub    $0x1,%eax
80104a4a:	73 f4                	jae    80104a40 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a4c:	5e                   	pop    %esi
80104a4d:	89 d0                	mov    %edx,%eax
80104a4f:	5f                   	pop    %edi
80104a50:	5d                   	pop    %ebp
80104a51:	c3                   	ret    
80104a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104a58:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104a5b:	89 d7                	mov    %edx,%edi
80104a5d:	85 c9                	test   %ecx,%ecx
80104a5f:	74 eb                	je     80104a4c <memmove+0x2c>
80104a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104a68:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104a69:	39 c6                	cmp    %eax,%esi
80104a6b:	75 fb                	jne    80104a68 <memmove+0x48>
}
80104a6d:	5e                   	pop    %esi
80104a6e:	89 d0                	mov    %edx,%eax
80104a70:	5f                   	pop    %edi
80104a71:	5d                   	pop    %ebp
80104a72:	c3                   	ret    
80104a73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104a80:	eb 9e                	jmp    80104a20 <memmove>
80104a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a90 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	56                   	push   %esi
80104a94:	8b 75 10             	mov    0x10(%ebp),%esi
80104a97:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a9a:	53                   	push   %ebx
80104a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104a9e:	85 f6                	test   %esi,%esi
80104aa0:	74 2e                	je     80104ad0 <strncmp+0x40>
80104aa2:	01 d6                	add    %edx,%esi
80104aa4:	eb 18                	jmp    80104abe <strncmp+0x2e>
80104aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aad:	8d 76 00             	lea    0x0(%esi),%esi
80104ab0:	38 d8                	cmp    %bl,%al
80104ab2:	75 14                	jne    80104ac8 <strncmp+0x38>
    n--, p++, q++;
80104ab4:	83 c2 01             	add    $0x1,%edx
80104ab7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104aba:	39 f2                	cmp    %esi,%edx
80104abc:	74 12                	je     80104ad0 <strncmp+0x40>
80104abe:	0f b6 01             	movzbl (%ecx),%eax
80104ac1:	0f b6 1a             	movzbl (%edx),%ebx
80104ac4:	84 c0                	test   %al,%al
80104ac6:	75 e8                	jne    80104ab0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104ac8:	29 d8                	sub    %ebx,%eax
}
80104aca:	5b                   	pop    %ebx
80104acb:	5e                   	pop    %esi
80104acc:	5d                   	pop    %ebp
80104acd:	c3                   	ret    
80104ace:	66 90                	xchg   %ax,%ax
80104ad0:	5b                   	pop    %ebx
    return 0;
80104ad1:	31 c0                	xor    %eax,%eax
}
80104ad3:	5e                   	pop    %esi
80104ad4:	5d                   	pop    %ebp
80104ad5:	c3                   	ret    
80104ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104add:	8d 76 00             	lea    0x0(%esi),%esi

80104ae0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	57                   	push   %edi
80104ae4:	56                   	push   %esi
80104ae5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ae8:	53                   	push   %ebx
80104ae9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104aec:	89 f0                	mov    %esi,%eax
80104aee:	eb 15                	jmp    80104b05 <strncpy+0x25>
80104af0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104af4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104af7:	83 c0 01             	add    $0x1,%eax
80104afa:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104afe:	88 50 ff             	mov    %dl,-0x1(%eax)
80104b01:	84 d2                	test   %dl,%dl
80104b03:	74 09                	je     80104b0e <strncpy+0x2e>
80104b05:	89 cb                	mov    %ecx,%ebx
80104b07:	83 e9 01             	sub    $0x1,%ecx
80104b0a:	85 db                	test   %ebx,%ebx
80104b0c:	7f e2                	jg     80104af0 <strncpy+0x10>
    ;
  while(n-- > 0)
80104b0e:	89 c2                	mov    %eax,%edx
80104b10:	85 c9                	test   %ecx,%ecx
80104b12:	7e 17                	jle    80104b2b <strncpy+0x4b>
80104b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104b18:	83 c2 01             	add    $0x1,%edx
80104b1b:	89 c1                	mov    %eax,%ecx
80104b1d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104b21:	29 d1                	sub    %edx,%ecx
80104b23:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104b27:	85 c9                	test   %ecx,%ecx
80104b29:	7f ed                	jg     80104b18 <strncpy+0x38>
  return os;
}
80104b2b:	5b                   	pop    %ebx
80104b2c:	89 f0                	mov    %esi,%eax
80104b2e:	5e                   	pop    %esi
80104b2f:	5f                   	pop    %edi
80104b30:	5d                   	pop    %ebp
80104b31:	c3                   	ret    
80104b32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b40 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	56                   	push   %esi
80104b44:	8b 55 10             	mov    0x10(%ebp),%edx
80104b47:	8b 75 08             	mov    0x8(%ebp),%esi
80104b4a:	53                   	push   %ebx
80104b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104b4e:	85 d2                	test   %edx,%edx
80104b50:	7e 25                	jle    80104b77 <safestrcpy+0x37>
80104b52:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104b56:	89 f2                	mov    %esi,%edx
80104b58:	eb 16                	jmp    80104b70 <safestrcpy+0x30>
80104b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b60:	0f b6 08             	movzbl (%eax),%ecx
80104b63:	83 c0 01             	add    $0x1,%eax
80104b66:	83 c2 01             	add    $0x1,%edx
80104b69:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b6c:	84 c9                	test   %cl,%cl
80104b6e:	74 04                	je     80104b74 <safestrcpy+0x34>
80104b70:	39 d8                	cmp    %ebx,%eax
80104b72:	75 ec                	jne    80104b60 <safestrcpy+0x20>
    ;
  *s = 0;
80104b74:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104b77:	89 f0                	mov    %esi,%eax
80104b79:	5b                   	pop    %ebx
80104b7a:	5e                   	pop    %esi
80104b7b:	5d                   	pop    %ebp
80104b7c:	c3                   	ret    
80104b7d:	8d 76 00             	lea    0x0(%esi),%esi

80104b80 <strlen>:

int
strlen(const char *s)
{
80104b80:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b81:	31 c0                	xor    %eax,%eax
{
80104b83:	89 e5                	mov    %esp,%ebp
80104b85:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b88:	80 3a 00             	cmpb   $0x0,(%edx)
80104b8b:	74 0c                	je     80104b99 <strlen+0x19>
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
80104b90:	83 c0 01             	add    $0x1,%eax
80104b93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b97:	75 f7                	jne    80104b90 <strlen+0x10>
    ;
  return n;
}
80104b99:	5d                   	pop    %ebp
80104b9a:	c3                   	ret    

80104b9b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b9b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b9f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ba3:	55                   	push   %ebp
  pushl %ebx
80104ba4:	53                   	push   %ebx
  pushl %esi
80104ba5:	56                   	push   %esi
  pushl %edi
80104ba6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ba7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ba9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104bab:	5f                   	pop    %edi
  popl %esi
80104bac:	5e                   	pop    %esi
  popl %ebx
80104bad:	5b                   	pop    %ebx
  popl %ebp
80104bae:	5d                   	pop    %ebp
  ret
80104baf:	c3                   	ret    

80104bb0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	53                   	push   %ebx
80104bb4:	83 ec 04             	sub    $0x4,%esp
80104bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104bba:	e8 d1 f0 ff ff       	call   80103c90 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bbf:	8b 00                	mov    (%eax),%eax
80104bc1:	39 d8                	cmp    %ebx,%eax
80104bc3:	76 1b                	jbe    80104be0 <fetchint+0x30>
80104bc5:	8d 53 04             	lea    0x4(%ebx),%edx
80104bc8:	39 d0                	cmp    %edx,%eax
80104bca:	72 14                	jb     80104be0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bcf:	8b 13                	mov    (%ebx),%edx
80104bd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104bd3:	31 c0                	xor    %eax,%eax
}
80104bd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bd8:	c9                   	leave  
80104bd9:	c3                   	ret    
80104bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104be5:	eb ee                	jmp    80104bd5 <fetchint+0x25>
80104be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bee:	66 90                	xchg   %ax,%ax

80104bf0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	53                   	push   %ebx
80104bf4:	83 ec 04             	sub    $0x4,%esp
80104bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104bfa:	e8 91 f0 ff ff       	call   80103c90 <myproc>

  if(addr >= curproc->sz)
80104bff:	39 18                	cmp    %ebx,(%eax)
80104c01:	76 2d                	jbe    80104c30 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104c03:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c06:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c08:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c0a:	39 d3                	cmp    %edx,%ebx
80104c0c:	73 22                	jae    80104c30 <fetchstr+0x40>
80104c0e:	89 d8                	mov    %ebx,%eax
80104c10:	eb 0d                	jmp    80104c1f <fetchstr+0x2f>
80104c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c18:	83 c0 01             	add    $0x1,%eax
80104c1b:	39 c2                	cmp    %eax,%edx
80104c1d:	76 11                	jbe    80104c30 <fetchstr+0x40>
    if(*s == 0)
80104c1f:	80 38 00             	cmpb   $0x0,(%eax)
80104c22:	75 f4                	jne    80104c18 <fetchstr+0x28>
      return s - *pp;
80104c24:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104c26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c29:	c9                   	leave  
80104c2a:	c3                   	ret    
80104c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c2f:	90                   	nop
80104c30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104c33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c38:	c9                   	leave  
80104c39:	c3                   	ret    
80104c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c40 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	56                   	push   %esi
80104c44:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c45:	e8 46 f0 ff ff       	call   80103c90 <myproc>
80104c4a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c4d:	8b 40 18             	mov    0x18(%eax),%eax
80104c50:	8b 40 44             	mov    0x44(%eax),%eax
80104c53:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c56:	e8 35 f0 ff ff       	call   80103c90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c5b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c5e:	8b 00                	mov    (%eax),%eax
80104c60:	39 c6                	cmp    %eax,%esi
80104c62:	73 1c                	jae    80104c80 <argint+0x40>
80104c64:	8d 53 08             	lea    0x8(%ebx),%edx
80104c67:	39 d0                	cmp    %edx,%eax
80104c69:	72 15                	jb     80104c80 <argint+0x40>
  *ip = *(int*)(addr);
80104c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c6e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c71:	89 10                	mov    %edx,(%eax)
  return 0;
80104c73:	31 c0                	xor    %eax,%eax
}
80104c75:	5b                   	pop    %ebx
80104c76:	5e                   	pop    %esi
80104c77:	5d                   	pop    %ebp
80104c78:	c3                   	ret    
80104c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c85:	eb ee                	jmp    80104c75 <argint+0x35>
80104c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8e:	66 90                	xchg   %ax,%ax

80104c90 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	57                   	push   %edi
80104c94:	56                   	push   %esi
80104c95:	53                   	push   %ebx
80104c96:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104c99:	e8 f2 ef ff ff       	call   80103c90 <myproc>
80104c9e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ca0:	e8 eb ef ff ff       	call   80103c90 <myproc>
80104ca5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ca8:	8b 40 18             	mov    0x18(%eax),%eax
80104cab:	8b 40 44             	mov    0x44(%eax),%eax
80104cae:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104cb1:	e8 da ef ff ff       	call   80103c90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cb6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cb9:	8b 00                	mov    (%eax),%eax
80104cbb:	39 c7                	cmp    %eax,%edi
80104cbd:	73 31                	jae    80104cf0 <argptr+0x60>
80104cbf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104cc2:	39 c8                	cmp    %ecx,%eax
80104cc4:	72 2a                	jb     80104cf0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104cc6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104cc9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ccc:	85 d2                	test   %edx,%edx
80104cce:	78 20                	js     80104cf0 <argptr+0x60>
80104cd0:	8b 16                	mov    (%esi),%edx
80104cd2:	39 c2                	cmp    %eax,%edx
80104cd4:	76 1a                	jbe    80104cf0 <argptr+0x60>
80104cd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104cd9:	01 c3                	add    %eax,%ebx
80104cdb:	39 da                	cmp    %ebx,%edx
80104cdd:	72 11                	jb     80104cf0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ce2:	89 02                	mov    %eax,(%edx)
  return 0;
80104ce4:	31 c0                	xor    %eax,%eax
}
80104ce6:	83 c4 0c             	add    $0xc,%esp
80104ce9:	5b                   	pop    %ebx
80104cea:	5e                   	pop    %esi
80104ceb:	5f                   	pop    %edi
80104cec:	5d                   	pop    %ebp
80104ced:	c3                   	ret    
80104cee:	66 90                	xchg   %ax,%ax
    return -1;
80104cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cf5:	eb ef                	jmp    80104ce6 <argptr+0x56>
80104cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfe:	66 90                	xchg   %ax,%ax

80104d00 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	56                   	push   %esi
80104d04:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d05:	e8 86 ef ff ff       	call   80103c90 <myproc>
80104d0a:	8b 55 08             	mov    0x8(%ebp),%edx
80104d0d:	8b 40 18             	mov    0x18(%eax),%eax
80104d10:	8b 40 44             	mov    0x44(%eax),%eax
80104d13:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d16:	e8 75 ef ff ff       	call   80103c90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d1b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d1e:	8b 00                	mov    (%eax),%eax
80104d20:	39 c6                	cmp    %eax,%esi
80104d22:	73 44                	jae    80104d68 <argstr+0x68>
80104d24:	8d 53 08             	lea    0x8(%ebx),%edx
80104d27:	39 d0                	cmp    %edx,%eax
80104d29:	72 3d                	jb     80104d68 <argstr+0x68>
  *ip = *(int*)(addr);
80104d2b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104d2e:	e8 5d ef ff ff       	call   80103c90 <myproc>
  if(addr >= curproc->sz)
80104d33:	3b 18                	cmp    (%eax),%ebx
80104d35:	73 31                	jae    80104d68 <argstr+0x68>
  *pp = (char*)addr;
80104d37:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d3a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104d3c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104d3e:	39 d3                	cmp    %edx,%ebx
80104d40:	73 26                	jae    80104d68 <argstr+0x68>
80104d42:	89 d8                	mov    %ebx,%eax
80104d44:	eb 11                	jmp    80104d57 <argstr+0x57>
80104d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi
80104d50:	83 c0 01             	add    $0x1,%eax
80104d53:	39 c2                	cmp    %eax,%edx
80104d55:	76 11                	jbe    80104d68 <argstr+0x68>
    if(*s == 0)
80104d57:	80 38 00             	cmpb   $0x0,(%eax)
80104d5a:	75 f4                	jne    80104d50 <argstr+0x50>
      return s - *pp;
80104d5c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104d5e:	5b                   	pop    %ebx
80104d5f:	5e                   	pop    %esi
80104d60:	5d                   	pop    %ebp
80104d61:	c3                   	ret    
80104d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d68:	5b                   	pop    %ebx
    return -1;
80104d69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d6e:	5e                   	pop    %esi
80104d6f:	5d                   	pop    %ebp
80104d70:	c3                   	ret    
80104d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7f:	90                   	nop

80104d80 <syscall>:
[SYS_countptp] sys_countptp,
};

void
syscall(void)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	53                   	push   %ebx
80104d84:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d87:	e8 04 ef ff ff       	call   80103c90 <myproc>
80104d8c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d8e:	8b 40 18             	mov    0x18(%eax),%eax
80104d91:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d94:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d97:	83 fa 18             	cmp    $0x18,%edx
80104d9a:	77 24                	ja     80104dc0 <syscall+0x40>
80104d9c:	8b 14 85 40 7e 10 80 	mov    -0x7fef81c0(,%eax,4),%edx
80104da3:	85 d2                	test   %edx,%edx
80104da5:	74 19                	je     80104dc0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104da7:	ff d2                	call   *%edx
80104da9:	89 c2                	mov    %eax,%edx
80104dab:	8b 43 18             	mov    0x18(%ebx),%eax
80104dae:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104db1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104db4:	c9                   	leave  
80104db5:	c3                   	ret    
80104db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dbd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104dc0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104dc1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104dc4:	50                   	push   %eax
80104dc5:	ff 73 10             	push   0x10(%ebx)
80104dc8:	68 1d 7e 10 80       	push   $0x80107e1d
80104dcd:	e8 ce b8 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104dd2:	8b 43 18             	mov    0x18(%ebx),%eax
80104dd5:	83 c4 10             	add    $0x10,%esp
80104dd8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104ddf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104de2:	c9                   	leave  
80104de3:	c3                   	ret    
80104de4:	66 90                	xchg   %ax,%ax
80104de6:	66 90                	xchg   %ax,%ax
80104de8:	66 90                	xchg   %ax,%ax
80104dea:	66 90                	xchg   %ax,%ax
80104dec:	66 90                	xchg   %ax,%ax
80104dee:	66 90                	xchg   %ax,%ax

80104df0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	57                   	push   %edi
80104df4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104df5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104df8:	53                   	push   %ebx
80104df9:	83 ec 34             	sub    $0x34,%esp
80104dfc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104dff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104e02:	57                   	push   %edi
80104e03:	50                   	push   %eax
{
80104e04:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104e07:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104e0a:	e8 b1 d2 ff ff       	call   801020c0 <nameiparent>
80104e0f:	83 c4 10             	add    $0x10,%esp
80104e12:	85 c0                	test   %eax,%eax
80104e14:	0f 84 46 01 00 00    	je     80104f60 <create+0x170>
    return 0;
  ilock(dp);
80104e1a:	83 ec 0c             	sub    $0xc,%esp
80104e1d:	89 c3                	mov    %eax,%ebx
80104e1f:	50                   	push   %eax
80104e20:	e8 5b c9 ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e25:	83 c4 0c             	add    $0xc,%esp
80104e28:	6a 00                	push   $0x0
80104e2a:	57                   	push   %edi
80104e2b:	53                   	push   %ebx
80104e2c:	e8 af ce ff ff       	call   80101ce0 <dirlookup>
80104e31:	83 c4 10             	add    $0x10,%esp
80104e34:	89 c6                	mov    %eax,%esi
80104e36:	85 c0                	test   %eax,%eax
80104e38:	74 56                	je     80104e90 <create+0xa0>
    iunlockput(dp);
80104e3a:	83 ec 0c             	sub    $0xc,%esp
80104e3d:	53                   	push   %ebx
80104e3e:	e8 cd cb ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104e43:	89 34 24             	mov    %esi,(%esp)
80104e46:	e8 35 c9 ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e4b:	83 c4 10             	add    $0x10,%esp
80104e4e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e53:	75 1b                	jne    80104e70 <create+0x80>
80104e55:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104e5a:	75 14                	jne    80104e70 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e5f:	89 f0                	mov    %esi,%eax
80104e61:	5b                   	pop    %ebx
80104e62:	5e                   	pop    %esi
80104e63:	5f                   	pop    %edi
80104e64:	5d                   	pop    %ebp
80104e65:	c3                   	ret    
80104e66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104e70:	83 ec 0c             	sub    $0xc,%esp
80104e73:	56                   	push   %esi
    return 0;
80104e74:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104e76:	e8 95 cb ff ff       	call   80101a10 <iunlockput>
    return 0;
80104e7b:	83 c4 10             	add    $0x10,%esp
}
80104e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e81:	89 f0                	mov    %esi,%eax
80104e83:	5b                   	pop    %ebx
80104e84:	5e                   	pop    %esi
80104e85:	5f                   	pop    %edi
80104e86:	5d                   	pop    %ebp
80104e87:	c3                   	ret    
80104e88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e8f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104e90:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e94:	83 ec 08             	sub    $0x8,%esp
80104e97:	50                   	push   %eax
80104e98:	ff 33                	push   (%ebx)
80104e9a:	e8 71 c7 ff ff       	call   80101610 <ialloc>
80104e9f:	83 c4 10             	add    $0x10,%esp
80104ea2:	89 c6                	mov    %eax,%esi
80104ea4:	85 c0                	test   %eax,%eax
80104ea6:	0f 84 cd 00 00 00    	je     80104f79 <create+0x189>
  ilock(ip);
80104eac:	83 ec 0c             	sub    $0xc,%esp
80104eaf:	50                   	push   %eax
80104eb0:	e8 cb c8 ff ff       	call   80101780 <ilock>
  ip->major = major;
80104eb5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104eb9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104ebd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ec1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104ec5:	b8 01 00 00 00       	mov    $0x1,%eax
80104eca:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104ece:	89 34 24             	mov    %esi,(%esp)
80104ed1:	e8 fa c7 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ed6:	83 c4 10             	add    $0x10,%esp
80104ed9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104ede:	74 30                	je     80104f10 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104ee0:	83 ec 04             	sub    $0x4,%esp
80104ee3:	ff 76 04             	push   0x4(%esi)
80104ee6:	57                   	push   %edi
80104ee7:	53                   	push   %ebx
80104ee8:	e8 f3 d0 ff ff       	call   80101fe0 <dirlink>
80104eed:	83 c4 10             	add    $0x10,%esp
80104ef0:	85 c0                	test   %eax,%eax
80104ef2:	78 78                	js     80104f6c <create+0x17c>
  iunlockput(dp);
80104ef4:	83 ec 0c             	sub    $0xc,%esp
80104ef7:	53                   	push   %ebx
80104ef8:	e8 13 cb ff ff       	call   80101a10 <iunlockput>
  return ip;
80104efd:	83 c4 10             	add    $0x10,%esp
}
80104f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f03:	89 f0                	mov    %esi,%eax
80104f05:	5b                   	pop    %ebx
80104f06:	5e                   	pop    %esi
80104f07:	5f                   	pop    %edi
80104f08:	5d                   	pop    %ebp
80104f09:	c3                   	ret    
80104f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104f10:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104f13:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104f18:	53                   	push   %ebx
80104f19:	e8 b2 c7 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f1e:	83 c4 0c             	add    $0xc,%esp
80104f21:	ff 76 04             	push   0x4(%esi)
80104f24:	68 c4 7e 10 80       	push   $0x80107ec4
80104f29:	56                   	push   %esi
80104f2a:	e8 b1 d0 ff ff       	call   80101fe0 <dirlink>
80104f2f:	83 c4 10             	add    $0x10,%esp
80104f32:	85 c0                	test   %eax,%eax
80104f34:	78 18                	js     80104f4e <create+0x15e>
80104f36:	83 ec 04             	sub    $0x4,%esp
80104f39:	ff 73 04             	push   0x4(%ebx)
80104f3c:	68 c3 7e 10 80       	push   $0x80107ec3
80104f41:	56                   	push   %esi
80104f42:	e8 99 d0 ff ff       	call   80101fe0 <dirlink>
80104f47:	83 c4 10             	add    $0x10,%esp
80104f4a:	85 c0                	test   %eax,%eax
80104f4c:	79 92                	jns    80104ee0 <create+0xf0>
      panic("create dots");
80104f4e:	83 ec 0c             	sub    $0xc,%esp
80104f51:	68 b7 7e 10 80       	push   $0x80107eb7
80104f56:	e8 25 b4 ff ff       	call   80100380 <panic>
80104f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f5f:	90                   	nop
}
80104f60:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104f63:	31 f6                	xor    %esi,%esi
}
80104f65:	5b                   	pop    %ebx
80104f66:	89 f0                	mov    %esi,%eax
80104f68:	5e                   	pop    %esi
80104f69:	5f                   	pop    %edi
80104f6a:	5d                   	pop    %ebp
80104f6b:	c3                   	ret    
    panic("create: dirlink");
80104f6c:	83 ec 0c             	sub    $0xc,%esp
80104f6f:	68 c6 7e 10 80       	push   $0x80107ec6
80104f74:	e8 07 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104f79:	83 ec 0c             	sub    $0xc,%esp
80104f7c:	68 a8 7e 10 80       	push   $0x80107ea8
80104f81:	e8 fa b3 ff ff       	call   80100380 <panic>
80104f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi

80104f90 <sys_dup>:
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	56                   	push   %esi
80104f94:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f95:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f98:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f9b:	50                   	push   %eax
80104f9c:	6a 00                	push   $0x0
80104f9e:	e8 9d fc ff ff       	call   80104c40 <argint>
80104fa3:	83 c4 10             	add    $0x10,%esp
80104fa6:	85 c0                	test   %eax,%eax
80104fa8:	78 36                	js     80104fe0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104faa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fae:	77 30                	ja     80104fe0 <sys_dup+0x50>
80104fb0:	e8 db ec ff ff       	call   80103c90 <myproc>
80104fb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fb8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fbc:	85 f6                	test   %esi,%esi
80104fbe:	74 20                	je     80104fe0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104fc0:	e8 cb ec ff ff       	call   80103c90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104fc5:	31 db                	xor    %ebx,%ebx
80104fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fce:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104fd0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104fd4:	85 d2                	test   %edx,%edx
80104fd6:	74 18                	je     80104ff0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104fd8:	83 c3 01             	add    $0x1,%ebx
80104fdb:	83 fb 10             	cmp    $0x10,%ebx
80104fde:	75 f0                	jne    80104fd0 <sys_dup+0x40>
}
80104fe0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104fe3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104fe8:	89 d8                	mov    %ebx,%eax
80104fea:	5b                   	pop    %ebx
80104feb:	5e                   	pop    %esi
80104fec:	5d                   	pop    %ebp
80104fed:	c3                   	ret    
80104fee:	66 90                	xchg   %ax,%ax
  filedup(f);
80104ff0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104ff3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104ff7:	56                   	push   %esi
80104ff8:	e8 a3 be ff ff       	call   80100ea0 <filedup>
  return fd;
80104ffd:	83 c4 10             	add    $0x10,%esp
}
80105000:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105003:	89 d8                	mov    %ebx,%eax
80105005:	5b                   	pop    %ebx
80105006:	5e                   	pop    %esi
80105007:	5d                   	pop    %ebp
80105008:	c3                   	ret    
80105009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105010 <sys_read>:
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105015:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105018:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010501b:	53                   	push   %ebx
8010501c:	6a 00                	push   $0x0
8010501e:	e8 1d fc ff ff       	call   80104c40 <argint>
80105023:	83 c4 10             	add    $0x10,%esp
80105026:	85 c0                	test   %eax,%eax
80105028:	78 5e                	js     80105088 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010502a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010502e:	77 58                	ja     80105088 <sys_read+0x78>
80105030:	e8 5b ec ff ff       	call   80103c90 <myproc>
80105035:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105038:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010503c:	85 f6                	test   %esi,%esi
8010503e:	74 48                	je     80105088 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105040:	83 ec 08             	sub    $0x8,%esp
80105043:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105046:	50                   	push   %eax
80105047:	6a 02                	push   $0x2
80105049:	e8 f2 fb ff ff       	call   80104c40 <argint>
8010504e:	83 c4 10             	add    $0x10,%esp
80105051:	85 c0                	test   %eax,%eax
80105053:	78 33                	js     80105088 <sys_read+0x78>
80105055:	83 ec 04             	sub    $0x4,%esp
80105058:	ff 75 f0             	push   -0x10(%ebp)
8010505b:	53                   	push   %ebx
8010505c:	6a 01                	push   $0x1
8010505e:	e8 2d fc ff ff       	call   80104c90 <argptr>
80105063:	83 c4 10             	add    $0x10,%esp
80105066:	85 c0                	test   %eax,%eax
80105068:	78 1e                	js     80105088 <sys_read+0x78>
  return fileread(f, p, n);
8010506a:	83 ec 04             	sub    $0x4,%esp
8010506d:	ff 75 f0             	push   -0x10(%ebp)
80105070:	ff 75 f4             	push   -0xc(%ebp)
80105073:	56                   	push   %esi
80105074:	e8 a7 bf ff ff       	call   80101020 <fileread>
80105079:	83 c4 10             	add    $0x10,%esp
}
8010507c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010507f:	5b                   	pop    %ebx
80105080:	5e                   	pop    %esi
80105081:	5d                   	pop    %ebp
80105082:	c3                   	ret    
80105083:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105087:	90                   	nop
    return -1;
80105088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010508d:	eb ed                	jmp    8010507c <sys_read+0x6c>
8010508f:	90                   	nop

80105090 <sys_write>:
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	56                   	push   %esi
80105094:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105095:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105098:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010509b:	53                   	push   %ebx
8010509c:	6a 00                	push   $0x0
8010509e:	e8 9d fb ff ff       	call   80104c40 <argint>
801050a3:	83 c4 10             	add    $0x10,%esp
801050a6:	85 c0                	test   %eax,%eax
801050a8:	78 5e                	js     80105108 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050ae:	77 58                	ja     80105108 <sys_write+0x78>
801050b0:	e8 db eb ff ff       	call   80103c90 <myproc>
801050b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050b8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050bc:	85 f6                	test   %esi,%esi
801050be:	74 48                	je     80105108 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050c0:	83 ec 08             	sub    $0x8,%esp
801050c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050c6:	50                   	push   %eax
801050c7:	6a 02                	push   $0x2
801050c9:	e8 72 fb ff ff       	call   80104c40 <argint>
801050ce:	83 c4 10             	add    $0x10,%esp
801050d1:	85 c0                	test   %eax,%eax
801050d3:	78 33                	js     80105108 <sys_write+0x78>
801050d5:	83 ec 04             	sub    $0x4,%esp
801050d8:	ff 75 f0             	push   -0x10(%ebp)
801050db:	53                   	push   %ebx
801050dc:	6a 01                	push   $0x1
801050de:	e8 ad fb ff ff       	call   80104c90 <argptr>
801050e3:	83 c4 10             	add    $0x10,%esp
801050e6:	85 c0                	test   %eax,%eax
801050e8:	78 1e                	js     80105108 <sys_write+0x78>
  return filewrite(f, p, n);
801050ea:	83 ec 04             	sub    $0x4,%esp
801050ed:	ff 75 f0             	push   -0x10(%ebp)
801050f0:	ff 75 f4             	push   -0xc(%ebp)
801050f3:	56                   	push   %esi
801050f4:	e8 b7 bf ff ff       	call   801010b0 <filewrite>
801050f9:	83 c4 10             	add    $0x10,%esp
}
801050fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050ff:	5b                   	pop    %ebx
80105100:	5e                   	pop    %esi
80105101:	5d                   	pop    %ebp
80105102:	c3                   	ret    
80105103:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105107:	90                   	nop
    return -1;
80105108:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010510d:	eb ed                	jmp    801050fc <sys_write+0x6c>
8010510f:	90                   	nop

80105110 <sys_close>:
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	56                   	push   %esi
80105114:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105115:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105118:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010511b:	50                   	push   %eax
8010511c:	6a 00                	push   $0x0
8010511e:	e8 1d fb ff ff       	call   80104c40 <argint>
80105123:	83 c4 10             	add    $0x10,%esp
80105126:	85 c0                	test   %eax,%eax
80105128:	78 3e                	js     80105168 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010512a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010512e:	77 38                	ja     80105168 <sys_close+0x58>
80105130:	e8 5b eb ff ff       	call   80103c90 <myproc>
80105135:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105138:	8d 5a 08             	lea    0x8(%edx),%ebx
8010513b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010513f:	85 f6                	test   %esi,%esi
80105141:	74 25                	je     80105168 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105143:	e8 48 eb ff ff       	call   80103c90 <myproc>
  fileclose(f);
80105148:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010514b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105152:	00 
  fileclose(f);
80105153:	56                   	push   %esi
80105154:	e8 97 bd ff ff       	call   80100ef0 <fileclose>
  return 0;
80105159:	83 c4 10             	add    $0x10,%esp
8010515c:	31 c0                	xor    %eax,%eax
}
8010515e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105161:	5b                   	pop    %ebx
80105162:	5e                   	pop    %esi
80105163:	5d                   	pop    %ebp
80105164:	c3                   	ret    
80105165:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010516d:	eb ef                	jmp    8010515e <sys_close+0x4e>
8010516f:	90                   	nop

80105170 <sys_fstat>:
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	56                   	push   %esi
80105174:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105175:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105178:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010517b:	53                   	push   %ebx
8010517c:	6a 00                	push   $0x0
8010517e:	e8 bd fa ff ff       	call   80104c40 <argint>
80105183:	83 c4 10             	add    $0x10,%esp
80105186:	85 c0                	test   %eax,%eax
80105188:	78 46                	js     801051d0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010518a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010518e:	77 40                	ja     801051d0 <sys_fstat+0x60>
80105190:	e8 fb ea ff ff       	call   80103c90 <myproc>
80105195:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105198:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010519c:	85 f6                	test   %esi,%esi
8010519e:	74 30                	je     801051d0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051a0:	83 ec 04             	sub    $0x4,%esp
801051a3:	6a 14                	push   $0x14
801051a5:	53                   	push   %ebx
801051a6:	6a 01                	push   $0x1
801051a8:	e8 e3 fa ff ff       	call   80104c90 <argptr>
801051ad:	83 c4 10             	add    $0x10,%esp
801051b0:	85 c0                	test   %eax,%eax
801051b2:	78 1c                	js     801051d0 <sys_fstat+0x60>
  return filestat(f, st);
801051b4:	83 ec 08             	sub    $0x8,%esp
801051b7:	ff 75 f4             	push   -0xc(%ebp)
801051ba:	56                   	push   %esi
801051bb:	e8 10 be ff ff       	call   80100fd0 <filestat>
801051c0:	83 c4 10             	add    $0x10,%esp
}
801051c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051c6:	5b                   	pop    %ebx
801051c7:	5e                   	pop    %esi
801051c8:	5d                   	pop    %ebp
801051c9:	c3                   	ret    
801051ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801051d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051d5:	eb ec                	jmp    801051c3 <sys_fstat+0x53>
801051d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051de:	66 90                	xchg   %ax,%ax

801051e0 <sys_link>:
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	57                   	push   %edi
801051e4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051e5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801051e8:	53                   	push   %ebx
801051e9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051ec:	50                   	push   %eax
801051ed:	6a 00                	push   $0x0
801051ef:	e8 0c fb ff ff       	call   80104d00 <argstr>
801051f4:	83 c4 10             	add    $0x10,%esp
801051f7:	85 c0                	test   %eax,%eax
801051f9:	0f 88 fb 00 00 00    	js     801052fa <sys_link+0x11a>
801051ff:	83 ec 08             	sub    $0x8,%esp
80105202:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105205:	50                   	push   %eax
80105206:	6a 01                	push   $0x1
80105208:	e8 f3 fa ff ff       	call   80104d00 <argstr>
8010520d:	83 c4 10             	add    $0x10,%esp
80105210:	85 c0                	test   %eax,%eax
80105212:	0f 88 e2 00 00 00    	js     801052fa <sys_link+0x11a>
  begin_op();
80105218:	e8 63 de ff ff       	call   80103080 <begin_op>
  if((ip = namei(old)) == 0){
8010521d:	83 ec 0c             	sub    $0xc,%esp
80105220:	ff 75 d4             	push   -0x2c(%ebp)
80105223:	e8 78 ce ff ff       	call   801020a0 <namei>
80105228:	83 c4 10             	add    $0x10,%esp
8010522b:	89 c3                	mov    %eax,%ebx
8010522d:	85 c0                	test   %eax,%eax
8010522f:	0f 84 e4 00 00 00    	je     80105319 <sys_link+0x139>
  ilock(ip);
80105235:	83 ec 0c             	sub    $0xc,%esp
80105238:	50                   	push   %eax
80105239:	e8 42 c5 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
8010523e:	83 c4 10             	add    $0x10,%esp
80105241:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105246:	0f 84 b5 00 00 00    	je     80105301 <sys_link+0x121>
  iupdate(ip);
8010524c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010524f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105254:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105257:	53                   	push   %ebx
80105258:	e8 73 c4 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010525d:	89 1c 24             	mov    %ebx,(%esp)
80105260:	e8 fb c5 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105265:	58                   	pop    %eax
80105266:	5a                   	pop    %edx
80105267:	57                   	push   %edi
80105268:	ff 75 d0             	push   -0x30(%ebp)
8010526b:	e8 50 ce ff ff       	call   801020c0 <nameiparent>
80105270:	83 c4 10             	add    $0x10,%esp
80105273:	89 c6                	mov    %eax,%esi
80105275:	85 c0                	test   %eax,%eax
80105277:	74 5b                	je     801052d4 <sys_link+0xf4>
  ilock(dp);
80105279:	83 ec 0c             	sub    $0xc,%esp
8010527c:	50                   	push   %eax
8010527d:	e8 fe c4 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105282:	8b 03                	mov    (%ebx),%eax
80105284:	83 c4 10             	add    $0x10,%esp
80105287:	39 06                	cmp    %eax,(%esi)
80105289:	75 3d                	jne    801052c8 <sys_link+0xe8>
8010528b:	83 ec 04             	sub    $0x4,%esp
8010528e:	ff 73 04             	push   0x4(%ebx)
80105291:	57                   	push   %edi
80105292:	56                   	push   %esi
80105293:	e8 48 cd ff ff       	call   80101fe0 <dirlink>
80105298:	83 c4 10             	add    $0x10,%esp
8010529b:	85 c0                	test   %eax,%eax
8010529d:	78 29                	js     801052c8 <sys_link+0xe8>
  iunlockput(dp);
8010529f:	83 ec 0c             	sub    $0xc,%esp
801052a2:	56                   	push   %esi
801052a3:	e8 68 c7 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
801052a8:	89 1c 24             	mov    %ebx,(%esp)
801052ab:	e8 00 c6 ff ff       	call   801018b0 <iput>
  end_op();
801052b0:	e8 3b de ff ff       	call   801030f0 <end_op>
  return 0;
801052b5:	83 c4 10             	add    $0x10,%esp
801052b8:	31 c0                	xor    %eax,%eax
}
801052ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052bd:	5b                   	pop    %ebx
801052be:	5e                   	pop    %esi
801052bf:	5f                   	pop    %edi
801052c0:	5d                   	pop    %ebp
801052c1:	c3                   	ret    
801052c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801052c8:	83 ec 0c             	sub    $0xc,%esp
801052cb:	56                   	push   %esi
801052cc:	e8 3f c7 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801052d1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	53                   	push   %ebx
801052d8:	e8 a3 c4 ff ff       	call   80101780 <ilock>
  ip->nlink--;
801052dd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052e2:	89 1c 24             	mov    %ebx,(%esp)
801052e5:	e8 e6 c3 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801052ea:	89 1c 24             	mov    %ebx,(%esp)
801052ed:	e8 1e c7 ff ff       	call   80101a10 <iunlockput>
  end_op();
801052f2:	e8 f9 dd ff ff       	call   801030f0 <end_op>
  return -1;
801052f7:	83 c4 10             	add    $0x10,%esp
801052fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ff:	eb b9                	jmp    801052ba <sys_link+0xda>
    iunlockput(ip);
80105301:	83 ec 0c             	sub    $0xc,%esp
80105304:	53                   	push   %ebx
80105305:	e8 06 c7 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010530a:	e8 e1 dd ff ff       	call   801030f0 <end_op>
    return -1;
8010530f:	83 c4 10             	add    $0x10,%esp
80105312:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105317:	eb a1                	jmp    801052ba <sys_link+0xda>
    end_op();
80105319:	e8 d2 dd ff ff       	call   801030f0 <end_op>
    return -1;
8010531e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105323:	eb 95                	jmp    801052ba <sys_link+0xda>
80105325:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105330 <sys_unlink>:
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	57                   	push   %edi
80105334:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105335:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105338:	53                   	push   %ebx
80105339:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010533c:	50                   	push   %eax
8010533d:	6a 00                	push   $0x0
8010533f:	e8 bc f9 ff ff       	call   80104d00 <argstr>
80105344:	83 c4 10             	add    $0x10,%esp
80105347:	85 c0                	test   %eax,%eax
80105349:	0f 88 7a 01 00 00    	js     801054c9 <sys_unlink+0x199>
  begin_op();
8010534f:	e8 2c dd ff ff       	call   80103080 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105354:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105357:	83 ec 08             	sub    $0x8,%esp
8010535a:	53                   	push   %ebx
8010535b:	ff 75 c0             	push   -0x40(%ebp)
8010535e:	e8 5d cd ff ff       	call   801020c0 <nameiparent>
80105363:	83 c4 10             	add    $0x10,%esp
80105366:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105369:	85 c0                	test   %eax,%eax
8010536b:	0f 84 62 01 00 00    	je     801054d3 <sys_unlink+0x1a3>
  ilock(dp);
80105371:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105374:	83 ec 0c             	sub    $0xc,%esp
80105377:	57                   	push   %edi
80105378:	e8 03 c4 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010537d:	58                   	pop    %eax
8010537e:	5a                   	pop    %edx
8010537f:	68 c4 7e 10 80       	push   $0x80107ec4
80105384:	53                   	push   %ebx
80105385:	e8 36 c9 ff ff       	call   80101cc0 <namecmp>
8010538a:	83 c4 10             	add    $0x10,%esp
8010538d:	85 c0                	test   %eax,%eax
8010538f:	0f 84 fb 00 00 00    	je     80105490 <sys_unlink+0x160>
80105395:	83 ec 08             	sub    $0x8,%esp
80105398:	68 c3 7e 10 80       	push   $0x80107ec3
8010539d:	53                   	push   %ebx
8010539e:	e8 1d c9 ff ff       	call   80101cc0 <namecmp>
801053a3:	83 c4 10             	add    $0x10,%esp
801053a6:	85 c0                	test   %eax,%eax
801053a8:	0f 84 e2 00 00 00    	je     80105490 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801053ae:	83 ec 04             	sub    $0x4,%esp
801053b1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801053b4:	50                   	push   %eax
801053b5:	53                   	push   %ebx
801053b6:	57                   	push   %edi
801053b7:	e8 24 c9 ff ff       	call   80101ce0 <dirlookup>
801053bc:	83 c4 10             	add    $0x10,%esp
801053bf:	89 c3                	mov    %eax,%ebx
801053c1:	85 c0                	test   %eax,%eax
801053c3:	0f 84 c7 00 00 00    	je     80105490 <sys_unlink+0x160>
  ilock(ip);
801053c9:	83 ec 0c             	sub    $0xc,%esp
801053cc:	50                   	push   %eax
801053cd:	e8 ae c3 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
801053d2:	83 c4 10             	add    $0x10,%esp
801053d5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801053da:	0f 8e 1c 01 00 00    	jle    801054fc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801053e0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053e5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801053e8:	74 66                	je     80105450 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801053ea:	83 ec 04             	sub    $0x4,%esp
801053ed:	6a 10                	push   $0x10
801053ef:	6a 00                	push   $0x0
801053f1:	57                   	push   %edi
801053f2:	e8 89 f5 ff ff       	call   80104980 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053f7:	6a 10                	push   $0x10
801053f9:	ff 75 c4             	push   -0x3c(%ebp)
801053fc:	57                   	push   %edi
801053fd:	ff 75 b4             	push   -0x4c(%ebp)
80105400:	e8 8b c7 ff ff       	call   80101b90 <writei>
80105405:	83 c4 20             	add    $0x20,%esp
80105408:	83 f8 10             	cmp    $0x10,%eax
8010540b:	0f 85 de 00 00 00    	jne    801054ef <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105411:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105416:	0f 84 94 00 00 00    	je     801054b0 <sys_unlink+0x180>
  iunlockput(dp);
8010541c:	83 ec 0c             	sub    $0xc,%esp
8010541f:	ff 75 b4             	push   -0x4c(%ebp)
80105422:	e8 e9 c5 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105427:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010542c:	89 1c 24             	mov    %ebx,(%esp)
8010542f:	e8 9c c2 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105434:	89 1c 24             	mov    %ebx,(%esp)
80105437:	e8 d4 c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010543c:	e8 af dc ff ff       	call   801030f0 <end_op>
  return 0;
80105441:	83 c4 10             	add    $0x10,%esp
80105444:	31 c0                	xor    %eax,%eax
}
80105446:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105449:	5b                   	pop    %ebx
8010544a:	5e                   	pop    %esi
8010544b:	5f                   	pop    %edi
8010544c:	5d                   	pop    %ebp
8010544d:	c3                   	ret    
8010544e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105450:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105454:	76 94                	jbe    801053ea <sys_unlink+0xba>
80105456:	be 20 00 00 00       	mov    $0x20,%esi
8010545b:	eb 0b                	jmp    80105468 <sys_unlink+0x138>
8010545d:	8d 76 00             	lea    0x0(%esi),%esi
80105460:	83 c6 10             	add    $0x10,%esi
80105463:	3b 73 58             	cmp    0x58(%ebx),%esi
80105466:	73 82                	jae    801053ea <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105468:	6a 10                	push   $0x10
8010546a:	56                   	push   %esi
8010546b:	57                   	push   %edi
8010546c:	53                   	push   %ebx
8010546d:	e8 1e c6 ff ff       	call   80101a90 <readi>
80105472:	83 c4 10             	add    $0x10,%esp
80105475:	83 f8 10             	cmp    $0x10,%eax
80105478:	75 68                	jne    801054e2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010547a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010547f:	74 df                	je     80105460 <sys_unlink+0x130>
    iunlockput(ip);
80105481:	83 ec 0c             	sub    $0xc,%esp
80105484:	53                   	push   %ebx
80105485:	e8 86 c5 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010548a:	83 c4 10             	add    $0x10,%esp
8010548d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	ff 75 b4             	push   -0x4c(%ebp)
80105496:	e8 75 c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010549b:	e8 50 dc ff ff       	call   801030f0 <end_op>
  return -1;
801054a0:	83 c4 10             	add    $0x10,%esp
801054a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054a8:	eb 9c                	jmp    80105446 <sys_unlink+0x116>
801054aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801054b0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801054b3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801054b6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801054bb:	50                   	push   %eax
801054bc:	e8 0f c2 ff ff       	call   801016d0 <iupdate>
801054c1:	83 c4 10             	add    $0x10,%esp
801054c4:	e9 53 ff ff ff       	jmp    8010541c <sys_unlink+0xec>
    return -1;
801054c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ce:	e9 73 ff ff ff       	jmp    80105446 <sys_unlink+0x116>
    end_op();
801054d3:	e8 18 dc ff ff       	call   801030f0 <end_op>
    return -1;
801054d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054dd:	e9 64 ff ff ff       	jmp    80105446 <sys_unlink+0x116>
      panic("isdirempty: readi");
801054e2:	83 ec 0c             	sub    $0xc,%esp
801054e5:	68 e8 7e 10 80       	push   $0x80107ee8
801054ea:	e8 91 ae ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801054ef:	83 ec 0c             	sub    $0xc,%esp
801054f2:	68 fa 7e 10 80       	push   $0x80107efa
801054f7:	e8 84 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801054fc:	83 ec 0c             	sub    $0xc,%esp
801054ff:	68 d6 7e 10 80       	push   $0x80107ed6
80105504:	e8 77 ae ff ff       	call   80100380 <panic>
80105509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105510 <sys_open>:

int
sys_open(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	57                   	push   %edi
80105514:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105515:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105518:	53                   	push   %ebx
80105519:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010551c:	50                   	push   %eax
8010551d:	6a 00                	push   $0x0
8010551f:	e8 dc f7 ff ff       	call   80104d00 <argstr>
80105524:	83 c4 10             	add    $0x10,%esp
80105527:	85 c0                	test   %eax,%eax
80105529:	0f 88 8e 00 00 00    	js     801055bd <sys_open+0xad>
8010552f:	83 ec 08             	sub    $0x8,%esp
80105532:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105535:	50                   	push   %eax
80105536:	6a 01                	push   $0x1
80105538:	e8 03 f7 ff ff       	call   80104c40 <argint>
8010553d:	83 c4 10             	add    $0x10,%esp
80105540:	85 c0                	test   %eax,%eax
80105542:	78 79                	js     801055bd <sys_open+0xad>
    return -1;

  begin_op();
80105544:	e8 37 db ff ff       	call   80103080 <begin_op>

  if(omode & O_CREATE){
80105549:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010554d:	75 79                	jne    801055c8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010554f:	83 ec 0c             	sub    $0xc,%esp
80105552:	ff 75 e0             	push   -0x20(%ebp)
80105555:	e8 46 cb ff ff       	call   801020a0 <namei>
8010555a:	83 c4 10             	add    $0x10,%esp
8010555d:	89 c6                	mov    %eax,%esi
8010555f:	85 c0                	test   %eax,%eax
80105561:	0f 84 7e 00 00 00    	je     801055e5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105567:	83 ec 0c             	sub    $0xc,%esp
8010556a:	50                   	push   %eax
8010556b:	e8 10 c2 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105570:	83 c4 10             	add    $0x10,%esp
80105573:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105578:	0f 84 c2 00 00 00    	je     80105640 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010557e:	e8 ad b8 ff ff       	call   80100e30 <filealloc>
80105583:	89 c7                	mov    %eax,%edi
80105585:	85 c0                	test   %eax,%eax
80105587:	74 23                	je     801055ac <sys_open+0x9c>
  struct proc *curproc = myproc();
80105589:	e8 02 e7 ff ff       	call   80103c90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010558e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105590:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105594:	85 d2                	test   %edx,%edx
80105596:	74 60                	je     801055f8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105598:	83 c3 01             	add    $0x1,%ebx
8010559b:	83 fb 10             	cmp    $0x10,%ebx
8010559e:	75 f0                	jne    80105590 <sys_open+0x80>
    if(f)
      fileclose(f);
801055a0:	83 ec 0c             	sub    $0xc,%esp
801055a3:	57                   	push   %edi
801055a4:	e8 47 b9 ff ff       	call   80100ef0 <fileclose>
801055a9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801055ac:	83 ec 0c             	sub    $0xc,%esp
801055af:	56                   	push   %esi
801055b0:	e8 5b c4 ff ff       	call   80101a10 <iunlockput>
    end_op();
801055b5:	e8 36 db ff ff       	call   801030f0 <end_op>
    return -1;
801055ba:	83 c4 10             	add    $0x10,%esp
801055bd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055c2:	eb 6d                	jmp    80105631 <sys_open+0x121>
801055c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801055c8:	83 ec 0c             	sub    $0xc,%esp
801055cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055ce:	31 c9                	xor    %ecx,%ecx
801055d0:	ba 02 00 00 00       	mov    $0x2,%edx
801055d5:	6a 00                	push   $0x0
801055d7:	e8 14 f8 ff ff       	call   80104df0 <create>
    if(ip == 0){
801055dc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801055df:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801055e1:	85 c0                	test   %eax,%eax
801055e3:	75 99                	jne    8010557e <sys_open+0x6e>
      end_op();
801055e5:	e8 06 db ff ff       	call   801030f0 <end_op>
      return -1;
801055ea:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055ef:	eb 40                	jmp    80105631 <sys_open+0x121>
801055f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801055f8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801055fb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801055ff:	56                   	push   %esi
80105600:	e8 5b c2 ff ff       	call   80101860 <iunlock>
  end_op();
80105605:	e8 e6 da ff ff       	call   801030f0 <end_op>

  f->type = FD_INODE;
8010560a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105610:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105613:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105616:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105619:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010561b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105622:	f7 d0                	not    %eax
80105624:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105627:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010562a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010562d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105631:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105634:	89 d8                	mov    %ebx,%eax
80105636:	5b                   	pop    %ebx
80105637:	5e                   	pop    %esi
80105638:	5f                   	pop    %edi
80105639:	5d                   	pop    %ebp
8010563a:	c3                   	ret    
8010563b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010563f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105640:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105643:	85 c9                	test   %ecx,%ecx
80105645:	0f 84 33 ff ff ff    	je     8010557e <sys_open+0x6e>
8010564b:	e9 5c ff ff ff       	jmp    801055ac <sys_open+0x9c>

80105650 <sys_mkdir>:

int
sys_mkdir(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105656:	e8 25 da ff ff       	call   80103080 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010565b:	83 ec 08             	sub    $0x8,%esp
8010565e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105661:	50                   	push   %eax
80105662:	6a 00                	push   $0x0
80105664:	e8 97 f6 ff ff       	call   80104d00 <argstr>
80105669:	83 c4 10             	add    $0x10,%esp
8010566c:	85 c0                	test   %eax,%eax
8010566e:	78 30                	js     801056a0 <sys_mkdir+0x50>
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105676:	31 c9                	xor    %ecx,%ecx
80105678:	ba 01 00 00 00       	mov    $0x1,%edx
8010567d:	6a 00                	push   $0x0
8010567f:	e8 6c f7 ff ff       	call   80104df0 <create>
80105684:	83 c4 10             	add    $0x10,%esp
80105687:	85 c0                	test   %eax,%eax
80105689:	74 15                	je     801056a0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010568b:	83 ec 0c             	sub    $0xc,%esp
8010568e:	50                   	push   %eax
8010568f:	e8 7c c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105694:	e8 57 da ff ff       	call   801030f0 <end_op>
  return 0;
80105699:	83 c4 10             	add    $0x10,%esp
8010569c:	31 c0                	xor    %eax,%eax
}
8010569e:	c9                   	leave  
8010569f:	c3                   	ret    
    end_op();
801056a0:	e8 4b da ff ff       	call   801030f0 <end_op>
    return -1;
801056a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056aa:	c9                   	leave  
801056ab:	c3                   	ret    
801056ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056b0 <sys_mknod>:

int
sys_mknod(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801056b6:	e8 c5 d9 ff ff       	call   80103080 <begin_op>
  if((argstr(0, &path)) < 0 ||
801056bb:	83 ec 08             	sub    $0x8,%esp
801056be:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056c1:	50                   	push   %eax
801056c2:	6a 00                	push   $0x0
801056c4:	e8 37 f6 ff ff       	call   80104d00 <argstr>
801056c9:	83 c4 10             	add    $0x10,%esp
801056cc:	85 c0                	test   %eax,%eax
801056ce:	78 60                	js     80105730 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801056d0:	83 ec 08             	sub    $0x8,%esp
801056d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056d6:	50                   	push   %eax
801056d7:	6a 01                	push   $0x1
801056d9:	e8 62 f5 ff ff       	call   80104c40 <argint>
  if((argstr(0, &path)) < 0 ||
801056de:	83 c4 10             	add    $0x10,%esp
801056e1:	85 c0                	test   %eax,%eax
801056e3:	78 4b                	js     80105730 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801056e5:	83 ec 08             	sub    $0x8,%esp
801056e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056eb:	50                   	push   %eax
801056ec:	6a 02                	push   $0x2
801056ee:	e8 4d f5 ff ff       	call   80104c40 <argint>
     argint(1, &major) < 0 ||
801056f3:	83 c4 10             	add    $0x10,%esp
801056f6:	85 c0                	test   %eax,%eax
801056f8:	78 36                	js     80105730 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801056fa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801056fe:	83 ec 0c             	sub    $0xc,%esp
80105701:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105705:	ba 03 00 00 00       	mov    $0x3,%edx
8010570a:	50                   	push   %eax
8010570b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010570e:	e8 dd f6 ff ff       	call   80104df0 <create>
     argint(2, &minor) < 0 ||
80105713:	83 c4 10             	add    $0x10,%esp
80105716:	85 c0                	test   %eax,%eax
80105718:	74 16                	je     80105730 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010571a:	83 ec 0c             	sub    $0xc,%esp
8010571d:	50                   	push   %eax
8010571e:	e8 ed c2 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105723:	e8 c8 d9 ff ff       	call   801030f0 <end_op>
  return 0;
80105728:	83 c4 10             	add    $0x10,%esp
8010572b:	31 c0                	xor    %eax,%eax
}
8010572d:	c9                   	leave  
8010572e:	c3                   	ret    
8010572f:	90                   	nop
    end_op();
80105730:	e8 bb d9 ff ff       	call   801030f0 <end_op>
    return -1;
80105735:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010573a:	c9                   	leave  
8010573b:	c3                   	ret    
8010573c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105740 <sys_chdir>:

int
sys_chdir(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	56                   	push   %esi
80105744:	53                   	push   %ebx
80105745:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105748:	e8 43 e5 ff ff       	call   80103c90 <myproc>
8010574d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010574f:	e8 2c d9 ff ff       	call   80103080 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105754:	83 ec 08             	sub    $0x8,%esp
80105757:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010575a:	50                   	push   %eax
8010575b:	6a 00                	push   $0x0
8010575d:	e8 9e f5 ff ff       	call   80104d00 <argstr>
80105762:	83 c4 10             	add    $0x10,%esp
80105765:	85 c0                	test   %eax,%eax
80105767:	78 77                	js     801057e0 <sys_chdir+0xa0>
80105769:	83 ec 0c             	sub    $0xc,%esp
8010576c:	ff 75 f4             	push   -0xc(%ebp)
8010576f:	e8 2c c9 ff ff       	call   801020a0 <namei>
80105774:	83 c4 10             	add    $0x10,%esp
80105777:	89 c3                	mov    %eax,%ebx
80105779:	85 c0                	test   %eax,%eax
8010577b:	74 63                	je     801057e0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010577d:	83 ec 0c             	sub    $0xc,%esp
80105780:	50                   	push   %eax
80105781:	e8 fa bf ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105786:	83 c4 10             	add    $0x10,%esp
80105789:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010578e:	75 30                	jne    801057c0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	53                   	push   %ebx
80105794:	e8 c7 c0 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105799:	58                   	pop    %eax
8010579a:	ff 76 68             	push   0x68(%esi)
8010579d:	e8 0e c1 ff ff       	call   801018b0 <iput>
  end_op();
801057a2:	e8 49 d9 ff ff       	call   801030f0 <end_op>
  curproc->cwd = ip;
801057a7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801057aa:	83 c4 10             	add    $0x10,%esp
801057ad:	31 c0                	xor    %eax,%eax
}
801057af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057b2:	5b                   	pop    %ebx
801057b3:	5e                   	pop    %esi
801057b4:	5d                   	pop    %ebp
801057b5:	c3                   	ret    
801057b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057bd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	53                   	push   %ebx
801057c4:	e8 47 c2 ff ff       	call   80101a10 <iunlockput>
    end_op();
801057c9:	e8 22 d9 ff ff       	call   801030f0 <end_op>
    return -1;
801057ce:	83 c4 10             	add    $0x10,%esp
801057d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d6:	eb d7                	jmp    801057af <sys_chdir+0x6f>
801057d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057df:	90                   	nop
    end_op();
801057e0:	e8 0b d9 ff ff       	call   801030f0 <end_op>
    return -1;
801057e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ea:	eb c3                	jmp    801057af <sys_chdir+0x6f>
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_exec>:

int
sys_exec(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	57                   	push   %edi
801057f4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057f5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801057fb:	53                   	push   %ebx
801057fc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105802:	50                   	push   %eax
80105803:	6a 00                	push   $0x0
80105805:	e8 f6 f4 ff ff       	call   80104d00 <argstr>
8010580a:	83 c4 10             	add    $0x10,%esp
8010580d:	85 c0                	test   %eax,%eax
8010580f:	0f 88 87 00 00 00    	js     8010589c <sys_exec+0xac>
80105815:	83 ec 08             	sub    $0x8,%esp
80105818:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010581e:	50                   	push   %eax
8010581f:	6a 01                	push   $0x1
80105821:	e8 1a f4 ff ff       	call   80104c40 <argint>
80105826:	83 c4 10             	add    $0x10,%esp
80105829:	85 c0                	test   %eax,%eax
8010582b:	78 6f                	js     8010589c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010582d:	83 ec 04             	sub    $0x4,%esp
80105830:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105836:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105838:	68 80 00 00 00       	push   $0x80
8010583d:	6a 00                	push   $0x0
8010583f:	56                   	push   %esi
80105840:	e8 3b f1 ff ff       	call   80104980 <memset>
80105845:	83 c4 10             	add    $0x10,%esp
80105848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105850:	83 ec 08             	sub    $0x8,%esp
80105853:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105859:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105860:	50                   	push   %eax
80105861:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105867:	01 f8                	add    %edi,%eax
80105869:	50                   	push   %eax
8010586a:	e8 41 f3 ff ff       	call   80104bb0 <fetchint>
8010586f:	83 c4 10             	add    $0x10,%esp
80105872:	85 c0                	test   %eax,%eax
80105874:	78 26                	js     8010589c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105876:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010587c:	85 c0                	test   %eax,%eax
8010587e:	74 30                	je     801058b0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105880:	83 ec 08             	sub    $0x8,%esp
80105883:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105886:	52                   	push   %edx
80105887:	50                   	push   %eax
80105888:	e8 63 f3 ff ff       	call   80104bf0 <fetchstr>
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	85 c0                	test   %eax,%eax
80105892:	78 08                	js     8010589c <sys_exec+0xac>
  for(i=0;; i++){
80105894:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105897:	83 fb 20             	cmp    $0x20,%ebx
8010589a:	75 b4                	jne    80105850 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010589c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010589f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058a4:	5b                   	pop    %ebx
801058a5:	5e                   	pop    %esi
801058a6:	5f                   	pop    %edi
801058a7:	5d                   	pop    %ebp
801058a8:	c3                   	ret    
801058a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801058b0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801058b7:	00 00 00 00 
  return exec(path, argv);
801058bb:	83 ec 08             	sub    $0x8,%esp
801058be:	56                   	push   %esi
801058bf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801058c5:	e8 e6 b1 ff ff       	call   80100ab0 <exec>
801058ca:	83 c4 10             	add    $0x10,%esp
}
801058cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058d0:	5b                   	pop    %ebx
801058d1:	5e                   	pop    %esi
801058d2:	5f                   	pop    %edi
801058d3:	5d                   	pop    %ebp
801058d4:	c3                   	ret    
801058d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058e0 <sys_pipe>:

int
sys_pipe(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	57                   	push   %edi
801058e4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801058e8:	53                   	push   %ebx
801058e9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058ec:	6a 08                	push   $0x8
801058ee:	50                   	push   %eax
801058ef:	6a 00                	push   $0x0
801058f1:	e8 9a f3 ff ff       	call   80104c90 <argptr>
801058f6:	83 c4 10             	add    $0x10,%esp
801058f9:	85 c0                	test   %eax,%eax
801058fb:	78 4a                	js     80105947 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058fd:	83 ec 08             	sub    $0x8,%esp
80105900:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105903:	50                   	push   %eax
80105904:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105907:	50                   	push   %eax
80105908:	e8 43 de ff ff       	call   80103750 <pipealloc>
8010590d:	83 c4 10             	add    $0x10,%esp
80105910:	85 c0                	test   %eax,%eax
80105912:	78 33                	js     80105947 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105914:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105917:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105919:	e8 72 e3 ff ff       	call   80103c90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010591e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105920:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105924:	85 f6                	test   %esi,%esi
80105926:	74 28                	je     80105950 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105928:	83 c3 01             	add    $0x1,%ebx
8010592b:	83 fb 10             	cmp    $0x10,%ebx
8010592e:	75 f0                	jne    80105920 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105930:	83 ec 0c             	sub    $0xc,%esp
80105933:	ff 75 e0             	push   -0x20(%ebp)
80105936:	e8 b5 b5 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010593b:	58                   	pop    %eax
8010593c:	ff 75 e4             	push   -0x1c(%ebp)
8010593f:	e8 ac b5 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105944:	83 c4 10             	add    $0x10,%esp
80105947:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010594c:	eb 53                	jmp    801059a1 <sys_pipe+0xc1>
8010594e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105950:	8d 73 08             	lea    0x8(%ebx),%esi
80105953:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105957:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010595a:	e8 31 e3 ff ff       	call   80103c90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010595f:	31 d2                	xor    %edx,%edx
80105961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105968:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010596c:	85 c9                	test   %ecx,%ecx
8010596e:	74 20                	je     80105990 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105970:	83 c2 01             	add    $0x1,%edx
80105973:	83 fa 10             	cmp    $0x10,%edx
80105976:	75 f0                	jne    80105968 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105978:	e8 13 e3 ff ff       	call   80103c90 <myproc>
8010597d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105984:	00 
80105985:	eb a9                	jmp    80105930 <sys_pipe+0x50>
80105987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105990:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105994:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105997:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105999:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010599c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010599f:	31 c0                	xor    %eax,%eax
}
801059a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059a4:	5b                   	pop    %ebx
801059a5:	5e                   	pop    %esi
801059a6:	5f                   	pop    %edi
801059a7:	5d                   	pop    %ebp
801059a8:	c3                   	ret    
801059a9:	66 90                	xchg   %ax,%ax
801059ab:	66 90                	xchg   %ax,%ax
801059ad:	66 90                	xchg   %ax,%ax
801059af:	90                   	nop

801059b0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801059b0:	e9 7b e4 ff ff       	jmp    80103e30 <fork>
801059b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059c0 <sys_exit>:
}

int
sys_exit(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059c6:	e8 e5 e6 ff ff       	call   801040b0 <exit>
  return 0;  // not reached
}
801059cb:	31 c0                	xor    %eax,%eax
801059cd:	c9                   	leave  
801059ce:	c3                   	ret    
801059cf:	90                   	nop

801059d0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801059d0:	e9 0b e8 ff ff       	jmp    801041e0 <wait>
801059d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059e0 <sys_kill>:
}

int
sys_kill(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801059e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059e9:	50                   	push   %eax
801059ea:	6a 00                	push   $0x0
801059ec:	e8 4f f2 ff ff       	call   80104c40 <argint>
801059f1:	83 c4 10             	add    $0x10,%esp
801059f4:	85 c0                	test   %eax,%eax
801059f6:	78 18                	js     80105a10 <sys_kill+0x30>
    return -1;
  return kill(pid);
801059f8:	83 ec 0c             	sub    $0xc,%esp
801059fb:	ff 75 f4             	push   -0xc(%ebp)
801059fe:	e8 7d ea ff ff       	call   80104480 <kill>
80105a03:	83 c4 10             	add    $0x10,%esp
}
80105a06:	c9                   	leave  
80105a07:	c3                   	ret    
80105a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0f:	90                   	nop
80105a10:	c9                   	leave  
    return -1;
80105a11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a16:	c3                   	ret    
80105a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1e:	66 90                	xchg   %ax,%ax

80105a20 <sys_getpid>:

int
sys_getpid(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a26:	e8 65 e2 ff ff       	call   80103c90 <myproc>
80105a2b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a2e:	c9                   	leave  
80105a2f:	c3                   	ret    

80105a30 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a34:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a37:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a3a:	50                   	push   %eax
80105a3b:	6a 00                	push   $0x0
80105a3d:	e8 fe f1 ff ff       	call   80104c40 <argint>
80105a42:	83 c4 10             	add    $0x10,%esp
80105a45:	85 c0                	test   %eax,%eax
80105a47:	78 27                	js     80105a70 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a49:	e8 42 e2 ff ff       	call   80103c90 <myproc>
  if(growproc(n) < 0)
80105a4e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a51:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a53:	ff 75 f4             	push   -0xc(%ebp)
80105a56:	e8 55 e3 ff ff       	call   80103db0 <growproc>
80105a5b:	83 c4 10             	add    $0x10,%esp
80105a5e:	85 c0                	test   %eax,%eax
80105a60:	78 0e                	js     80105a70 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a62:	89 d8                	mov    %ebx,%eax
80105a64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a67:	c9                   	leave  
80105a68:	c3                   	ret    
80105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a70:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a75:	eb eb                	jmp    80105a62 <sys_sbrk+0x32>
80105a77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a7e:	66 90                	xchg   %ax,%ax

80105a80 <sys_sleep>:

int
sys_sleep(void)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a84:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a87:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a8a:	50                   	push   %eax
80105a8b:	6a 00                	push   $0x0
80105a8d:	e8 ae f1 ff ff       	call   80104c40 <argint>
80105a92:	83 c4 10             	add    $0x10,%esp
80105a95:	85 c0                	test   %eax,%eax
80105a97:	0f 88 8a 00 00 00    	js     80105b27 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a9d:	83 ec 0c             	sub    $0xc,%esp
80105aa0:	68 80 cc 14 80       	push   $0x8014cc80
80105aa5:	e8 16 ee ff ff       	call   801048c0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105aaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105aad:	8b 1d 60 cc 14 80    	mov    0x8014cc60,%ebx
  while(ticks - ticks0 < n){
80105ab3:	83 c4 10             	add    $0x10,%esp
80105ab6:	85 d2                	test   %edx,%edx
80105ab8:	75 27                	jne    80105ae1 <sys_sleep+0x61>
80105aba:	eb 54                	jmp    80105b10 <sys_sleep+0x90>
80105abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ac0:	83 ec 08             	sub    $0x8,%esp
80105ac3:	68 80 cc 14 80       	push   $0x8014cc80
80105ac8:	68 60 cc 14 80       	push   $0x8014cc60
80105acd:	e8 8e e8 ff ff       	call   80104360 <sleep>
  while(ticks - ticks0 < n){
80105ad2:	a1 60 cc 14 80       	mov    0x8014cc60,%eax
80105ad7:	83 c4 10             	add    $0x10,%esp
80105ada:	29 d8                	sub    %ebx,%eax
80105adc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105adf:	73 2f                	jae    80105b10 <sys_sleep+0x90>
    if(myproc()->killed){
80105ae1:	e8 aa e1 ff ff       	call   80103c90 <myproc>
80105ae6:	8b 40 24             	mov    0x24(%eax),%eax
80105ae9:	85 c0                	test   %eax,%eax
80105aeb:	74 d3                	je     80105ac0 <sys_sleep+0x40>
      release(&tickslock);
80105aed:	83 ec 0c             	sub    $0xc,%esp
80105af0:	68 80 cc 14 80       	push   $0x8014cc80
80105af5:	e8 66 ed ff ff       	call   80104860 <release>
  }
  release(&tickslock);
  return 0;
}
80105afa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105afd:	83 c4 10             	add    $0x10,%esp
80105b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b05:	c9                   	leave  
80105b06:	c3                   	ret    
80105b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105b10:	83 ec 0c             	sub    $0xc,%esp
80105b13:	68 80 cc 14 80       	push   $0x8014cc80
80105b18:	e8 43 ed ff ff       	call   80104860 <release>
  return 0;
80105b1d:	83 c4 10             	add    $0x10,%esp
80105b20:	31 c0                	xor    %eax,%eax
}
80105b22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b25:	c9                   	leave  
80105b26:	c3                   	ret    
    return -1;
80105b27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b2c:	eb f4                	jmp    80105b22 <sys_sleep+0xa2>
80105b2e:	66 90                	xchg   %ax,%ax

80105b30 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	53                   	push   %ebx
80105b34:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b37:	68 80 cc 14 80       	push   $0x8014cc80
80105b3c:	e8 7f ed ff ff       	call   801048c0 <acquire>
  xticks = ticks;
80105b41:	8b 1d 60 cc 14 80    	mov    0x8014cc60,%ebx
  release(&tickslock);
80105b47:	c7 04 24 80 cc 14 80 	movl   $0x8014cc80,(%esp)
80105b4e:	e8 0d ed ff ff       	call   80104860 <release>
  return xticks;
}
80105b53:	89 d8                	mov    %ebx,%eax
80105b55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b58:	c9                   	leave  
80105b59:	c3                   	ret    

80105b5a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b5a:	1e                   	push   %ds
  pushl %es
80105b5b:	06                   	push   %es
  pushl %fs
80105b5c:	0f a0                	push   %fs
  pushl %gs
80105b5e:	0f a8                	push   %gs
  pushal
80105b60:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b61:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b65:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b67:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b69:	54                   	push   %esp
  call trap
80105b6a:	e8 c1 00 00 00       	call   80105c30 <trap>
  addl $4, %esp
80105b6f:	83 c4 04             	add    $0x4,%esp

80105b72 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b72:	61                   	popa   
  popl %gs
80105b73:	0f a9                	pop    %gs
  popl %fs
80105b75:	0f a1                	pop    %fs
  popl %es
80105b77:	07                   	pop    %es
  popl %ds
80105b78:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b79:	83 c4 08             	add    $0x8,%esp
  iret
80105b7c:	cf                   	iret   
80105b7d:	66 90                	xchg   %ax,%ax
80105b7f:	90                   	nop

80105b80 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b80:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b81:	31 c0                	xor    %eax,%eax
{
80105b83:	89 e5                	mov    %esp,%ebp
80105b85:	83 ec 08             	sub    $0x8,%esp
80105b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b90:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105b97:	c7 04 c5 c2 cc 14 80 	movl   $0x8e000008,-0x7feb333e(,%eax,8)
80105b9e:	08 00 00 8e 
80105ba2:	66 89 14 c5 c0 cc 14 	mov    %dx,-0x7feb3340(,%eax,8)
80105ba9:	80 
80105baa:	c1 ea 10             	shr    $0x10,%edx
80105bad:	66 89 14 c5 c6 cc 14 	mov    %dx,-0x7feb333a(,%eax,8)
80105bb4:	80 
  for(i = 0; i < 256; i++)
80105bb5:	83 c0 01             	add    $0x1,%eax
80105bb8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bbd:	75 d1                	jne    80105b90 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105bbf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bc2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105bc7:	c7 05 c2 ce 14 80 08 	movl   $0xef000008,0x8014cec2
80105bce:	00 00 ef 
  initlock(&tickslock, "time");
80105bd1:	68 09 7f 10 80       	push   $0x80107f09
80105bd6:	68 80 cc 14 80       	push   $0x8014cc80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bdb:	66 a3 c0 ce 14 80    	mov    %ax,0x8014cec0
80105be1:	c1 e8 10             	shr    $0x10,%eax
80105be4:	66 a3 c6 ce 14 80    	mov    %ax,0x8014cec6
  initlock(&tickslock, "time");
80105bea:	e8 01 eb ff ff       	call   801046f0 <initlock>
}
80105bef:	83 c4 10             	add    $0x10,%esp
80105bf2:	c9                   	leave  
80105bf3:	c3                   	ret    
80105bf4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bff:	90                   	nop

80105c00 <idtinit>:

void
idtinit(void)
{
80105c00:	55                   	push   %ebp
  pd[0] = size-1;
80105c01:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c06:	89 e5                	mov    %esp,%ebp
80105c08:	83 ec 10             	sub    $0x10,%esp
80105c0b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c0f:	b8 c0 cc 14 80       	mov    $0x8014ccc0,%eax
80105c14:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c18:	c1 e8 10             	shr    $0x10,%eax
80105c1b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c1f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c22:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c25:	c9                   	leave  
80105c26:	c3                   	ret    
80105c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2e:	66 90                	xchg   %ax,%ax

80105c30 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	57                   	push   %edi
80105c34:	56                   	push   %esi
80105c35:	53                   	push   %ebx
80105c36:	83 ec 1c             	sub    $0x1c,%esp
80105c39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105c3c:	8b 43 30             	mov    0x30(%ebx),%eax
80105c3f:	83 f8 40             	cmp    $0x40,%eax
80105c42:	0f 84 30 01 00 00    	je     80105d78 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c48:	83 e8 0e             	sub    $0xe,%eax
80105c4b:	83 f8 31             	cmp    $0x31,%eax
80105c4e:	0f 87 8c 00 00 00    	ja     80105ce0 <trap+0xb0>
80105c54:	ff 24 85 b0 7f 10 80 	jmp    *-0x7fef8050(,%eax,4)
80105c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c5f:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105c60:	e8 0b e0 ff ff       	call   80103c70 <cpuid>
80105c65:	85 c0                	test   %eax,%eax
80105c67:	0f 84 13 02 00 00    	je     80105e80 <trap+0x250>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105c6d:	e8 be cf ff ff       	call   80102c30 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c72:	e8 19 e0 ff ff       	call   80103c90 <myproc>
80105c77:	85 c0                	test   %eax,%eax
80105c79:	74 1d                	je     80105c98 <trap+0x68>
80105c7b:	e8 10 e0 ff ff       	call   80103c90 <myproc>
80105c80:	8b 50 24             	mov    0x24(%eax),%edx
80105c83:	85 d2                	test   %edx,%edx
80105c85:	74 11                	je     80105c98 <trap+0x68>
80105c87:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c8b:	83 e0 03             	and    $0x3,%eax
80105c8e:	66 83 f8 03          	cmp    $0x3,%ax
80105c92:	0f 84 c8 01 00 00    	je     80105e60 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105c98:	e8 f3 df ff ff       	call   80103c90 <myproc>
80105c9d:	85 c0                	test   %eax,%eax
80105c9f:	74 0f                	je     80105cb0 <trap+0x80>
80105ca1:	e8 ea df ff ff       	call   80103c90 <myproc>
80105ca6:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105caa:	0f 84 b0 00 00 00    	je     80105d60 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cb0:	e8 db df ff ff       	call   80103c90 <myproc>
80105cb5:	85 c0                	test   %eax,%eax
80105cb7:	74 1d                	je     80105cd6 <trap+0xa6>
80105cb9:	e8 d2 df ff ff       	call   80103c90 <myproc>
80105cbe:	8b 40 24             	mov    0x24(%eax),%eax
80105cc1:	85 c0                	test   %eax,%eax
80105cc3:	74 11                	je     80105cd6 <trap+0xa6>
80105cc5:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105cc9:	83 e0 03             	and    $0x3,%eax
80105ccc:	66 83 f8 03          	cmp    $0x3,%ax
80105cd0:	0f 84 cf 00 00 00    	je     80105da5 <trap+0x175>
    exit();
}
80105cd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cd9:	5b                   	pop    %ebx
80105cda:	5e                   	pop    %esi
80105cdb:	5f                   	pop    %edi
80105cdc:	5d                   	pop    %ebp
80105cdd:	c3                   	ret    
80105cde:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105ce0:	e8 ab df ff ff       	call   80103c90 <myproc>
80105ce5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105ce8:	85 c0                	test   %eax,%eax
80105cea:	0f 84 c4 01 00 00    	je     80105eb4 <trap+0x284>
80105cf0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105cf4:	0f 84 ba 01 00 00    	je     80105eb4 <trap+0x284>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105cfa:	0f 20 d1             	mov    %cr2,%ecx
80105cfd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d00:	e8 6b df ff ff       	call   80103c70 <cpuid>
80105d05:	8b 73 30             	mov    0x30(%ebx),%esi
80105d08:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d0b:	8b 43 34             	mov    0x34(%ebx),%eax
80105d0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105d11:	e8 7a df ff ff       	call   80103c90 <myproc>
80105d16:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d19:	e8 72 df ff ff       	call   80103c90 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d1e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d21:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d24:	51                   	push   %ecx
80105d25:	57                   	push   %edi
80105d26:	52                   	push   %edx
80105d27:	ff 75 e4             	push   -0x1c(%ebp)
80105d2a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d2b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105d2e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d31:	56                   	push   %esi
80105d32:	ff 70 10             	push   0x10(%eax)
80105d35:	68 6c 7f 10 80       	push   $0x80107f6c
80105d3a:	e8 61 a9 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105d3f:	83 c4 20             	add    $0x20,%esp
80105d42:	e8 49 df ff ff       	call   80103c90 <myproc>
80105d47:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d4e:	e8 3d df ff ff       	call   80103c90 <myproc>
80105d53:	85 c0                	test   %eax,%eax
80105d55:	0f 85 20 ff ff ff    	jne    80105c7b <trap+0x4b>
80105d5b:	e9 38 ff ff ff       	jmp    80105c98 <trap+0x68>
  if(myproc() && myproc()->state == RUNNING &&
80105d60:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d64:	0f 85 46 ff ff ff    	jne    80105cb0 <trap+0x80>
    yield();
80105d6a:	e8 a1 e5 ff ff       	call   80104310 <yield>
80105d6f:	e9 3c ff ff ff       	jmp    80105cb0 <trap+0x80>
80105d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105d78:	e8 13 df ff ff       	call   80103c90 <myproc>
80105d7d:	8b 70 24             	mov    0x24(%eax),%esi
80105d80:	85 f6                	test   %esi,%esi
80105d82:	0f 85 e8 00 00 00    	jne    80105e70 <trap+0x240>
    myproc()->tf = tf;
80105d88:	e8 03 df ff ff       	call   80103c90 <myproc>
80105d8d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105d90:	e8 eb ef ff ff       	call   80104d80 <syscall>
    if(myproc()->killed)
80105d95:	e8 f6 de ff ff       	call   80103c90 <myproc>
80105d9a:	8b 48 24             	mov    0x24(%eax),%ecx
80105d9d:	85 c9                	test   %ecx,%ecx
80105d9f:	0f 84 31 ff ff ff    	je     80105cd6 <trap+0xa6>
}
80105da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105da8:	5b                   	pop    %ebx
80105da9:	5e                   	pop    %esi
80105daa:	5f                   	pop    %edi
80105dab:	5d                   	pop    %ebp
      exit();
80105dac:	e9 ff e2 ff ff       	jmp    801040b0 <exit>
80105db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105db8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105dbb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105dbf:	e8 ac de ff ff       	call   80103c70 <cpuid>
80105dc4:	57                   	push   %edi
80105dc5:	56                   	push   %esi
80105dc6:	50                   	push   %eax
80105dc7:	68 14 7f 10 80       	push   $0x80107f14
80105dcc:	e8 cf a8 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105dd1:	e8 5a ce ff ff       	call   80102c30 <lapiceoi>
    break;
80105dd6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dd9:	e8 b2 de ff ff       	call   80103c90 <myproc>
80105dde:	85 c0                	test   %eax,%eax
80105de0:	0f 85 95 fe ff ff    	jne    80105c7b <trap+0x4b>
80105de6:	e9 ad fe ff ff       	jmp    80105c98 <trap+0x68>
80105deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105def:	90                   	nop
    kbdintr();
80105df0:	e8 fb cc ff ff       	call   80102af0 <kbdintr>
    lapiceoi();
80105df5:	e8 36 ce ff ff       	call   80102c30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dfa:	e8 91 de ff ff       	call   80103c90 <myproc>
80105dff:	85 c0                	test   %eax,%eax
80105e01:	0f 85 74 fe ff ff    	jne    80105c7b <trap+0x4b>
80105e07:	e9 8c fe ff ff       	jmp    80105c98 <trap+0x68>
80105e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e10:	e8 3b 02 00 00       	call   80106050 <uartintr>
    lapiceoi();
80105e15:	e8 16 ce ff ff       	call   80102c30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e1a:	e8 71 de ff ff       	call   80103c90 <myproc>
80105e1f:	85 c0                	test   %eax,%eax
80105e21:	0f 85 54 fe ff ff    	jne    80105c7b <trap+0x4b>
80105e27:	e9 6c fe ff ff       	jmp    80105c98 <trap+0x68>
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105e30:	e8 0b c4 ff ff       	call   80102240 <ideintr>
80105e35:	e9 33 fe ff ff       	jmp    80105c6d <trap+0x3d>
80105e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    CoW_handler();
80105e40:	e8 6b 16 00 00       	call   801074b0 <CoW_handler>
    lapiceoi();
80105e45:	e8 e6 cd ff ff       	call   80102c30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e4a:	e8 41 de ff ff       	call   80103c90 <myproc>
80105e4f:	85 c0                	test   %eax,%eax
80105e51:	0f 85 24 fe ff ff    	jne    80105c7b <trap+0x4b>
80105e57:	e9 3c fe ff ff       	jmp    80105c98 <trap+0x68>
80105e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105e60:	e8 4b e2 ff ff       	call   801040b0 <exit>
80105e65:	e9 2e fe ff ff       	jmp    80105c98 <trap+0x68>
80105e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105e70:	e8 3b e2 ff ff       	call   801040b0 <exit>
80105e75:	e9 0e ff ff ff       	jmp    80105d88 <trap+0x158>
80105e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105e80:	83 ec 0c             	sub    $0xc,%esp
80105e83:	68 80 cc 14 80       	push   $0x8014cc80
80105e88:	e8 33 ea ff ff       	call   801048c0 <acquire>
      wakeup(&ticks);
80105e8d:	c7 04 24 60 cc 14 80 	movl   $0x8014cc60,(%esp)
      ticks++;
80105e94:	83 05 60 cc 14 80 01 	addl   $0x1,0x8014cc60
      wakeup(&ticks);
80105e9b:	e8 80 e5 ff ff       	call   80104420 <wakeup>
      release(&tickslock);
80105ea0:	c7 04 24 80 cc 14 80 	movl   $0x8014cc80,(%esp)
80105ea7:	e8 b4 e9 ff ff       	call   80104860 <release>
80105eac:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105eaf:	e9 b9 fd ff ff       	jmp    80105c6d <trap+0x3d>
80105eb4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105eb7:	e8 b4 dd ff ff       	call   80103c70 <cpuid>
80105ebc:	83 ec 0c             	sub    $0xc,%esp
80105ebf:	56                   	push   %esi
80105ec0:	57                   	push   %edi
80105ec1:	50                   	push   %eax
80105ec2:	ff 73 30             	push   0x30(%ebx)
80105ec5:	68 38 7f 10 80       	push   $0x80107f38
80105eca:	e8 d1 a7 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105ecf:	83 c4 14             	add    $0x14,%esp
80105ed2:	68 0e 7f 10 80       	push   $0x80107f0e
80105ed7:	e8 a4 a4 ff ff       	call   80100380 <panic>
80105edc:	66 90                	xchg   %ax,%ax
80105ede:	66 90                	xchg   %ax,%ax

80105ee0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ee0:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	74 17                	je     80105f00 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ee9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105eee:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105eef:	a8 01                	test   $0x1,%al
80105ef1:	74 0d                	je     80105f00 <uartgetc+0x20>
80105ef3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ef8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ef9:	0f b6 c0             	movzbl %al,%eax
80105efc:	c3                   	ret    
80105efd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f05:	c3                   	ret    
80105f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f0d:	8d 76 00             	lea    0x0(%esi),%esi

80105f10 <uartinit>:
{
80105f10:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f11:	31 c9                	xor    %ecx,%ecx
80105f13:	89 c8                	mov    %ecx,%eax
80105f15:	89 e5                	mov    %esp,%ebp
80105f17:	57                   	push   %edi
80105f18:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105f1d:	56                   	push   %esi
80105f1e:	89 fa                	mov    %edi,%edx
80105f20:	53                   	push   %ebx
80105f21:	83 ec 1c             	sub    $0x1c,%esp
80105f24:	ee                   	out    %al,(%dx)
80105f25:	be fb 03 00 00       	mov    $0x3fb,%esi
80105f2a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f2f:	89 f2                	mov    %esi,%edx
80105f31:	ee                   	out    %al,(%dx)
80105f32:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f37:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f3c:	ee                   	out    %al,(%dx)
80105f3d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105f42:	89 c8                	mov    %ecx,%eax
80105f44:	89 da                	mov    %ebx,%edx
80105f46:	ee                   	out    %al,(%dx)
80105f47:	b8 03 00 00 00       	mov    $0x3,%eax
80105f4c:	89 f2                	mov    %esi,%edx
80105f4e:	ee                   	out    %al,(%dx)
80105f4f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f54:	89 c8                	mov    %ecx,%eax
80105f56:	ee                   	out    %al,(%dx)
80105f57:	b8 01 00 00 00       	mov    $0x1,%eax
80105f5c:	89 da                	mov    %ebx,%edx
80105f5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f5f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f64:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f65:	3c ff                	cmp    $0xff,%al
80105f67:	74 78                	je     80105fe1 <uartinit+0xd1>
  uart = 1;
80105f69:	c7 05 c0 d4 14 80 01 	movl   $0x1,0x8014d4c0
80105f70:	00 00 00 
80105f73:	89 fa                	mov    %edi,%edx
80105f75:	ec                   	in     (%dx),%al
80105f76:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f7b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f7c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105f7f:	bf 78 80 10 80       	mov    $0x80108078,%edi
80105f84:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105f89:	6a 00                	push   $0x0
80105f8b:	6a 04                	push   $0x4
80105f8d:	e8 ee c4 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105f92:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105f96:	83 c4 10             	add    $0x10,%esp
80105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105fa0:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
80105fa5:	bb 80 00 00 00       	mov    $0x80,%ebx
80105faa:	85 c0                	test   %eax,%eax
80105fac:	75 14                	jne    80105fc2 <uartinit+0xb2>
80105fae:	eb 23                	jmp    80105fd3 <uartinit+0xc3>
    microdelay(10);
80105fb0:	83 ec 0c             	sub    $0xc,%esp
80105fb3:	6a 0a                	push   $0xa
80105fb5:	e8 96 cc ff ff       	call   80102c50 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105fba:	83 c4 10             	add    $0x10,%esp
80105fbd:	83 eb 01             	sub    $0x1,%ebx
80105fc0:	74 07                	je     80105fc9 <uartinit+0xb9>
80105fc2:	89 f2                	mov    %esi,%edx
80105fc4:	ec                   	in     (%dx),%al
80105fc5:	a8 20                	test   $0x20,%al
80105fc7:	74 e7                	je     80105fb0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fc9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105fcd:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fd2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105fd3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105fd7:	83 c7 01             	add    $0x1,%edi
80105fda:	88 45 e7             	mov    %al,-0x19(%ebp)
80105fdd:	84 c0                	test   %al,%al
80105fdf:	75 bf                	jne    80105fa0 <uartinit+0x90>
}
80105fe1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fe4:	5b                   	pop    %ebx
80105fe5:	5e                   	pop    %esi
80105fe6:	5f                   	pop    %edi
80105fe7:	5d                   	pop    %ebp
80105fe8:	c3                   	ret    
80105fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ff0 <uartputc>:
  if(!uart)
80105ff0:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
80105ff5:	85 c0                	test   %eax,%eax
80105ff7:	74 47                	je     80106040 <uartputc+0x50>
{
80105ff9:	55                   	push   %ebp
80105ffa:	89 e5                	mov    %esp,%ebp
80105ffc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ffd:	be fd 03 00 00       	mov    $0x3fd,%esi
80106002:	53                   	push   %ebx
80106003:	bb 80 00 00 00       	mov    $0x80,%ebx
80106008:	eb 18                	jmp    80106022 <uartputc+0x32>
8010600a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106010:	83 ec 0c             	sub    $0xc,%esp
80106013:	6a 0a                	push   $0xa
80106015:	e8 36 cc ff ff       	call   80102c50 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010601a:	83 c4 10             	add    $0x10,%esp
8010601d:	83 eb 01             	sub    $0x1,%ebx
80106020:	74 07                	je     80106029 <uartputc+0x39>
80106022:	89 f2                	mov    %esi,%edx
80106024:	ec                   	in     (%dx),%al
80106025:	a8 20                	test   $0x20,%al
80106027:	74 e7                	je     80106010 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106029:	8b 45 08             	mov    0x8(%ebp),%eax
8010602c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106031:	ee                   	out    %al,(%dx)
}
80106032:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106035:	5b                   	pop    %ebx
80106036:	5e                   	pop    %esi
80106037:	5d                   	pop    %ebp
80106038:	c3                   	ret    
80106039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106040:	c3                   	ret    
80106041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010604f:	90                   	nop

80106050 <uartintr>:

void
uartintr(void)
{
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106056:	68 e0 5e 10 80       	push   $0x80105ee0
8010605b:	e8 20 a8 ff ff       	call   80100880 <consoleintr>
}
80106060:	83 c4 10             	add    $0x10,%esp
80106063:	c9                   	leave  
80106064:	c3                   	ret    

80106065 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106065:	6a 00                	push   $0x0
  pushl $0
80106067:	6a 00                	push   $0x0
  jmp alltraps
80106069:	e9 ec fa ff ff       	jmp    80105b5a <alltraps>

8010606e <vector1>:
.globl vector1
vector1:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $1
80106070:	6a 01                	push   $0x1
  jmp alltraps
80106072:	e9 e3 fa ff ff       	jmp    80105b5a <alltraps>

80106077 <vector2>:
.globl vector2
vector2:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $2
80106079:	6a 02                	push   $0x2
  jmp alltraps
8010607b:	e9 da fa ff ff       	jmp    80105b5a <alltraps>

80106080 <vector3>:
.globl vector3
vector3:
  pushl $0
80106080:	6a 00                	push   $0x0
  pushl $3
80106082:	6a 03                	push   $0x3
  jmp alltraps
80106084:	e9 d1 fa ff ff       	jmp    80105b5a <alltraps>

80106089 <vector4>:
.globl vector4
vector4:
  pushl $0
80106089:	6a 00                	push   $0x0
  pushl $4
8010608b:	6a 04                	push   $0x4
  jmp alltraps
8010608d:	e9 c8 fa ff ff       	jmp    80105b5a <alltraps>

80106092 <vector5>:
.globl vector5
vector5:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $5
80106094:	6a 05                	push   $0x5
  jmp alltraps
80106096:	e9 bf fa ff ff       	jmp    80105b5a <alltraps>

8010609b <vector6>:
.globl vector6
vector6:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $6
8010609d:	6a 06                	push   $0x6
  jmp alltraps
8010609f:	e9 b6 fa ff ff       	jmp    80105b5a <alltraps>

801060a4 <vector7>:
.globl vector7
vector7:
  pushl $0
801060a4:	6a 00                	push   $0x0
  pushl $7
801060a6:	6a 07                	push   $0x7
  jmp alltraps
801060a8:	e9 ad fa ff ff       	jmp    80105b5a <alltraps>

801060ad <vector8>:
.globl vector8
vector8:
  pushl $8
801060ad:	6a 08                	push   $0x8
  jmp alltraps
801060af:	e9 a6 fa ff ff       	jmp    80105b5a <alltraps>

801060b4 <vector9>:
.globl vector9
vector9:
  pushl $0
801060b4:	6a 00                	push   $0x0
  pushl $9
801060b6:	6a 09                	push   $0x9
  jmp alltraps
801060b8:	e9 9d fa ff ff       	jmp    80105b5a <alltraps>

801060bd <vector10>:
.globl vector10
vector10:
  pushl $10
801060bd:	6a 0a                	push   $0xa
  jmp alltraps
801060bf:	e9 96 fa ff ff       	jmp    80105b5a <alltraps>

801060c4 <vector11>:
.globl vector11
vector11:
  pushl $11
801060c4:	6a 0b                	push   $0xb
  jmp alltraps
801060c6:	e9 8f fa ff ff       	jmp    80105b5a <alltraps>

801060cb <vector12>:
.globl vector12
vector12:
  pushl $12
801060cb:	6a 0c                	push   $0xc
  jmp alltraps
801060cd:	e9 88 fa ff ff       	jmp    80105b5a <alltraps>

801060d2 <vector13>:
.globl vector13
vector13:
  pushl $13
801060d2:	6a 0d                	push   $0xd
  jmp alltraps
801060d4:	e9 81 fa ff ff       	jmp    80105b5a <alltraps>

801060d9 <vector14>:
.globl vector14
vector14:
  pushl $14
801060d9:	6a 0e                	push   $0xe
  jmp alltraps
801060db:	e9 7a fa ff ff       	jmp    80105b5a <alltraps>

801060e0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060e0:	6a 00                	push   $0x0
  pushl $15
801060e2:	6a 0f                	push   $0xf
  jmp alltraps
801060e4:	e9 71 fa ff ff       	jmp    80105b5a <alltraps>

801060e9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060e9:	6a 00                	push   $0x0
  pushl $16
801060eb:	6a 10                	push   $0x10
  jmp alltraps
801060ed:	e9 68 fa ff ff       	jmp    80105b5a <alltraps>

801060f2 <vector17>:
.globl vector17
vector17:
  pushl $17
801060f2:	6a 11                	push   $0x11
  jmp alltraps
801060f4:	e9 61 fa ff ff       	jmp    80105b5a <alltraps>

801060f9 <vector18>:
.globl vector18
vector18:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $18
801060fb:	6a 12                	push   $0x12
  jmp alltraps
801060fd:	e9 58 fa ff ff       	jmp    80105b5a <alltraps>

80106102 <vector19>:
.globl vector19
vector19:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $19
80106104:	6a 13                	push   $0x13
  jmp alltraps
80106106:	e9 4f fa ff ff       	jmp    80105b5a <alltraps>

8010610b <vector20>:
.globl vector20
vector20:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $20
8010610d:	6a 14                	push   $0x14
  jmp alltraps
8010610f:	e9 46 fa ff ff       	jmp    80105b5a <alltraps>

80106114 <vector21>:
.globl vector21
vector21:
  pushl $0
80106114:	6a 00                	push   $0x0
  pushl $21
80106116:	6a 15                	push   $0x15
  jmp alltraps
80106118:	e9 3d fa ff ff       	jmp    80105b5a <alltraps>

8010611d <vector22>:
.globl vector22
vector22:
  pushl $0
8010611d:	6a 00                	push   $0x0
  pushl $22
8010611f:	6a 16                	push   $0x16
  jmp alltraps
80106121:	e9 34 fa ff ff       	jmp    80105b5a <alltraps>

80106126 <vector23>:
.globl vector23
vector23:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $23
80106128:	6a 17                	push   $0x17
  jmp alltraps
8010612a:	e9 2b fa ff ff       	jmp    80105b5a <alltraps>

8010612f <vector24>:
.globl vector24
vector24:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $24
80106131:	6a 18                	push   $0x18
  jmp alltraps
80106133:	e9 22 fa ff ff       	jmp    80105b5a <alltraps>

80106138 <vector25>:
.globl vector25
vector25:
  pushl $0
80106138:	6a 00                	push   $0x0
  pushl $25
8010613a:	6a 19                	push   $0x19
  jmp alltraps
8010613c:	e9 19 fa ff ff       	jmp    80105b5a <alltraps>

80106141 <vector26>:
.globl vector26
vector26:
  pushl $0
80106141:	6a 00                	push   $0x0
  pushl $26
80106143:	6a 1a                	push   $0x1a
  jmp alltraps
80106145:	e9 10 fa ff ff       	jmp    80105b5a <alltraps>

8010614a <vector27>:
.globl vector27
vector27:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $27
8010614c:	6a 1b                	push   $0x1b
  jmp alltraps
8010614e:	e9 07 fa ff ff       	jmp    80105b5a <alltraps>

80106153 <vector28>:
.globl vector28
vector28:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $28
80106155:	6a 1c                	push   $0x1c
  jmp alltraps
80106157:	e9 fe f9 ff ff       	jmp    80105b5a <alltraps>

8010615c <vector29>:
.globl vector29
vector29:
  pushl $0
8010615c:	6a 00                	push   $0x0
  pushl $29
8010615e:	6a 1d                	push   $0x1d
  jmp alltraps
80106160:	e9 f5 f9 ff ff       	jmp    80105b5a <alltraps>

80106165 <vector30>:
.globl vector30
vector30:
  pushl $0
80106165:	6a 00                	push   $0x0
  pushl $30
80106167:	6a 1e                	push   $0x1e
  jmp alltraps
80106169:	e9 ec f9 ff ff       	jmp    80105b5a <alltraps>

8010616e <vector31>:
.globl vector31
vector31:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $31
80106170:	6a 1f                	push   $0x1f
  jmp alltraps
80106172:	e9 e3 f9 ff ff       	jmp    80105b5a <alltraps>

80106177 <vector32>:
.globl vector32
vector32:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $32
80106179:	6a 20                	push   $0x20
  jmp alltraps
8010617b:	e9 da f9 ff ff       	jmp    80105b5a <alltraps>

80106180 <vector33>:
.globl vector33
vector33:
  pushl $0
80106180:	6a 00                	push   $0x0
  pushl $33
80106182:	6a 21                	push   $0x21
  jmp alltraps
80106184:	e9 d1 f9 ff ff       	jmp    80105b5a <alltraps>

80106189 <vector34>:
.globl vector34
vector34:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $34
8010618b:	6a 22                	push   $0x22
  jmp alltraps
8010618d:	e9 c8 f9 ff ff       	jmp    80105b5a <alltraps>

80106192 <vector35>:
.globl vector35
vector35:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $35
80106194:	6a 23                	push   $0x23
  jmp alltraps
80106196:	e9 bf f9 ff ff       	jmp    80105b5a <alltraps>

8010619b <vector36>:
.globl vector36
vector36:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $36
8010619d:	6a 24                	push   $0x24
  jmp alltraps
8010619f:	e9 b6 f9 ff ff       	jmp    80105b5a <alltraps>

801061a4 <vector37>:
.globl vector37
vector37:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $37
801061a6:	6a 25                	push   $0x25
  jmp alltraps
801061a8:	e9 ad f9 ff ff       	jmp    80105b5a <alltraps>

801061ad <vector38>:
.globl vector38
vector38:
  pushl $0
801061ad:	6a 00                	push   $0x0
  pushl $38
801061af:	6a 26                	push   $0x26
  jmp alltraps
801061b1:	e9 a4 f9 ff ff       	jmp    80105b5a <alltraps>

801061b6 <vector39>:
.globl vector39
vector39:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $39
801061b8:	6a 27                	push   $0x27
  jmp alltraps
801061ba:	e9 9b f9 ff ff       	jmp    80105b5a <alltraps>

801061bf <vector40>:
.globl vector40
vector40:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $40
801061c1:	6a 28                	push   $0x28
  jmp alltraps
801061c3:	e9 92 f9 ff ff       	jmp    80105b5a <alltraps>

801061c8 <vector41>:
.globl vector41
vector41:
  pushl $0
801061c8:	6a 00                	push   $0x0
  pushl $41
801061ca:	6a 29                	push   $0x29
  jmp alltraps
801061cc:	e9 89 f9 ff ff       	jmp    80105b5a <alltraps>

801061d1 <vector42>:
.globl vector42
vector42:
  pushl $0
801061d1:	6a 00                	push   $0x0
  pushl $42
801061d3:	6a 2a                	push   $0x2a
  jmp alltraps
801061d5:	e9 80 f9 ff ff       	jmp    80105b5a <alltraps>

801061da <vector43>:
.globl vector43
vector43:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $43
801061dc:	6a 2b                	push   $0x2b
  jmp alltraps
801061de:	e9 77 f9 ff ff       	jmp    80105b5a <alltraps>

801061e3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $44
801061e5:	6a 2c                	push   $0x2c
  jmp alltraps
801061e7:	e9 6e f9 ff ff       	jmp    80105b5a <alltraps>

801061ec <vector45>:
.globl vector45
vector45:
  pushl $0
801061ec:	6a 00                	push   $0x0
  pushl $45
801061ee:	6a 2d                	push   $0x2d
  jmp alltraps
801061f0:	e9 65 f9 ff ff       	jmp    80105b5a <alltraps>

801061f5 <vector46>:
.globl vector46
vector46:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $46
801061f7:	6a 2e                	push   $0x2e
  jmp alltraps
801061f9:	e9 5c f9 ff ff       	jmp    80105b5a <alltraps>

801061fe <vector47>:
.globl vector47
vector47:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $47
80106200:	6a 2f                	push   $0x2f
  jmp alltraps
80106202:	e9 53 f9 ff ff       	jmp    80105b5a <alltraps>

80106207 <vector48>:
.globl vector48
vector48:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $48
80106209:	6a 30                	push   $0x30
  jmp alltraps
8010620b:	e9 4a f9 ff ff       	jmp    80105b5a <alltraps>

80106210 <vector49>:
.globl vector49
vector49:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $49
80106212:	6a 31                	push   $0x31
  jmp alltraps
80106214:	e9 41 f9 ff ff       	jmp    80105b5a <alltraps>

80106219 <vector50>:
.globl vector50
vector50:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $50
8010621b:	6a 32                	push   $0x32
  jmp alltraps
8010621d:	e9 38 f9 ff ff       	jmp    80105b5a <alltraps>

80106222 <vector51>:
.globl vector51
vector51:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $51
80106224:	6a 33                	push   $0x33
  jmp alltraps
80106226:	e9 2f f9 ff ff       	jmp    80105b5a <alltraps>

8010622b <vector52>:
.globl vector52
vector52:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $52
8010622d:	6a 34                	push   $0x34
  jmp alltraps
8010622f:	e9 26 f9 ff ff       	jmp    80105b5a <alltraps>

80106234 <vector53>:
.globl vector53
vector53:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $53
80106236:	6a 35                	push   $0x35
  jmp alltraps
80106238:	e9 1d f9 ff ff       	jmp    80105b5a <alltraps>

8010623d <vector54>:
.globl vector54
vector54:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $54
8010623f:	6a 36                	push   $0x36
  jmp alltraps
80106241:	e9 14 f9 ff ff       	jmp    80105b5a <alltraps>

80106246 <vector55>:
.globl vector55
vector55:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $55
80106248:	6a 37                	push   $0x37
  jmp alltraps
8010624a:	e9 0b f9 ff ff       	jmp    80105b5a <alltraps>

8010624f <vector56>:
.globl vector56
vector56:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $56
80106251:	6a 38                	push   $0x38
  jmp alltraps
80106253:	e9 02 f9 ff ff       	jmp    80105b5a <alltraps>

80106258 <vector57>:
.globl vector57
vector57:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $57
8010625a:	6a 39                	push   $0x39
  jmp alltraps
8010625c:	e9 f9 f8 ff ff       	jmp    80105b5a <alltraps>

80106261 <vector58>:
.globl vector58
vector58:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $58
80106263:	6a 3a                	push   $0x3a
  jmp alltraps
80106265:	e9 f0 f8 ff ff       	jmp    80105b5a <alltraps>

8010626a <vector59>:
.globl vector59
vector59:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $59
8010626c:	6a 3b                	push   $0x3b
  jmp alltraps
8010626e:	e9 e7 f8 ff ff       	jmp    80105b5a <alltraps>

80106273 <vector60>:
.globl vector60
vector60:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $60
80106275:	6a 3c                	push   $0x3c
  jmp alltraps
80106277:	e9 de f8 ff ff       	jmp    80105b5a <alltraps>

8010627c <vector61>:
.globl vector61
vector61:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $61
8010627e:	6a 3d                	push   $0x3d
  jmp alltraps
80106280:	e9 d5 f8 ff ff       	jmp    80105b5a <alltraps>

80106285 <vector62>:
.globl vector62
vector62:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $62
80106287:	6a 3e                	push   $0x3e
  jmp alltraps
80106289:	e9 cc f8 ff ff       	jmp    80105b5a <alltraps>

8010628e <vector63>:
.globl vector63
vector63:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $63
80106290:	6a 3f                	push   $0x3f
  jmp alltraps
80106292:	e9 c3 f8 ff ff       	jmp    80105b5a <alltraps>

80106297 <vector64>:
.globl vector64
vector64:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $64
80106299:	6a 40                	push   $0x40
  jmp alltraps
8010629b:	e9 ba f8 ff ff       	jmp    80105b5a <alltraps>

801062a0 <vector65>:
.globl vector65
vector65:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $65
801062a2:	6a 41                	push   $0x41
  jmp alltraps
801062a4:	e9 b1 f8 ff ff       	jmp    80105b5a <alltraps>

801062a9 <vector66>:
.globl vector66
vector66:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $66
801062ab:	6a 42                	push   $0x42
  jmp alltraps
801062ad:	e9 a8 f8 ff ff       	jmp    80105b5a <alltraps>

801062b2 <vector67>:
.globl vector67
vector67:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $67
801062b4:	6a 43                	push   $0x43
  jmp alltraps
801062b6:	e9 9f f8 ff ff       	jmp    80105b5a <alltraps>

801062bb <vector68>:
.globl vector68
vector68:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $68
801062bd:	6a 44                	push   $0x44
  jmp alltraps
801062bf:	e9 96 f8 ff ff       	jmp    80105b5a <alltraps>

801062c4 <vector69>:
.globl vector69
vector69:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $69
801062c6:	6a 45                	push   $0x45
  jmp alltraps
801062c8:	e9 8d f8 ff ff       	jmp    80105b5a <alltraps>

801062cd <vector70>:
.globl vector70
vector70:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $70
801062cf:	6a 46                	push   $0x46
  jmp alltraps
801062d1:	e9 84 f8 ff ff       	jmp    80105b5a <alltraps>

801062d6 <vector71>:
.globl vector71
vector71:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $71
801062d8:	6a 47                	push   $0x47
  jmp alltraps
801062da:	e9 7b f8 ff ff       	jmp    80105b5a <alltraps>

801062df <vector72>:
.globl vector72
vector72:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $72
801062e1:	6a 48                	push   $0x48
  jmp alltraps
801062e3:	e9 72 f8 ff ff       	jmp    80105b5a <alltraps>

801062e8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $73
801062ea:	6a 49                	push   $0x49
  jmp alltraps
801062ec:	e9 69 f8 ff ff       	jmp    80105b5a <alltraps>

801062f1 <vector74>:
.globl vector74
vector74:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $74
801062f3:	6a 4a                	push   $0x4a
  jmp alltraps
801062f5:	e9 60 f8 ff ff       	jmp    80105b5a <alltraps>

801062fa <vector75>:
.globl vector75
vector75:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $75
801062fc:	6a 4b                	push   $0x4b
  jmp alltraps
801062fe:	e9 57 f8 ff ff       	jmp    80105b5a <alltraps>

80106303 <vector76>:
.globl vector76
vector76:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $76
80106305:	6a 4c                	push   $0x4c
  jmp alltraps
80106307:	e9 4e f8 ff ff       	jmp    80105b5a <alltraps>

8010630c <vector77>:
.globl vector77
vector77:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $77
8010630e:	6a 4d                	push   $0x4d
  jmp alltraps
80106310:	e9 45 f8 ff ff       	jmp    80105b5a <alltraps>

80106315 <vector78>:
.globl vector78
vector78:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $78
80106317:	6a 4e                	push   $0x4e
  jmp alltraps
80106319:	e9 3c f8 ff ff       	jmp    80105b5a <alltraps>

8010631e <vector79>:
.globl vector79
vector79:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $79
80106320:	6a 4f                	push   $0x4f
  jmp alltraps
80106322:	e9 33 f8 ff ff       	jmp    80105b5a <alltraps>

80106327 <vector80>:
.globl vector80
vector80:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $80
80106329:	6a 50                	push   $0x50
  jmp alltraps
8010632b:	e9 2a f8 ff ff       	jmp    80105b5a <alltraps>

80106330 <vector81>:
.globl vector81
vector81:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $81
80106332:	6a 51                	push   $0x51
  jmp alltraps
80106334:	e9 21 f8 ff ff       	jmp    80105b5a <alltraps>

80106339 <vector82>:
.globl vector82
vector82:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $82
8010633b:	6a 52                	push   $0x52
  jmp alltraps
8010633d:	e9 18 f8 ff ff       	jmp    80105b5a <alltraps>

80106342 <vector83>:
.globl vector83
vector83:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $83
80106344:	6a 53                	push   $0x53
  jmp alltraps
80106346:	e9 0f f8 ff ff       	jmp    80105b5a <alltraps>

8010634b <vector84>:
.globl vector84
vector84:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $84
8010634d:	6a 54                	push   $0x54
  jmp alltraps
8010634f:	e9 06 f8 ff ff       	jmp    80105b5a <alltraps>

80106354 <vector85>:
.globl vector85
vector85:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $85
80106356:	6a 55                	push   $0x55
  jmp alltraps
80106358:	e9 fd f7 ff ff       	jmp    80105b5a <alltraps>

8010635d <vector86>:
.globl vector86
vector86:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $86
8010635f:	6a 56                	push   $0x56
  jmp alltraps
80106361:	e9 f4 f7 ff ff       	jmp    80105b5a <alltraps>

80106366 <vector87>:
.globl vector87
vector87:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $87
80106368:	6a 57                	push   $0x57
  jmp alltraps
8010636a:	e9 eb f7 ff ff       	jmp    80105b5a <alltraps>

8010636f <vector88>:
.globl vector88
vector88:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $88
80106371:	6a 58                	push   $0x58
  jmp alltraps
80106373:	e9 e2 f7 ff ff       	jmp    80105b5a <alltraps>

80106378 <vector89>:
.globl vector89
vector89:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $89
8010637a:	6a 59                	push   $0x59
  jmp alltraps
8010637c:	e9 d9 f7 ff ff       	jmp    80105b5a <alltraps>

80106381 <vector90>:
.globl vector90
vector90:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $90
80106383:	6a 5a                	push   $0x5a
  jmp alltraps
80106385:	e9 d0 f7 ff ff       	jmp    80105b5a <alltraps>

8010638a <vector91>:
.globl vector91
vector91:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $91
8010638c:	6a 5b                	push   $0x5b
  jmp alltraps
8010638e:	e9 c7 f7 ff ff       	jmp    80105b5a <alltraps>

80106393 <vector92>:
.globl vector92
vector92:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $92
80106395:	6a 5c                	push   $0x5c
  jmp alltraps
80106397:	e9 be f7 ff ff       	jmp    80105b5a <alltraps>

8010639c <vector93>:
.globl vector93
vector93:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $93
8010639e:	6a 5d                	push   $0x5d
  jmp alltraps
801063a0:	e9 b5 f7 ff ff       	jmp    80105b5a <alltraps>

801063a5 <vector94>:
.globl vector94
vector94:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $94
801063a7:	6a 5e                	push   $0x5e
  jmp alltraps
801063a9:	e9 ac f7 ff ff       	jmp    80105b5a <alltraps>

801063ae <vector95>:
.globl vector95
vector95:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $95
801063b0:	6a 5f                	push   $0x5f
  jmp alltraps
801063b2:	e9 a3 f7 ff ff       	jmp    80105b5a <alltraps>

801063b7 <vector96>:
.globl vector96
vector96:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $96
801063b9:	6a 60                	push   $0x60
  jmp alltraps
801063bb:	e9 9a f7 ff ff       	jmp    80105b5a <alltraps>

801063c0 <vector97>:
.globl vector97
vector97:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $97
801063c2:	6a 61                	push   $0x61
  jmp alltraps
801063c4:	e9 91 f7 ff ff       	jmp    80105b5a <alltraps>

801063c9 <vector98>:
.globl vector98
vector98:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $98
801063cb:	6a 62                	push   $0x62
  jmp alltraps
801063cd:	e9 88 f7 ff ff       	jmp    80105b5a <alltraps>

801063d2 <vector99>:
.globl vector99
vector99:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $99
801063d4:	6a 63                	push   $0x63
  jmp alltraps
801063d6:	e9 7f f7 ff ff       	jmp    80105b5a <alltraps>

801063db <vector100>:
.globl vector100
vector100:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $100
801063dd:	6a 64                	push   $0x64
  jmp alltraps
801063df:	e9 76 f7 ff ff       	jmp    80105b5a <alltraps>

801063e4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $101
801063e6:	6a 65                	push   $0x65
  jmp alltraps
801063e8:	e9 6d f7 ff ff       	jmp    80105b5a <alltraps>

801063ed <vector102>:
.globl vector102
vector102:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $102
801063ef:	6a 66                	push   $0x66
  jmp alltraps
801063f1:	e9 64 f7 ff ff       	jmp    80105b5a <alltraps>

801063f6 <vector103>:
.globl vector103
vector103:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $103
801063f8:	6a 67                	push   $0x67
  jmp alltraps
801063fa:	e9 5b f7 ff ff       	jmp    80105b5a <alltraps>

801063ff <vector104>:
.globl vector104
vector104:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $104
80106401:	6a 68                	push   $0x68
  jmp alltraps
80106403:	e9 52 f7 ff ff       	jmp    80105b5a <alltraps>

80106408 <vector105>:
.globl vector105
vector105:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $105
8010640a:	6a 69                	push   $0x69
  jmp alltraps
8010640c:	e9 49 f7 ff ff       	jmp    80105b5a <alltraps>

80106411 <vector106>:
.globl vector106
vector106:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $106
80106413:	6a 6a                	push   $0x6a
  jmp alltraps
80106415:	e9 40 f7 ff ff       	jmp    80105b5a <alltraps>

8010641a <vector107>:
.globl vector107
vector107:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $107
8010641c:	6a 6b                	push   $0x6b
  jmp alltraps
8010641e:	e9 37 f7 ff ff       	jmp    80105b5a <alltraps>

80106423 <vector108>:
.globl vector108
vector108:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $108
80106425:	6a 6c                	push   $0x6c
  jmp alltraps
80106427:	e9 2e f7 ff ff       	jmp    80105b5a <alltraps>

8010642c <vector109>:
.globl vector109
vector109:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $109
8010642e:	6a 6d                	push   $0x6d
  jmp alltraps
80106430:	e9 25 f7 ff ff       	jmp    80105b5a <alltraps>

80106435 <vector110>:
.globl vector110
vector110:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $110
80106437:	6a 6e                	push   $0x6e
  jmp alltraps
80106439:	e9 1c f7 ff ff       	jmp    80105b5a <alltraps>

8010643e <vector111>:
.globl vector111
vector111:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $111
80106440:	6a 6f                	push   $0x6f
  jmp alltraps
80106442:	e9 13 f7 ff ff       	jmp    80105b5a <alltraps>

80106447 <vector112>:
.globl vector112
vector112:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $112
80106449:	6a 70                	push   $0x70
  jmp alltraps
8010644b:	e9 0a f7 ff ff       	jmp    80105b5a <alltraps>

80106450 <vector113>:
.globl vector113
vector113:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $113
80106452:	6a 71                	push   $0x71
  jmp alltraps
80106454:	e9 01 f7 ff ff       	jmp    80105b5a <alltraps>

80106459 <vector114>:
.globl vector114
vector114:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $114
8010645b:	6a 72                	push   $0x72
  jmp alltraps
8010645d:	e9 f8 f6 ff ff       	jmp    80105b5a <alltraps>

80106462 <vector115>:
.globl vector115
vector115:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $115
80106464:	6a 73                	push   $0x73
  jmp alltraps
80106466:	e9 ef f6 ff ff       	jmp    80105b5a <alltraps>

8010646b <vector116>:
.globl vector116
vector116:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $116
8010646d:	6a 74                	push   $0x74
  jmp alltraps
8010646f:	e9 e6 f6 ff ff       	jmp    80105b5a <alltraps>

80106474 <vector117>:
.globl vector117
vector117:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $117
80106476:	6a 75                	push   $0x75
  jmp alltraps
80106478:	e9 dd f6 ff ff       	jmp    80105b5a <alltraps>

8010647d <vector118>:
.globl vector118
vector118:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $118
8010647f:	6a 76                	push   $0x76
  jmp alltraps
80106481:	e9 d4 f6 ff ff       	jmp    80105b5a <alltraps>

80106486 <vector119>:
.globl vector119
vector119:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $119
80106488:	6a 77                	push   $0x77
  jmp alltraps
8010648a:	e9 cb f6 ff ff       	jmp    80105b5a <alltraps>

8010648f <vector120>:
.globl vector120
vector120:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $120
80106491:	6a 78                	push   $0x78
  jmp alltraps
80106493:	e9 c2 f6 ff ff       	jmp    80105b5a <alltraps>

80106498 <vector121>:
.globl vector121
vector121:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $121
8010649a:	6a 79                	push   $0x79
  jmp alltraps
8010649c:	e9 b9 f6 ff ff       	jmp    80105b5a <alltraps>

801064a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $122
801064a3:	6a 7a                	push   $0x7a
  jmp alltraps
801064a5:	e9 b0 f6 ff ff       	jmp    80105b5a <alltraps>

801064aa <vector123>:
.globl vector123
vector123:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $123
801064ac:	6a 7b                	push   $0x7b
  jmp alltraps
801064ae:	e9 a7 f6 ff ff       	jmp    80105b5a <alltraps>

801064b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $124
801064b5:	6a 7c                	push   $0x7c
  jmp alltraps
801064b7:	e9 9e f6 ff ff       	jmp    80105b5a <alltraps>

801064bc <vector125>:
.globl vector125
vector125:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $125
801064be:	6a 7d                	push   $0x7d
  jmp alltraps
801064c0:	e9 95 f6 ff ff       	jmp    80105b5a <alltraps>

801064c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $126
801064c7:	6a 7e                	push   $0x7e
  jmp alltraps
801064c9:	e9 8c f6 ff ff       	jmp    80105b5a <alltraps>

801064ce <vector127>:
.globl vector127
vector127:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $127
801064d0:	6a 7f                	push   $0x7f
  jmp alltraps
801064d2:	e9 83 f6 ff ff       	jmp    80105b5a <alltraps>

801064d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $128
801064d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064de:	e9 77 f6 ff ff       	jmp    80105b5a <alltraps>

801064e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $129
801064e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064ea:	e9 6b f6 ff ff       	jmp    80105b5a <alltraps>

801064ef <vector130>:
.globl vector130
vector130:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $130
801064f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801064f6:	e9 5f f6 ff ff       	jmp    80105b5a <alltraps>

801064fb <vector131>:
.globl vector131
vector131:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $131
801064fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106502:	e9 53 f6 ff ff       	jmp    80105b5a <alltraps>

80106507 <vector132>:
.globl vector132
vector132:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $132
80106509:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010650e:	e9 47 f6 ff ff       	jmp    80105b5a <alltraps>

80106513 <vector133>:
.globl vector133
vector133:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $133
80106515:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010651a:	e9 3b f6 ff ff       	jmp    80105b5a <alltraps>

8010651f <vector134>:
.globl vector134
vector134:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $134
80106521:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106526:	e9 2f f6 ff ff       	jmp    80105b5a <alltraps>

8010652b <vector135>:
.globl vector135
vector135:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $135
8010652d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106532:	e9 23 f6 ff ff       	jmp    80105b5a <alltraps>

80106537 <vector136>:
.globl vector136
vector136:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $136
80106539:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010653e:	e9 17 f6 ff ff       	jmp    80105b5a <alltraps>

80106543 <vector137>:
.globl vector137
vector137:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $137
80106545:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010654a:	e9 0b f6 ff ff       	jmp    80105b5a <alltraps>

8010654f <vector138>:
.globl vector138
vector138:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $138
80106551:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106556:	e9 ff f5 ff ff       	jmp    80105b5a <alltraps>

8010655b <vector139>:
.globl vector139
vector139:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $139
8010655d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106562:	e9 f3 f5 ff ff       	jmp    80105b5a <alltraps>

80106567 <vector140>:
.globl vector140
vector140:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $140
80106569:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010656e:	e9 e7 f5 ff ff       	jmp    80105b5a <alltraps>

80106573 <vector141>:
.globl vector141
vector141:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $141
80106575:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010657a:	e9 db f5 ff ff       	jmp    80105b5a <alltraps>

8010657f <vector142>:
.globl vector142
vector142:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $142
80106581:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106586:	e9 cf f5 ff ff       	jmp    80105b5a <alltraps>

8010658b <vector143>:
.globl vector143
vector143:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $143
8010658d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106592:	e9 c3 f5 ff ff       	jmp    80105b5a <alltraps>

80106597 <vector144>:
.globl vector144
vector144:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $144
80106599:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010659e:	e9 b7 f5 ff ff       	jmp    80105b5a <alltraps>

801065a3 <vector145>:
.globl vector145
vector145:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $145
801065a5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801065aa:	e9 ab f5 ff ff       	jmp    80105b5a <alltraps>

801065af <vector146>:
.globl vector146
vector146:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $146
801065b1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801065b6:	e9 9f f5 ff ff       	jmp    80105b5a <alltraps>

801065bb <vector147>:
.globl vector147
vector147:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $147
801065bd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801065c2:	e9 93 f5 ff ff       	jmp    80105b5a <alltraps>

801065c7 <vector148>:
.globl vector148
vector148:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $148
801065c9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801065ce:	e9 87 f5 ff ff       	jmp    80105b5a <alltraps>

801065d3 <vector149>:
.globl vector149
vector149:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $149
801065d5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065da:	e9 7b f5 ff ff       	jmp    80105b5a <alltraps>

801065df <vector150>:
.globl vector150
vector150:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $150
801065e1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065e6:	e9 6f f5 ff ff       	jmp    80105b5a <alltraps>

801065eb <vector151>:
.globl vector151
vector151:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $151
801065ed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801065f2:	e9 63 f5 ff ff       	jmp    80105b5a <alltraps>

801065f7 <vector152>:
.globl vector152
vector152:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $152
801065f9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801065fe:	e9 57 f5 ff ff       	jmp    80105b5a <alltraps>

80106603 <vector153>:
.globl vector153
vector153:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $153
80106605:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010660a:	e9 4b f5 ff ff       	jmp    80105b5a <alltraps>

8010660f <vector154>:
.globl vector154
vector154:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $154
80106611:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106616:	e9 3f f5 ff ff       	jmp    80105b5a <alltraps>

8010661b <vector155>:
.globl vector155
vector155:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $155
8010661d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106622:	e9 33 f5 ff ff       	jmp    80105b5a <alltraps>

80106627 <vector156>:
.globl vector156
vector156:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $156
80106629:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010662e:	e9 27 f5 ff ff       	jmp    80105b5a <alltraps>

80106633 <vector157>:
.globl vector157
vector157:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $157
80106635:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010663a:	e9 1b f5 ff ff       	jmp    80105b5a <alltraps>

8010663f <vector158>:
.globl vector158
vector158:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $158
80106641:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106646:	e9 0f f5 ff ff       	jmp    80105b5a <alltraps>

8010664b <vector159>:
.globl vector159
vector159:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $159
8010664d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106652:	e9 03 f5 ff ff       	jmp    80105b5a <alltraps>

80106657 <vector160>:
.globl vector160
vector160:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $160
80106659:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010665e:	e9 f7 f4 ff ff       	jmp    80105b5a <alltraps>

80106663 <vector161>:
.globl vector161
vector161:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $161
80106665:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010666a:	e9 eb f4 ff ff       	jmp    80105b5a <alltraps>

8010666f <vector162>:
.globl vector162
vector162:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $162
80106671:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106676:	e9 df f4 ff ff       	jmp    80105b5a <alltraps>

8010667b <vector163>:
.globl vector163
vector163:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $163
8010667d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106682:	e9 d3 f4 ff ff       	jmp    80105b5a <alltraps>

80106687 <vector164>:
.globl vector164
vector164:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $164
80106689:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010668e:	e9 c7 f4 ff ff       	jmp    80105b5a <alltraps>

80106693 <vector165>:
.globl vector165
vector165:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $165
80106695:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010669a:	e9 bb f4 ff ff       	jmp    80105b5a <alltraps>

8010669f <vector166>:
.globl vector166
vector166:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $166
801066a1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801066a6:	e9 af f4 ff ff       	jmp    80105b5a <alltraps>

801066ab <vector167>:
.globl vector167
vector167:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $167
801066ad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801066b2:	e9 a3 f4 ff ff       	jmp    80105b5a <alltraps>

801066b7 <vector168>:
.globl vector168
vector168:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $168
801066b9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801066be:	e9 97 f4 ff ff       	jmp    80105b5a <alltraps>

801066c3 <vector169>:
.globl vector169
vector169:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $169
801066c5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801066ca:	e9 8b f4 ff ff       	jmp    80105b5a <alltraps>

801066cf <vector170>:
.globl vector170
vector170:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $170
801066d1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066d6:	e9 7f f4 ff ff       	jmp    80105b5a <alltraps>

801066db <vector171>:
.globl vector171
vector171:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $171
801066dd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066e2:	e9 73 f4 ff ff       	jmp    80105b5a <alltraps>

801066e7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $172
801066e9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066ee:	e9 67 f4 ff ff       	jmp    80105b5a <alltraps>

801066f3 <vector173>:
.globl vector173
vector173:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $173
801066f5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801066fa:	e9 5b f4 ff ff       	jmp    80105b5a <alltraps>

801066ff <vector174>:
.globl vector174
vector174:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $174
80106701:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106706:	e9 4f f4 ff ff       	jmp    80105b5a <alltraps>

8010670b <vector175>:
.globl vector175
vector175:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $175
8010670d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106712:	e9 43 f4 ff ff       	jmp    80105b5a <alltraps>

80106717 <vector176>:
.globl vector176
vector176:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $176
80106719:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010671e:	e9 37 f4 ff ff       	jmp    80105b5a <alltraps>

80106723 <vector177>:
.globl vector177
vector177:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $177
80106725:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010672a:	e9 2b f4 ff ff       	jmp    80105b5a <alltraps>

8010672f <vector178>:
.globl vector178
vector178:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $178
80106731:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106736:	e9 1f f4 ff ff       	jmp    80105b5a <alltraps>

8010673b <vector179>:
.globl vector179
vector179:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $179
8010673d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106742:	e9 13 f4 ff ff       	jmp    80105b5a <alltraps>

80106747 <vector180>:
.globl vector180
vector180:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $180
80106749:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010674e:	e9 07 f4 ff ff       	jmp    80105b5a <alltraps>

80106753 <vector181>:
.globl vector181
vector181:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $181
80106755:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010675a:	e9 fb f3 ff ff       	jmp    80105b5a <alltraps>

8010675f <vector182>:
.globl vector182
vector182:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $182
80106761:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106766:	e9 ef f3 ff ff       	jmp    80105b5a <alltraps>

8010676b <vector183>:
.globl vector183
vector183:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $183
8010676d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106772:	e9 e3 f3 ff ff       	jmp    80105b5a <alltraps>

80106777 <vector184>:
.globl vector184
vector184:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $184
80106779:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010677e:	e9 d7 f3 ff ff       	jmp    80105b5a <alltraps>

80106783 <vector185>:
.globl vector185
vector185:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $185
80106785:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010678a:	e9 cb f3 ff ff       	jmp    80105b5a <alltraps>

8010678f <vector186>:
.globl vector186
vector186:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $186
80106791:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106796:	e9 bf f3 ff ff       	jmp    80105b5a <alltraps>

8010679b <vector187>:
.globl vector187
vector187:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $187
8010679d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801067a2:	e9 b3 f3 ff ff       	jmp    80105b5a <alltraps>

801067a7 <vector188>:
.globl vector188
vector188:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $188
801067a9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801067ae:	e9 a7 f3 ff ff       	jmp    80105b5a <alltraps>

801067b3 <vector189>:
.globl vector189
vector189:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $189
801067b5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801067ba:	e9 9b f3 ff ff       	jmp    80105b5a <alltraps>

801067bf <vector190>:
.globl vector190
vector190:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $190
801067c1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801067c6:	e9 8f f3 ff ff       	jmp    80105b5a <alltraps>

801067cb <vector191>:
.globl vector191
vector191:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $191
801067cd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067d2:	e9 83 f3 ff ff       	jmp    80105b5a <alltraps>

801067d7 <vector192>:
.globl vector192
vector192:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $192
801067d9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067de:	e9 77 f3 ff ff       	jmp    80105b5a <alltraps>

801067e3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $193
801067e5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067ea:	e9 6b f3 ff ff       	jmp    80105b5a <alltraps>

801067ef <vector194>:
.globl vector194
vector194:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $194
801067f1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801067f6:	e9 5f f3 ff ff       	jmp    80105b5a <alltraps>

801067fb <vector195>:
.globl vector195
vector195:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $195
801067fd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106802:	e9 53 f3 ff ff       	jmp    80105b5a <alltraps>

80106807 <vector196>:
.globl vector196
vector196:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $196
80106809:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010680e:	e9 47 f3 ff ff       	jmp    80105b5a <alltraps>

80106813 <vector197>:
.globl vector197
vector197:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $197
80106815:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010681a:	e9 3b f3 ff ff       	jmp    80105b5a <alltraps>

8010681f <vector198>:
.globl vector198
vector198:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $198
80106821:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106826:	e9 2f f3 ff ff       	jmp    80105b5a <alltraps>

8010682b <vector199>:
.globl vector199
vector199:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $199
8010682d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106832:	e9 23 f3 ff ff       	jmp    80105b5a <alltraps>

80106837 <vector200>:
.globl vector200
vector200:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $200
80106839:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010683e:	e9 17 f3 ff ff       	jmp    80105b5a <alltraps>

80106843 <vector201>:
.globl vector201
vector201:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $201
80106845:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010684a:	e9 0b f3 ff ff       	jmp    80105b5a <alltraps>

8010684f <vector202>:
.globl vector202
vector202:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $202
80106851:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106856:	e9 ff f2 ff ff       	jmp    80105b5a <alltraps>

8010685b <vector203>:
.globl vector203
vector203:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $203
8010685d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106862:	e9 f3 f2 ff ff       	jmp    80105b5a <alltraps>

80106867 <vector204>:
.globl vector204
vector204:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $204
80106869:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010686e:	e9 e7 f2 ff ff       	jmp    80105b5a <alltraps>

80106873 <vector205>:
.globl vector205
vector205:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $205
80106875:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010687a:	e9 db f2 ff ff       	jmp    80105b5a <alltraps>

8010687f <vector206>:
.globl vector206
vector206:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $206
80106881:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106886:	e9 cf f2 ff ff       	jmp    80105b5a <alltraps>

8010688b <vector207>:
.globl vector207
vector207:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $207
8010688d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106892:	e9 c3 f2 ff ff       	jmp    80105b5a <alltraps>

80106897 <vector208>:
.globl vector208
vector208:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $208
80106899:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010689e:	e9 b7 f2 ff ff       	jmp    80105b5a <alltraps>

801068a3 <vector209>:
.globl vector209
vector209:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $209
801068a5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801068aa:	e9 ab f2 ff ff       	jmp    80105b5a <alltraps>

801068af <vector210>:
.globl vector210
vector210:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $210
801068b1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801068b6:	e9 9f f2 ff ff       	jmp    80105b5a <alltraps>

801068bb <vector211>:
.globl vector211
vector211:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $211
801068bd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801068c2:	e9 93 f2 ff ff       	jmp    80105b5a <alltraps>

801068c7 <vector212>:
.globl vector212
vector212:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $212
801068c9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801068ce:	e9 87 f2 ff ff       	jmp    80105b5a <alltraps>

801068d3 <vector213>:
.globl vector213
vector213:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $213
801068d5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068da:	e9 7b f2 ff ff       	jmp    80105b5a <alltraps>

801068df <vector214>:
.globl vector214
vector214:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $214
801068e1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068e6:	e9 6f f2 ff ff       	jmp    80105b5a <alltraps>

801068eb <vector215>:
.globl vector215
vector215:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $215
801068ed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801068f2:	e9 63 f2 ff ff       	jmp    80105b5a <alltraps>

801068f7 <vector216>:
.globl vector216
vector216:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $216
801068f9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801068fe:	e9 57 f2 ff ff       	jmp    80105b5a <alltraps>

80106903 <vector217>:
.globl vector217
vector217:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $217
80106905:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010690a:	e9 4b f2 ff ff       	jmp    80105b5a <alltraps>

8010690f <vector218>:
.globl vector218
vector218:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $218
80106911:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106916:	e9 3f f2 ff ff       	jmp    80105b5a <alltraps>

8010691b <vector219>:
.globl vector219
vector219:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $219
8010691d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106922:	e9 33 f2 ff ff       	jmp    80105b5a <alltraps>

80106927 <vector220>:
.globl vector220
vector220:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $220
80106929:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010692e:	e9 27 f2 ff ff       	jmp    80105b5a <alltraps>

80106933 <vector221>:
.globl vector221
vector221:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $221
80106935:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010693a:	e9 1b f2 ff ff       	jmp    80105b5a <alltraps>

8010693f <vector222>:
.globl vector222
vector222:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $222
80106941:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106946:	e9 0f f2 ff ff       	jmp    80105b5a <alltraps>

8010694b <vector223>:
.globl vector223
vector223:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $223
8010694d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106952:	e9 03 f2 ff ff       	jmp    80105b5a <alltraps>

80106957 <vector224>:
.globl vector224
vector224:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $224
80106959:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010695e:	e9 f7 f1 ff ff       	jmp    80105b5a <alltraps>

80106963 <vector225>:
.globl vector225
vector225:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $225
80106965:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010696a:	e9 eb f1 ff ff       	jmp    80105b5a <alltraps>

8010696f <vector226>:
.globl vector226
vector226:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $226
80106971:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106976:	e9 df f1 ff ff       	jmp    80105b5a <alltraps>

8010697b <vector227>:
.globl vector227
vector227:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $227
8010697d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106982:	e9 d3 f1 ff ff       	jmp    80105b5a <alltraps>

80106987 <vector228>:
.globl vector228
vector228:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $228
80106989:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010698e:	e9 c7 f1 ff ff       	jmp    80105b5a <alltraps>

80106993 <vector229>:
.globl vector229
vector229:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $229
80106995:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010699a:	e9 bb f1 ff ff       	jmp    80105b5a <alltraps>

8010699f <vector230>:
.globl vector230
vector230:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $230
801069a1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801069a6:	e9 af f1 ff ff       	jmp    80105b5a <alltraps>

801069ab <vector231>:
.globl vector231
vector231:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $231
801069ad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801069b2:	e9 a3 f1 ff ff       	jmp    80105b5a <alltraps>

801069b7 <vector232>:
.globl vector232
vector232:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $232
801069b9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801069be:	e9 97 f1 ff ff       	jmp    80105b5a <alltraps>

801069c3 <vector233>:
.globl vector233
vector233:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $233
801069c5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801069ca:	e9 8b f1 ff ff       	jmp    80105b5a <alltraps>

801069cf <vector234>:
.globl vector234
vector234:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $234
801069d1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069d6:	e9 7f f1 ff ff       	jmp    80105b5a <alltraps>

801069db <vector235>:
.globl vector235
vector235:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $235
801069dd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069e2:	e9 73 f1 ff ff       	jmp    80105b5a <alltraps>

801069e7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $236
801069e9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069ee:	e9 67 f1 ff ff       	jmp    80105b5a <alltraps>

801069f3 <vector237>:
.globl vector237
vector237:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $237
801069f5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801069fa:	e9 5b f1 ff ff       	jmp    80105b5a <alltraps>

801069ff <vector238>:
.globl vector238
vector238:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $238
80106a01:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a06:	e9 4f f1 ff ff       	jmp    80105b5a <alltraps>

80106a0b <vector239>:
.globl vector239
vector239:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $239
80106a0d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a12:	e9 43 f1 ff ff       	jmp    80105b5a <alltraps>

80106a17 <vector240>:
.globl vector240
vector240:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $240
80106a19:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a1e:	e9 37 f1 ff ff       	jmp    80105b5a <alltraps>

80106a23 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $241
80106a25:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a2a:	e9 2b f1 ff ff       	jmp    80105b5a <alltraps>

80106a2f <vector242>:
.globl vector242
vector242:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $242
80106a31:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a36:	e9 1f f1 ff ff       	jmp    80105b5a <alltraps>

80106a3b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $243
80106a3d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a42:	e9 13 f1 ff ff       	jmp    80105b5a <alltraps>

80106a47 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $244
80106a49:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a4e:	e9 07 f1 ff ff       	jmp    80105b5a <alltraps>

80106a53 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $245
80106a55:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a5a:	e9 fb f0 ff ff       	jmp    80105b5a <alltraps>

80106a5f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $246
80106a61:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a66:	e9 ef f0 ff ff       	jmp    80105b5a <alltraps>

80106a6b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $247
80106a6d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a72:	e9 e3 f0 ff ff       	jmp    80105b5a <alltraps>

80106a77 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $248
80106a79:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a7e:	e9 d7 f0 ff ff       	jmp    80105b5a <alltraps>

80106a83 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $249
80106a85:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a8a:	e9 cb f0 ff ff       	jmp    80105b5a <alltraps>

80106a8f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $250
80106a91:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a96:	e9 bf f0 ff ff       	jmp    80105b5a <alltraps>

80106a9b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $251
80106a9d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106aa2:	e9 b3 f0 ff ff       	jmp    80105b5a <alltraps>

80106aa7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $252
80106aa9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106aae:	e9 a7 f0 ff ff       	jmp    80105b5a <alltraps>

80106ab3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $253
80106ab5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106aba:	e9 9b f0 ff ff       	jmp    80105b5a <alltraps>

80106abf <vector254>:
.globl vector254
vector254:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $254
80106ac1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ac6:	e9 8f f0 ff ff       	jmp    80105b5a <alltraps>

80106acb <vector255>:
.globl vector255
vector255:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $255
80106acd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ad2:	e9 83 f0 ff ff       	jmp    80105b5a <alltraps>
80106ad7:	66 90                	xchg   %ax,%ax
80106ad9:	66 90                	xchg   %ax,%ax
80106adb:	66 90                	xchg   %ax,%ax
80106add:	66 90                	xchg   %ax,%ax
80106adf:	90                   	nop

80106ae0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	57                   	push   %edi
80106ae4:	56                   	push   %esi
80106ae5:	89 c6                	mov    %eax,%esi
80106ae7:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ae8:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106aee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106af4:	83 ec 1c             	sub    $0x1c,%esp
80106af7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106afa:	39 d3                	cmp    %edx,%ebx
80106afc:	73 79                	jae    80106b77 <deallocuvm.part.0+0x97>
80106afe:	89 d7                	mov    %edx,%edi
80106b00:	eb 12                	jmp    80106b14 <deallocuvm.part.0+0x34>
80106b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106b08:	83 c0 01             	add    $0x1,%eax
80106b0b:	c1 e0 16             	shl    $0x16,%eax
80106b0e:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106b10:	39 df                	cmp    %ebx,%edi
80106b12:	76 63                	jbe    80106b77 <deallocuvm.part.0+0x97>
  pde = &pgdir[PDX(va)];
80106b14:	89 d8                	mov    %ebx,%eax
80106b16:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106b19:	8b 14 86             	mov    (%esi,%eax,4),%edx
80106b1c:	f6 c2 01             	test   $0x1,%dl
80106b1f:	74 e7                	je     80106b08 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106b21:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b23:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106b29:	c1 e9 0a             	shr    $0xa,%ecx
80106b2c:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106b32:	8d 94 0a 00 00 00 80 	lea    -0x80000000(%edx,%ecx,1),%edx
    if(!pte)
80106b39:	85 d2                	test   %edx,%edx
80106b3b:	74 cb                	je     80106b08 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106b3d:	8b 02                	mov    (%edx),%eax
80106b3f:	a8 01                	test   $0x1,%al
80106b41:	74 2a                	je     80106b6d <deallocuvm.part.0+0x8d>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106b43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b48:	74 58                	je     80106ba2 <deallocuvm.part.0+0xc2>
        panic("kfree");
      char *v = P2V(pa);
      if (get_refc(pa) == 1)
80106b4a:	83 ec 0c             	sub    $0xc,%esp
80106b4d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80106b50:	50                   	push   %eax
80106b51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b54:	e8 c7 bd ff ff       	call   80102920 <get_refc>
80106b59:	83 c4 10             	add    $0x10,%esp
80106b5c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106b62:	83 f8 01             	cmp    $0x1,%eax
80106b65:	74 21                	je     80106b88 <deallocuvm.part.0+0xa8>
        kfree(v);
      *pte = 0;
80106b67:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
80106b6d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b73:	39 df                	cmp    %ebx,%edi
80106b75:	77 9d                	ja     80106b14 <deallocuvm.part.0+0x34>
    }
  }
  return newsz;
}
80106b77:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106b7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b7d:	5b                   	pop    %ebx
80106b7e:	5e                   	pop    %esi
80106b7f:	5f                   	pop    %edi
80106b80:	5d                   	pop    %ebp
80106b81:	c3                   	ret    
80106b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(v);
80106b88:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106b8b:	8d 81 00 00 00 80    	lea    -0x80000000(%ecx),%eax
80106b91:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        kfree(v);
80106b94:	50                   	push   %eax
80106b95:	e8 26 b9 ff ff       	call   801024c0 <kfree>
80106b9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106b9d:	83 c4 10             	add    $0x10,%esp
80106ba0:	eb c5                	jmp    80106b67 <deallocuvm.part.0+0x87>
        panic("kfree");
80106ba2:	83 ec 0c             	sub    $0xc,%esp
80106ba5:	68 c6 79 10 80       	push   $0x801079c6
80106baa:	e8 d1 97 ff ff       	call   80100380 <panic>
80106baf:	90                   	nop

80106bb0 <mappages>:
{
80106bb0:	55                   	push   %ebp
80106bb1:	89 e5                	mov    %esp,%ebp
80106bb3:	57                   	push   %edi
80106bb4:	56                   	push   %esi
80106bb5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106bb6:	89 d3                	mov    %edx,%ebx
80106bb8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106bbe:	83 ec 1c             	sub    $0x1c,%esp
80106bc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106bc4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106bc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bcd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106bd0:	8b 45 08             	mov    0x8(%ebp),%eax
80106bd3:	29 d8                	sub    %ebx,%eax
80106bd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106bd8:	eb 3d                	jmp    80106c17 <mappages+0x67>
80106bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106be0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106be2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106be7:	c1 ea 0a             	shr    $0xa,%edx
80106bea:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106bf0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106bf7:	85 c0                	test   %eax,%eax
80106bf9:	74 75                	je     80106c70 <mappages+0xc0>
    if(*pte & PTE_P)
80106bfb:	f6 00 01             	testb  $0x1,(%eax)
80106bfe:	0f 85 86 00 00 00    	jne    80106c8a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106c04:	0b 75 0c             	or     0xc(%ebp),%esi
80106c07:	83 ce 01             	or     $0x1,%esi
80106c0a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c0c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106c0f:	74 6f                	je     80106c80 <mappages+0xd0>
    a += PGSIZE;
80106c11:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106c17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106c1a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c1d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106c20:	89 d8                	mov    %ebx,%eax
80106c22:	c1 e8 16             	shr    $0x16,%eax
80106c25:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106c28:	8b 07                	mov    (%edi),%eax
80106c2a:	a8 01                	test   $0x1,%al
80106c2c:	75 b2                	jne    80106be0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c2e:	e8 1d bb ff ff       	call   80102750 <kalloc>
80106c33:	85 c0                	test   %eax,%eax
80106c35:	74 39                	je     80106c70 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106c37:	83 ec 04             	sub    $0x4,%esp
80106c3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106c3d:	68 00 10 00 00       	push   $0x1000
80106c42:	6a 00                	push   $0x0
80106c44:	50                   	push   %eax
80106c45:	e8 36 dd ff ff       	call   80104980 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c4a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106c4d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c50:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106c56:	83 c8 07             	or     $0x7,%eax
80106c59:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106c5b:	89 d8                	mov    %ebx,%eax
80106c5d:	c1 e8 0a             	shr    $0xa,%eax
80106c60:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c65:	01 d0                	add    %edx,%eax
80106c67:	eb 92                	jmp    80106bfb <mappages+0x4b>
80106c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c78:	5b                   	pop    %ebx
80106c79:	5e                   	pop    %esi
80106c7a:	5f                   	pop    %edi
80106c7b:	5d                   	pop    %ebp
80106c7c:	c3                   	ret    
80106c7d:	8d 76 00             	lea    0x0(%esi),%esi
80106c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c83:	31 c0                	xor    %eax,%eax
}
80106c85:	5b                   	pop    %ebx
80106c86:	5e                   	pop    %esi
80106c87:	5f                   	pop    %edi
80106c88:	5d                   	pop    %ebp
80106c89:	c3                   	ret    
      panic("remap");
80106c8a:	83 ec 0c             	sub    $0xc,%esp
80106c8d:	68 80 80 10 80       	push   $0x80108080
80106c92:	e8 e9 96 ff ff       	call   80100380 <panic>
80106c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c9e:	66 90                	xchg   %ax,%ax

80106ca0 <seginit>:
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ca6:	e8 c5 cf ff ff       	call   80103c70 <cpuid>
  pd[0] = size-1;
80106cab:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106cb0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106cb6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106cba:	c7 80 18 a8 14 80 ff 	movl   $0xffff,-0x7feb57e8(%eax)
80106cc1:	ff 00 00 
80106cc4:	c7 80 1c a8 14 80 00 	movl   $0xcf9a00,-0x7feb57e4(%eax)
80106ccb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106cce:	c7 80 20 a8 14 80 ff 	movl   $0xffff,-0x7feb57e0(%eax)
80106cd5:	ff 00 00 
80106cd8:	c7 80 24 a8 14 80 00 	movl   $0xcf9200,-0x7feb57dc(%eax)
80106cdf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ce2:	c7 80 28 a8 14 80 ff 	movl   $0xffff,-0x7feb57d8(%eax)
80106ce9:	ff 00 00 
80106cec:	c7 80 2c a8 14 80 00 	movl   $0xcffa00,-0x7feb57d4(%eax)
80106cf3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106cf6:	c7 80 30 a8 14 80 ff 	movl   $0xffff,-0x7feb57d0(%eax)
80106cfd:	ff 00 00 
80106d00:	c7 80 34 a8 14 80 00 	movl   $0xcff200,-0x7feb57cc(%eax)
80106d07:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106d0a:	05 10 a8 14 80       	add    $0x8014a810,%eax
  pd[1] = (uint)p;
80106d0f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106d13:	c1 e8 10             	shr    $0x10,%eax
80106d16:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106d1a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d1d:	0f 01 10             	lgdtl  (%eax)
}
80106d20:	c9                   	leave  
80106d21:	c3                   	ret    
80106d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d30 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d30:	a1 c4 d4 14 80       	mov    0x8014d4c4,%eax
80106d35:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d3a:	0f 22 d8             	mov    %eax,%cr3
}
80106d3d:	c3                   	ret    
80106d3e:	66 90                	xchg   %ax,%ax

80106d40 <switchuvm>:
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	57                   	push   %edi
80106d44:	56                   	push   %esi
80106d45:	53                   	push   %ebx
80106d46:	83 ec 1c             	sub    $0x1c,%esp
80106d49:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d4c:	85 f6                	test   %esi,%esi
80106d4e:	0f 84 cb 00 00 00    	je     80106e1f <switchuvm+0xdf>
  if(p->kstack == 0)
80106d54:	8b 46 08             	mov    0x8(%esi),%eax
80106d57:	85 c0                	test   %eax,%eax
80106d59:	0f 84 da 00 00 00    	je     80106e39 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d5f:	8b 46 04             	mov    0x4(%esi),%eax
80106d62:	85 c0                	test   %eax,%eax
80106d64:	0f 84 c2 00 00 00    	je     80106e2c <switchuvm+0xec>
  pushcli();
80106d6a:	e8 01 da ff ff       	call   80104770 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d6f:	e8 9c ce ff ff       	call   80103c10 <mycpu>
80106d74:	89 c3                	mov    %eax,%ebx
80106d76:	e8 95 ce ff ff       	call   80103c10 <mycpu>
80106d7b:	89 c7                	mov    %eax,%edi
80106d7d:	e8 8e ce ff ff       	call   80103c10 <mycpu>
80106d82:	83 c7 08             	add    $0x8,%edi
80106d85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d88:	e8 83 ce ff ff       	call   80103c10 <mycpu>
80106d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d90:	ba 67 00 00 00       	mov    $0x67,%edx
80106d95:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106d9c:	83 c0 08             	add    $0x8,%eax
80106d9f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106da6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106dab:	83 c1 08             	add    $0x8,%ecx
80106dae:	c1 e8 18             	shr    $0x18,%eax
80106db1:	c1 e9 10             	shr    $0x10,%ecx
80106db4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106dba:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106dc0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106dc5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dcc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106dd1:	e8 3a ce ff ff       	call   80103c10 <mycpu>
80106dd6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ddd:	e8 2e ce ff ff       	call   80103c10 <mycpu>
80106de2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106de6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106de9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106def:	e8 1c ce ff ff       	call   80103c10 <mycpu>
80106df4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106df7:	e8 14 ce ff ff       	call   80103c10 <mycpu>
80106dfc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106e00:	b8 28 00 00 00       	mov    $0x28,%eax
80106e05:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106e08:	8b 46 04             	mov    0x4(%esi),%eax
80106e0b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e10:	0f 22 d8             	mov    %eax,%cr3
}
80106e13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e16:	5b                   	pop    %ebx
80106e17:	5e                   	pop    %esi
80106e18:	5f                   	pop    %edi
80106e19:	5d                   	pop    %ebp
  popcli();
80106e1a:	e9 a1 d9 ff ff       	jmp    801047c0 <popcli>
    panic("switchuvm: no process");
80106e1f:	83 ec 0c             	sub    $0xc,%esp
80106e22:	68 86 80 10 80       	push   $0x80108086
80106e27:	e8 54 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106e2c:	83 ec 0c             	sub    $0xc,%esp
80106e2f:	68 b1 80 10 80       	push   $0x801080b1
80106e34:	e8 47 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106e39:	83 ec 0c             	sub    $0xc,%esp
80106e3c:	68 9c 80 10 80       	push   $0x8010809c
80106e41:	e8 3a 95 ff ff       	call   80100380 <panic>
80106e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e4d:	8d 76 00             	lea    0x0(%esi),%esi

80106e50 <inituvm>:
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	57                   	push   %edi
80106e54:	56                   	push   %esi
80106e55:	53                   	push   %ebx
80106e56:	83 ec 1c             	sub    $0x1c,%esp
80106e59:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e5c:	8b 75 10             	mov    0x10(%ebp),%esi
80106e5f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e65:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e6b:	77 4b                	ja     80106eb8 <inituvm+0x68>
  mem = kalloc();
80106e6d:	e8 de b8 ff ff       	call   80102750 <kalloc>
  memset(mem, 0, PGSIZE);
80106e72:	83 ec 04             	sub    $0x4,%esp
80106e75:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106e7a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e7c:	6a 00                	push   $0x0
80106e7e:	50                   	push   %eax
80106e7f:	e8 fc da ff ff       	call   80104980 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e84:	58                   	pop    %eax
80106e85:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e8b:	5a                   	pop    %edx
80106e8c:	6a 06                	push   $0x6
80106e8e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e93:	31 d2                	xor    %edx,%edx
80106e95:	50                   	push   %eax
80106e96:	89 f8                	mov    %edi,%eax
80106e98:	e8 13 fd ff ff       	call   80106bb0 <mappages>
  memmove(mem, init, sz);
80106e9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ea0:	89 75 10             	mov    %esi,0x10(%ebp)
80106ea3:	83 c4 10             	add    $0x10,%esp
80106ea6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106ea9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106eaf:	5b                   	pop    %ebx
80106eb0:	5e                   	pop    %esi
80106eb1:	5f                   	pop    %edi
80106eb2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106eb3:	e9 68 db ff ff       	jmp    80104a20 <memmove>
    panic("inituvm: more than a page");
80106eb8:	83 ec 0c             	sub    $0xc,%esp
80106ebb:	68 c5 80 10 80       	push   $0x801080c5
80106ec0:	e8 bb 94 ff ff       	call   80100380 <panic>
80106ec5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ed0 <loaduvm>:
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
80106ed5:	53                   	push   %ebx
80106ed6:	83 ec 1c             	sub    $0x1c,%esp
80106ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106edc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106edf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ee4:	0f 85 bb 00 00 00    	jne    80106fa5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106eea:	01 f0                	add    %esi,%eax
80106eec:	89 f3                	mov    %esi,%ebx
80106eee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ef1:	8b 45 14             	mov    0x14(%ebp),%eax
80106ef4:	01 f0                	add    %esi,%eax
80106ef6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106ef9:	85 f6                	test   %esi,%esi
80106efb:	0f 84 87 00 00 00    	je     80106f88 <loaduvm+0xb8>
80106f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106f08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106f0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106f0e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106f10:	89 c2                	mov    %eax,%edx
80106f12:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106f15:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106f18:	f6 c2 01             	test   $0x1,%dl
80106f1b:	75 13                	jne    80106f30 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106f1d:	83 ec 0c             	sub    $0xc,%esp
80106f20:	68 df 80 10 80       	push   $0x801080df
80106f25:	e8 56 94 ff ff       	call   80100380 <panic>
80106f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f30:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f33:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106f39:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f3e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f45:	85 c0                	test   %eax,%eax
80106f47:	74 d4                	je     80106f1d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106f49:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f4b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f4e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f58:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106f5e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f61:	29 d9                	sub    %ebx,%ecx
80106f63:	05 00 00 00 80       	add    $0x80000000,%eax
80106f68:	57                   	push   %edi
80106f69:	51                   	push   %ecx
80106f6a:	50                   	push   %eax
80106f6b:	ff 75 10             	push   0x10(%ebp)
80106f6e:	e8 1d ab ff ff       	call   80101a90 <readi>
80106f73:	83 c4 10             	add    $0x10,%esp
80106f76:	39 f8                	cmp    %edi,%eax
80106f78:	75 1e                	jne    80106f98 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106f7a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106f80:	89 f0                	mov    %esi,%eax
80106f82:	29 d8                	sub    %ebx,%eax
80106f84:	39 c6                	cmp    %eax,%esi
80106f86:	77 80                	ja     80106f08 <loaduvm+0x38>
}
80106f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f8b:	31 c0                	xor    %eax,%eax
}
80106f8d:	5b                   	pop    %ebx
80106f8e:	5e                   	pop    %esi
80106f8f:	5f                   	pop    %edi
80106f90:	5d                   	pop    %ebp
80106f91:	c3                   	ret    
80106f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f98:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fa0:	5b                   	pop    %ebx
80106fa1:	5e                   	pop    %esi
80106fa2:	5f                   	pop    %edi
80106fa3:	5d                   	pop    %ebp
80106fa4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106fa5:	83 ec 0c             	sub    $0xc,%esp
80106fa8:	68 ac 81 10 80       	push   $0x801081ac
80106fad:	e8 ce 93 ff ff       	call   80100380 <panic>
80106fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fc0 <allocuvm>:
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	53                   	push   %ebx
80106fc6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106fc9:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106fcc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106fcf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fd2:	85 c0                	test   %eax,%eax
80106fd4:	0f 88 b6 00 00 00    	js     80107090 <allocuvm+0xd0>
  if(newsz < oldsz)
80106fda:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106fe0:	0f 82 9a 00 00 00    	jb     80107080 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106fe6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106fec:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106ff2:	39 75 10             	cmp    %esi,0x10(%ebp)
80106ff5:	77 44                	ja     8010703b <allocuvm+0x7b>
80106ff7:	e9 87 00 00 00       	jmp    80107083 <allocuvm+0xc3>
80106ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107000:	83 ec 04             	sub    $0x4,%esp
80107003:	68 00 10 00 00       	push   $0x1000
80107008:	6a 00                	push   $0x0
8010700a:	50                   	push   %eax
8010700b:	e8 70 d9 ff ff       	call   80104980 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107010:	58                   	pop    %eax
80107011:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107017:	5a                   	pop    %edx
80107018:	6a 06                	push   $0x6
8010701a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010701f:	89 f2                	mov    %esi,%edx
80107021:	50                   	push   %eax
80107022:	89 f8                	mov    %edi,%eax
80107024:	e8 87 fb ff ff       	call   80106bb0 <mappages>
80107029:	83 c4 10             	add    $0x10,%esp
8010702c:	85 c0                	test   %eax,%eax
8010702e:	78 78                	js     801070a8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107030:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107036:	39 75 10             	cmp    %esi,0x10(%ebp)
80107039:	76 48                	jbe    80107083 <allocuvm+0xc3>
    mem = kalloc();
8010703b:	e8 10 b7 ff ff       	call   80102750 <kalloc>
80107040:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107042:	85 c0                	test   %eax,%eax
80107044:	75 ba                	jne    80107000 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107046:	83 ec 0c             	sub    $0xc,%esp
80107049:	68 fd 80 10 80       	push   $0x801080fd
8010704e:	e8 4d 96 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107053:	8b 45 0c             	mov    0xc(%ebp),%eax
80107056:	83 c4 10             	add    $0x10,%esp
80107059:	39 45 10             	cmp    %eax,0x10(%ebp)
8010705c:	74 32                	je     80107090 <allocuvm+0xd0>
8010705e:	8b 55 10             	mov    0x10(%ebp),%edx
80107061:	89 c1                	mov    %eax,%ecx
80107063:	89 f8                	mov    %edi,%eax
80107065:	e8 76 fa ff ff       	call   80106ae0 <deallocuvm.part.0>
      return 0;
8010706a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107074:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107077:	5b                   	pop    %ebx
80107078:	5e                   	pop    %esi
80107079:	5f                   	pop    %edi
8010707a:	5d                   	pop    %ebp
8010707b:	c3                   	ret    
8010707c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107083:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107089:	5b                   	pop    %ebx
8010708a:	5e                   	pop    %esi
8010708b:	5f                   	pop    %edi
8010708c:	5d                   	pop    %ebp
8010708d:	c3                   	ret    
8010708e:	66 90                	xchg   %ax,%ax
    return 0;
80107090:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107097:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010709a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010709d:	5b                   	pop    %ebx
8010709e:	5e                   	pop    %esi
8010709f:	5f                   	pop    %edi
801070a0:	5d                   	pop    %ebp
801070a1:	c3                   	ret    
801070a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801070a8:	83 ec 0c             	sub    $0xc,%esp
801070ab:	68 15 81 10 80       	push   $0x80108115
801070b0:	e8 eb 95 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801070b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801070b8:	83 c4 10             	add    $0x10,%esp
801070bb:	39 45 10             	cmp    %eax,0x10(%ebp)
801070be:	74 0c                	je     801070cc <allocuvm+0x10c>
801070c0:	8b 55 10             	mov    0x10(%ebp),%edx
801070c3:	89 c1                	mov    %eax,%ecx
801070c5:	89 f8                	mov    %edi,%eax
801070c7:	e8 14 fa ff ff       	call   80106ae0 <deallocuvm.part.0>
      kfree(mem);
801070cc:	83 ec 0c             	sub    $0xc,%esp
801070cf:	53                   	push   %ebx
801070d0:	e8 eb b3 ff ff       	call   801024c0 <kfree>
      return 0;
801070d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801070dc:	83 c4 10             	add    $0x10,%esp
}
801070df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070e5:	5b                   	pop    %ebx
801070e6:	5e                   	pop    %esi
801070e7:	5f                   	pop    %edi
801070e8:	5d                   	pop    %ebp
801070e9:	c3                   	ret    
801070ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070f0 <deallocuvm>:
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801070f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070fc:	39 d1                	cmp    %edx,%ecx
801070fe:	73 10                	jae    80107110 <deallocuvm+0x20>
}
80107100:	5d                   	pop    %ebp
80107101:	e9 da f9 ff ff       	jmp    80106ae0 <deallocuvm.part.0>
80107106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010710d:	8d 76 00             	lea    0x0(%esi),%esi
80107110:	89 d0                	mov    %edx,%eax
80107112:	5d                   	pop    %ebp
80107113:	c3                   	ret    
80107114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010711b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010711f:	90                   	nop

80107120 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
80107125:	53                   	push   %ebx
80107126:	83 ec 0c             	sub    $0xc,%esp
80107129:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010712c:	85 f6                	test   %esi,%esi
8010712e:	74 59                	je     80107189 <freevm+0x69>
  if(newsz >= oldsz)
80107130:	31 c9                	xor    %ecx,%ecx
80107132:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107137:	89 f0                	mov    %esi,%eax
80107139:	89 f3                	mov    %esi,%ebx
8010713b:	e8 a0 f9 ff ff       	call   80106ae0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107140:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107146:	eb 0f                	jmp    80107157 <freevm+0x37>
80107148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010714f:	90                   	nop
80107150:	83 c3 04             	add    $0x4,%ebx
80107153:	39 df                	cmp    %ebx,%edi
80107155:	74 23                	je     8010717a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107157:	8b 03                	mov    (%ebx),%eax
80107159:	a8 01                	test   $0x1,%al
8010715b:	74 f3                	je     80107150 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010715d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107162:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107165:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107168:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010716d:	50                   	push   %eax
8010716e:	e8 4d b3 ff ff       	call   801024c0 <kfree>
80107173:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107176:	39 df                	cmp    %ebx,%edi
80107178:	75 dd                	jne    80107157 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010717a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010717d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107180:	5b                   	pop    %ebx
80107181:	5e                   	pop    %esi
80107182:	5f                   	pop    %edi
80107183:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107184:	e9 37 b3 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107189:	83 ec 0c             	sub    $0xc,%esp
8010718c:	68 31 81 10 80       	push   $0x80108131
80107191:	e8 ea 91 ff ff       	call   80100380 <panic>
80107196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010719d:	8d 76 00             	lea    0x0(%esi),%esi

801071a0 <setupkvm>:
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	56                   	push   %esi
801071a4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801071a5:	e8 a6 b5 ff ff       	call   80102750 <kalloc>
801071aa:	89 c6                	mov    %eax,%esi
801071ac:	85 c0                	test   %eax,%eax
801071ae:	74 42                	je     801071f2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801071b0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071b3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801071b8:	68 00 10 00 00       	push   $0x1000
801071bd:	6a 00                	push   $0x0
801071bf:	50                   	push   %eax
801071c0:	e8 bb d7 ff ff       	call   80104980 <memset>
801071c5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801071c8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801071cb:	83 ec 08             	sub    $0x8,%esp
801071ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801071d1:	ff 73 0c             	push   0xc(%ebx)
801071d4:	8b 13                	mov    (%ebx),%edx
801071d6:	50                   	push   %eax
801071d7:	29 c1                	sub    %eax,%ecx
801071d9:	89 f0                	mov    %esi,%eax
801071db:	e8 d0 f9 ff ff       	call   80106bb0 <mappages>
801071e0:	83 c4 10             	add    $0x10,%esp
801071e3:	85 c0                	test   %eax,%eax
801071e5:	78 19                	js     80107200 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071e7:	83 c3 10             	add    $0x10,%ebx
801071ea:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801071f0:	75 d6                	jne    801071c8 <setupkvm+0x28>
}
801071f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071f5:	89 f0                	mov    %esi,%eax
801071f7:	5b                   	pop    %ebx
801071f8:	5e                   	pop    %esi
801071f9:	5d                   	pop    %ebp
801071fa:	c3                   	ret    
801071fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071ff:	90                   	nop
      freevm(pgdir);
80107200:	83 ec 0c             	sub    $0xc,%esp
80107203:	56                   	push   %esi
      return 0;
80107204:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107206:	e8 15 ff ff ff       	call   80107120 <freevm>
      return 0;
8010720b:	83 c4 10             	add    $0x10,%esp
}
8010720e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107211:	89 f0                	mov    %esi,%eax
80107213:	5b                   	pop    %ebx
80107214:	5e                   	pop    %esi
80107215:	5d                   	pop    %ebp
80107216:	c3                   	ret    
80107217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010721e:	66 90                	xchg   %ax,%ax

80107220 <kvmalloc>:
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107226:	e8 75 ff ff ff       	call   801071a0 <setupkvm>
8010722b:	a3 c4 d4 14 80       	mov    %eax,0x8014d4c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107230:	05 00 00 00 80       	add    $0x80000000,%eax
80107235:	0f 22 d8             	mov    %eax,%cr3
}
80107238:	c9                   	leave  
80107239:	c3                   	ret    
8010723a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107240 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	83 ec 08             	sub    $0x8,%esp
80107246:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107249:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010724c:	89 c1                	mov    %eax,%ecx
8010724e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107251:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107254:	f6 c2 01             	test   $0x1,%dl
80107257:	75 17                	jne    80107270 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107259:	83 ec 0c             	sub    $0xc,%esp
8010725c:	68 42 81 10 80       	push   $0x80108142
80107261:	e8 1a 91 ff ff       	call   80100380 <panic>
80107266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107270:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107273:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107279:	25 fc 0f 00 00       	and    $0xffc,%eax
8010727e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107285:	85 c0                	test   %eax,%eax
80107287:	74 d0                	je     80107259 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107289:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010728c:	c9                   	leave  
8010728d:	c3                   	ret    
8010728e:	66 90                	xchg   %ax,%ax

80107290 <copyuvm>:

// Given a parent process's page table,
// create a copy of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	57                   	push   %edi
80107294:	56                   	push   %esi
80107295:	53                   	push   %ebx
80107296:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
80107299:	e8 02 ff ff ff       	call   801071a0 <setupkvm>
8010729e:	89 c6                	mov    %eax,%esi
801072a0:	85 c0                	test   %eax,%eax
801072a2:	0f 84 a8 00 00 00    	je     80107350 <copyuvm+0xc0>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801072a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801072ab:	85 c0                	test   %eax,%eax
801072ad:	0f 84 9d 00 00 00    	je     80107350 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    *pte = *pte & ~PTE_W;
    lcr3(V2P(pgdir));
801072b3:	8b 45 08             	mov    0x8(%ebp),%eax
  for(i = 0; i < sz; i += PGSIZE){
801072b6:	31 ff                	xor    %edi,%edi
    lcr3(V2P(pgdir));
801072b8:	05 00 00 00 80       	add    $0x80000000,%eax
801072bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(*pde & PTE_P){
801072c0:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801072c3:	89 f8                	mov    %edi,%eax
801072c5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801072c8:	8b 04 82             	mov    (%edx,%eax,4),%eax
801072cb:	a8 01                	test   $0x1,%al
801072cd:	75 11                	jne    801072e0 <copyuvm+0x50>
      panic("copyuvm: pte should exist");
801072cf:	83 ec 0c             	sub    $0xc,%esp
801072d2:	68 4c 81 10 80       	push   $0x8010814c
801072d7:	e8 a4 90 ff ff       	call   80100380 <panic>
801072dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801072e0:	89 f9                	mov    %edi,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801072e7:	c1 e9 0a             	shr    $0xa,%ecx
801072ea:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801072f0:	8d 8c 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%ecx
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801072f7:	85 c9                	test   %ecx,%ecx
801072f9:	74 d4                	je     801072cf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801072fb:	8b 01                	mov    (%ecx),%eax
801072fd:	a8 01                	test   $0x1,%al
801072ff:	74 7d                	je     8010737e <copyuvm+0xee>
    *pte = *pte & ~PTE_W;
80107301:	89 c3                	mov    %eax,%ebx
80107303:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107306:	83 e3 fd             	and    $0xfffffffd,%ebx
80107309:	89 19                	mov    %ebx,(%ecx)
8010730b:	0f 22 da             	mov    %edx,%cr3
    pa = PTE_ADDR(*pte);
8010730e:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107310:	83 ec 08             	sub    $0x8,%esp
    flags = PTE_FLAGS(*pte);
80107313:	25 fd 0f 00 00       	and    $0xffd,%eax
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107318:	b9 00 10 00 00       	mov    $0x1000,%ecx
    pa = PTE_ADDR(*pte);
8010731d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107323:	50                   	push   %eax
80107324:	89 fa                	mov    %edi,%edx
80107326:	89 f0                	mov    %esi,%eax
80107328:	53                   	push   %ebx
80107329:	e8 82 f8 ff ff       	call   80106bb0 <mappages>
8010732e:	83 c4 10             	add    $0x10,%esp
80107331:	85 c0                	test   %eax,%eax
80107333:	78 2b                	js     80107360 <copyuvm+0xd0>
      goto bad;
    incr_refc(pa);
80107335:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < sz; i += PGSIZE){
80107338:	81 c7 00 10 00 00    	add    $0x1000,%edi
    incr_refc(pa);
8010733e:	53                   	push   %ebx
8010733f:	e8 9c b4 ff ff       	call   801027e0 <incr_refc>
  for(i = 0; i < sz; i += PGSIZE){
80107344:	83 c4 10             	add    $0x10,%esp
80107347:	39 7d 0c             	cmp    %edi,0xc(%ebp)
8010734a:	0f 87 70 ff ff ff    	ja     801072c0 <copyuvm+0x30>

bad:
  freevm(d);
  lcr3(V2P(pgdir));
  return 0;
}
80107350:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107353:	89 f0                	mov    %esi,%eax
80107355:	5b                   	pop    %ebx
80107356:	5e                   	pop    %esi
80107357:	5f                   	pop    %edi
80107358:	5d                   	pop    %ebp
80107359:	c3                   	ret    
8010735a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(d);
80107360:	83 ec 0c             	sub    $0xc,%esp
80107363:	56                   	push   %esi
80107364:	e8 b7 fd ff ff       	call   80107120 <freevm>
80107369:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010736c:	0f 22 d8             	mov    %eax,%cr3
  return 0;
8010736f:	31 f6                	xor    %esi,%esi
80107371:	83 c4 10             	add    $0x10,%esp
}
80107374:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107377:	5b                   	pop    %ebx
80107378:	89 f0                	mov    %esi,%eax
8010737a:	5e                   	pop    %esi
8010737b:	5f                   	pop    %edi
8010737c:	5d                   	pop    %ebp
8010737d:	c3                   	ret    
      panic("copyuvm: page not present");
8010737e:	83 ec 0c             	sub    $0xc,%esp
80107381:	68 66 81 10 80       	push   $0x80108166
80107386:	e8 f5 8f ff ff       	call   80100380 <panic>
8010738b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010738f:	90                   	nop

80107390 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107396:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107399:	89 c1                	mov    %eax,%ecx
8010739b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010739e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801073a1:	f6 c2 01             	test   $0x1,%dl
801073a4:	0f 84 92 03 00 00    	je     8010773c <uva2ka.cold>
  return &pgtab[PTX(va)];
801073aa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073ad:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801073b3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801073b4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801073b9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801073c0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801073c7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073ca:	05 00 00 00 80       	add    $0x80000000,%eax
801073cf:	83 fa 05             	cmp    $0x5,%edx
801073d2:	ba 00 00 00 00       	mov    $0x0,%edx
801073d7:	0f 45 c2             	cmovne %edx,%eax
}
801073da:	c3                   	ret    
801073db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073df:	90                   	nop

801073e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	57                   	push   %edi
801073e4:	56                   	push   %esi
801073e5:	53                   	push   %ebx
801073e6:	83 ec 0c             	sub    $0xc,%esp
801073e9:	8b 75 14             	mov    0x14(%ebp),%esi
801073ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801073ef:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801073f2:	85 f6                	test   %esi,%esi
801073f4:	75 51                	jne    80107447 <copyout+0x67>
801073f6:	e9 a5 00 00 00       	jmp    801074a0 <copyout+0xc0>
801073fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073ff:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107400:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107406:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010740c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107412:	74 75                	je     80107489 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107414:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107416:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107419:	29 c3                	sub    %eax,%ebx
8010741b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107421:	39 f3                	cmp    %esi,%ebx
80107423:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107426:	29 f8                	sub    %edi,%eax
80107428:	83 ec 04             	sub    $0x4,%esp
8010742b:	01 c1                	add    %eax,%ecx
8010742d:	53                   	push   %ebx
8010742e:	52                   	push   %edx
8010742f:	51                   	push   %ecx
80107430:	e8 eb d5 ff ff       	call   80104a20 <memmove>
    len -= n;
    buf += n;
80107435:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107438:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010743e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107441:	01 da                	add    %ebx,%edx
  while(len > 0){
80107443:	29 de                	sub    %ebx,%esi
80107445:	74 59                	je     801074a0 <copyout+0xc0>
  if(*pde & PTE_P){
80107447:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010744a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010744c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010744e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107451:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107457:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010745a:	f6 c1 01             	test   $0x1,%cl
8010745d:	0f 84 e0 02 00 00    	je     80107743 <copyout.cold>
  return &pgtab[PTX(va)];
80107463:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107465:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010746b:	c1 eb 0c             	shr    $0xc,%ebx
8010746e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107474:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010747b:	89 d9                	mov    %ebx,%ecx
8010747d:	83 e1 05             	and    $0x5,%ecx
80107480:	83 f9 05             	cmp    $0x5,%ecx
80107483:	0f 84 77 ff ff ff    	je     80107400 <copyout+0x20>
  }
  return 0;
}
80107489:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010748c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107491:	5b                   	pop    %ebx
80107492:	5e                   	pop    %esi
80107493:	5f                   	pop    %edi
80107494:	5d                   	pop    %ebp
80107495:	c3                   	ret    
80107496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010749d:	8d 76 00             	lea    0x0(%esi),%esi
801074a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074a3:	31 c0                	xor    %eax,%eax
}
801074a5:	5b                   	pop    %ebx
801074a6:	5e                   	pop    %esi
801074a7:	5f                   	pop    %edi
801074a8:	5d                   	pop    %ebp
801074a9:	c3                   	ret    
801074aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074b0 <CoW_handler>:

void
CoW_handler(void)
{
801074b0:	55                   	push   %ebp
801074b1:	89 e5                	mov    %esp,%ebp
801074b3:	57                   	push   %edi
801074b4:	56                   	push   %esi
801074b5:	53                   	push   %ebx
801074b6:	83 ec 1c             	sub    $0x1c,%esp
  pte_t *pte;
  uint pa, addr, flags;
  char *mem;
  int refc;
  struct proc *curproc = myproc();
801074b9:	e8 d2 c7 ff ff       	call   80103c90 <myproc>
801074be:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
801074c0:	0f 20 d0             	mov    %cr2,%eax
  // cprintf("cow handler: %d(%s)\n", curproc->pid, curproc->name);
  
  addr = PGROUNDDOWN(rcr2());
801074c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax

  if(addr < 0 || addr > KERNBASE){
801074c8:	3d 00 00 00 80       	cmp    $0x80000000,%eax
801074cd:	0f 87 c5 00 00 00    	ja     80107598 <CoW_handler+0xe8>
  if(*pde & PTE_P){
801074d3:	8b 53 04             	mov    0x4(%ebx),%edx
  pde = &pgdir[PDX(va)];
801074d6:	89 c1                	mov    %eax,%ecx
801074d8:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801074db:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801074de:	f6 c2 01             	test   $0x1,%dl
801074e1:	0f 84 f1 00 00 00    	je     801075d8 <CoW_handler+0x128>
  return &pgtab[PTX(va)];
801074e7:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074ea:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801074f0:	25 fc 0f 00 00       	and    $0xffc,%eax
801074f5:	8d bc 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%edi
    cprintf("CoW_handler: wrong virtual address\n");
    goto bad;
  }
  if((pte = walkpgdir(curproc->pgdir, (void *)addr, 0)) == 0){
801074fc:	85 ff                	test   %edi,%edi
801074fe:	0f 84 d4 00 00 00    	je     801075d8 <CoW_handler+0x128>
    cprintf("CoW_handler: pte should exist\n");
    goto bad;
  }
  if(!(*pte & PTE_P)){
80107504:	8b 37                	mov    (%edi),%esi
80107506:	f7 c6 01 00 00 00    	test   $0x1,%esi
8010750c:	0f 84 ae 00 00 00    	je     801075c0 <CoW_handler+0x110>
    cprintf("CoW_handler: pte not present\n");
    goto bad;
  }
  pa = PTE_ADDR(*pte);
80107512:	89 f0                	mov    %esi,%eax
  flags = PTE_FLAGS(*pte);
  refc = get_refc(pa);
80107514:	83 ec 0c             	sub    $0xc,%esp
  pa = PTE_ADDR(*pte);
80107517:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  refc = get_refc(pa);
8010751c:	50                   	push   %eax
  pa = PTE_ADDR(*pte);
8010751d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  refc = get_refc(pa);
80107520:	e8 fb b3 ff ff       	call   80102920 <get_refc>

  // If there is no process referencing this page,
  // change the permission to writable.
  if (refc == 1)
80107525:	83 c4 10             	add    $0x10,%esp
80107528:	83 f8 01             	cmp    $0x1,%eax
8010752b:	0f 84 bf 00 00 00    	je     801075f0 <CoW_handler+0x140>
    *pte = *pte | PTE_W;
  else if (refc > 1){           // Start copying the page.
80107531:	0f 8e be 00 00 00    	jle    801075f5 <CoW_handler+0x145>
    if((mem = kalloc()) == 0)
80107537:	e8 14 b2 ff ff       	call   80102750 <kalloc>
8010753c:	89 c2                	mov    %eax,%edx
8010753e:	85 c0                	test   %eax,%eax
80107540:	74 66                	je     801075a8 <CoW_handler+0xf8>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107542:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107545:	83 ec 04             	sub    $0x4,%esp
80107548:	89 55 e0             	mov    %edx,-0x20(%ebp)
  flags = PTE_FLAGS(*pte);
8010754b:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107551:	68 00 10 00 00       	push   $0x1000
80107556:	05 00 00 00 80       	add    $0x80000000,%eax
8010755b:	50                   	push   %eax
8010755c:	52                   	push   %edx
8010755d:	e8 be d4 ff ff       	call   80104a20 <memmove>
    *pte = V2P(mem) | flags | PTE_W;
80107562:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107565:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010756b:	09 f2                	or     %esi,%edx
8010756d:	83 ca 02             	or     $0x2,%edx
80107570:	89 17                	mov    %edx,(%edi)
    decr_refc(pa);
80107572:	58                   	pop    %eax
80107573:	ff 75 e4             	push   -0x1c(%ebp)
80107576:	e8 05 b3 ff ff       	call   80102880 <decr_refc>
8010757b:	83 c4 10             	add    $0x10,%esp
  }
  else
    panic("CoW_handler");

  lcr3(V2P(curproc->pgdir));
8010757e:	8b 43 04             	mov    0x4(%ebx),%eax
80107581:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107586:	0f 22 d8             	mov    %eax,%cr3
  return;

  bad:
    curproc->killed = 1;
}
80107589:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010758c:	5b                   	pop    %ebx
8010758d:	5e                   	pop    %esi
8010758e:	5f                   	pop    %edi
8010758f:	5d                   	pop    %ebp
80107590:	c3                   	ret    
80107591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("CoW_handler: wrong virtual address\n");
80107598:	83 ec 0c             	sub    $0xc,%esp
8010759b:	68 d0 81 10 80       	push   $0x801081d0
801075a0:	e8 fb 90 ff ff       	call   801006a0 <cprintf>
    goto bad;
801075a5:	83 c4 10             	add    $0x10,%esp
    curproc->killed = 1;
801075a8:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
}
801075af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075b2:	5b                   	pop    %ebx
801075b3:	5e                   	pop    %esi
801075b4:	5f                   	pop    %edi
801075b5:	5d                   	pop    %ebp
801075b6:	c3                   	ret    
801075b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075be:	66 90                	xchg   %ax,%ax
    cprintf("CoW_handler: pte not present\n");
801075c0:	83 ec 0c             	sub    $0xc,%esp
801075c3:	68 80 81 10 80       	push   $0x80108180
801075c8:	e8 d3 90 ff ff       	call   801006a0 <cprintf>
    goto bad;
801075cd:	83 c4 10             	add    $0x10,%esp
801075d0:	eb d6                	jmp    801075a8 <CoW_handler+0xf8>
801075d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("CoW_handler: pte should exist\n");
801075d8:	83 ec 0c             	sub    $0xc,%esp
801075db:	68 f4 81 10 80       	push   $0x801081f4
801075e0:	e8 bb 90 ff ff       	call   801006a0 <cprintf>
    goto bad;
801075e5:	83 c4 10             	add    $0x10,%esp
801075e8:	eb be                	jmp    801075a8 <CoW_handler+0xf8>
801075ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *pte = *pte | PTE_W;
801075f0:	83 0f 02             	orl    $0x2,(%edi)
801075f3:	eb 89                	jmp    8010757e <CoW_handler+0xce>
    panic("CoW_handler");
801075f5:	83 ec 0c             	sub    $0xc,%esp
801075f8:	68 9e 81 10 80       	push   $0x8010819e
801075fd:	e8 7e 8d ff ff       	call   80100380 <panic>
80107602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107610 <sys_countvp>:

int 
sys_countvp(void)
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	83 ec 08             	sub    $0x8,%esp
  return PGROUNDUP(myproc()->sz) / PGSIZE;
80107616:	e8 75 c6 ff ff       	call   80103c90 <myproc>
8010761b:	8b 00                	mov    (%eax),%eax
}
8010761d:	c9                   	leave  
  return PGROUNDUP(myproc()->sz) / PGSIZE;
8010761e:	05 ff 0f 00 00       	add    $0xfff,%eax
80107623:	c1 e8 0c             	shr    $0xc,%eax
}
80107626:	c3                   	ret    
80107627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010762e:	66 90                	xchg   %ax,%ax

80107630 <sys_countpp>:

int
sys_countpp(void)
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	57                   	push   %edi
80107634:	56                   	push   %esi
80107635:	53                   	push   %ebx
80107636:	83 ec 0c             	sub    $0xc,%esp
  int ppc;
  uint i, sz;
  pde_t *pgdir;
  pte_t *pte;
  struct proc *curproc = myproc();
80107639:	e8 52 c6 ff ff       	call   80103c90 <myproc>

  sz = curproc->sz;
8010763e:	8b 18                	mov    (%eax),%ebx
  pgdir = curproc->pgdir;
80107640:	8b 70 04             	mov    0x4(%eax),%esi
  ppc = 0;

  for (i = 0; i < sz; i += PGSIZE){
80107643:	85 db                	test   %ebx,%ebx
80107645:	74 59                	je     801076a0 <sys_countpp+0x70>
80107647:	31 c0                	xor    %eax,%eax
  ppc = 0;
80107649:	31 c9                	xor    %ecx,%ecx
8010764b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010764f:	90                   	nop
  pde = &pgdir[PDX(va)];
80107650:	89 c2                	mov    %eax,%edx
80107652:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107655:	8b 14 96             	mov    (%esi,%edx,4),%edx
80107658:	f6 c2 01             	test   $0x1,%dl
8010765b:	74 27                	je     80107684 <sys_countpp+0x54>
  return &pgtab[PTX(va)];
8010765d:	89 c7                	mov    %eax,%edi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010765f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107665:	c1 ef 0a             	shr    $0xa,%edi
80107668:	81 e7 fc 0f 00 00    	and    $0xffc,%edi
8010766e:	8d 94 3a 00 00 00 80 	lea    -0x80000000(%edx,%edi,1),%edx
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107675:	85 d2                	test   %edx,%edx
80107677:	74 0b                	je     80107684 <sys_countpp+0x54>
      continue;
    if(!(*pte & PTE_P))
80107679:	8b 12                	mov    (%edx),%edx
8010767b:	83 e2 01             	and    $0x1,%edx
      continue;
    ppc ++;
8010767e:	83 fa 01             	cmp    $0x1,%edx
80107681:	83 d9 ff             	sbb    $0xffffffff,%ecx
  for (i = 0; i < sz; i += PGSIZE){
80107684:	05 00 10 00 00       	add    $0x1000,%eax
80107689:	39 c3                	cmp    %eax,%ebx
8010768b:	77 c3                	ja     80107650 <sys_countpp+0x20>
  }
  return ppc;
}
8010768d:	83 c4 0c             	add    $0xc,%esp
80107690:	89 c8                	mov    %ecx,%eax
80107692:	5b                   	pop    %ebx
80107693:	5e                   	pop    %esi
80107694:	5f                   	pop    %edi
80107695:	5d                   	pop    %ebp
80107696:	c3                   	ret    
80107697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010769e:	66 90                	xchg   %ax,%ax
801076a0:	83 c4 0c             	add    $0xc,%esp
  ppc = 0;
801076a3:	31 c9                	xor    %ecx,%ecx
}
801076a5:	5b                   	pop    %ebx
801076a6:	89 c8                	mov    %ecx,%eax
801076a8:	5e                   	pop    %esi
801076a9:	5f                   	pop    %edi
801076aa:	5d                   	pop    %ebp
801076ab:	c3                   	ret    
801076ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801076b0 <sys_countptp>:

int
sys_countptp(void)
{
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	57                   	push   %edi
801076b4:	56                   	push   %esi
801076b5:	53                   	push   %ebx
801076b6:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pgdir;
  pte_t *pte;
  uint a, i;
  int ptpc;
  struct proc *curproc = myproc();
801076b9:	e8 d2 c5 ff ff       	call   80103c90 <myproc>

  pgdir = curproc->pgdir;
  ptpc = 1; // pgdir
801076be:	b9 01 00 00 00       	mov    $0x1,%ecx

  for (a = 0; a < KERNBASE; a += PGSIZE){
801076c3:	31 d2                	xor    %edx,%edx
  pgdir = curproc->pgdir;
801076c5:	8b 40 04             	mov    0x4(%eax),%eax
  for (a = 0; a < KERNBASE; a += PGSIZE){
801076c8:	eb 10                	jmp    801076da <sys_countptp+0x2a>
801076ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801076d0:	8d 56 01             	lea    0x1(%esi),%edx
801076d3:	c1 e2 16             	shl    $0x16,%edx
  for (a = 0; a < KERNBASE; a += PGSIZE){
801076d6:	85 d2                	test   %edx,%edx
801076d8:	78 3e                	js     80107718 <sys_countptp+0x68>
  pde = &pgdir[PDX(va)];
801076da:	89 d6                	mov    %edx,%esi
801076dc:	c1 ee 16             	shr    $0x16,%esi
  if(*pde & PTE_P){
801076df:	8b 1c b0             	mov    (%eax,%esi,4),%ebx
801076e2:	f6 c3 01             	test   $0x1,%bl
801076e5:	74 e9                	je     801076d0 <sys_countptp+0x20>
  return &pgtab[PTX(va)];
801076e7:	89 d7                	mov    %edx,%edi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076e9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  return &pgtab[PTX(va)];
801076ef:	c1 ef 0a             	shr    $0xa,%edi
801076f2:	81 e7 fc 0f 00 00    	and    $0xffc,%edi
801076f8:	8d 9c 3b 00 00 00 80 	lea    -0x80000000(%ebx,%edi,1),%ebx
    if(!pte)
801076ff:	85 db                	test   %ebx,%ebx
80107701:	74 cd                	je     801076d0 <sys_countptp+0x20>
    else if((*pte & PTE_P) != 0){
80107703:	8b 1b                	mov    (%ebx),%ebx
  for (a = 0; a < KERNBASE; a += PGSIZE){
80107705:	81 c2 00 10 00 00    	add    $0x1000,%edx
    else if((*pte & PTE_P) != 0){
8010770b:	83 e3 01             	and    $0x1,%ebx
      ptpc++;
8010770e:	83 fb 01             	cmp    $0x1,%ebx
80107711:	83 d9 ff             	sbb    $0xffffffff,%ecx
  for (a = 0; a < KERNBASE; a += PGSIZE){
80107714:	85 d2                	test   %edx,%edx
80107716:	79 c2                	jns    801076da <sys_countptp+0x2a>
80107718:	8d 98 00 10 00 00    	lea    0x1000(%eax),%ebx
8010771e:	66 90                	xchg   %ax,%ax
    }
  }

  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P)
80107720:	8b 10                	mov    (%eax),%edx
80107722:	83 e2 01             	and    $0x1,%edx
      ptpc++;
80107725:	83 fa 01             	cmp    $0x1,%edx
80107728:	83 d9 ff             	sbb    $0xffffffff,%ecx
  for(i = 0; i < NPDENTRIES; i++){
8010772b:	83 c0 04             	add    $0x4,%eax
8010772e:	39 c3                	cmp    %eax,%ebx
80107730:	75 ee                	jne    80107720 <sys_countptp+0x70>
  }

  return ptpc;
}
80107732:	83 c4 0c             	add    $0xc,%esp
80107735:	89 c8                	mov    %ecx,%eax
80107737:	5b                   	pop    %ebx
80107738:	5e                   	pop    %esi
80107739:	5f                   	pop    %edi
8010773a:	5d                   	pop    %ebp
8010773b:	c3                   	ret    

8010773c <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010773c:	a1 00 00 00 00       	mov    0x0,%eax
80107741:	0f 0b                	ud2    

80107743 <copyout.cold>:
80107743:	a1 00 00 00 00       	mov    0x0,%eax
80107748:	0f 0b                	ud2    

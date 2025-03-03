
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
80100028:	bc 70 6e 11 80       	mov    $0x80116e70,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
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
8010004c:	68 a0 80 10 80       	push   $0x801080a0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 05 50 00 00       	call   80105060 <initlock>
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
80100092:	68 a7 80 10 80       	push   $0x801080a7
80100097:	50                   	push   %eax
80100098:	e8 93 4e 00 00       	call   80104f30 <initsleeplock>
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
801000e4:	e8 47 51 00 00       	call   80105230 <acquire>
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
80100162:	e8 69 50 00 00       	call   801051d0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 4d 00 00       	call   80104f70 <acquiresleep>
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
801001a1:	68 ae 80 10 80       	push   $0x801080ae
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
801001be:	e8 4d 4e 00 00       	call   80105010 <holdingsleep>
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
801001dc:	68 bf 80 10 80       	push   $0x801080bf
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
801001ff:	e8 0c 4e 00 00       	call   80105010 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 bc 4d 00 00       	call   80104fd0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 10 50 00 00       	call   80105230 <acquire>
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
8010026c:	e9 5f 4f 00 00       	jmp    801051d0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 c6 80 10 80       	push   $0x801080c6
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
801002a0:	e8 8b 4f 00 00       	call   80105230 <acquire>
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
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 0e 45 00 00       	call   801047e0 <sleep>
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
801002f6:	e8 d5 4e 00 00       	call   801051d0 <release>
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
8010034c:	e8 7f 4e 00 00       	call   801051d0 <release>
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
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 cd 80 10 80       	push   $0x801080cd
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 f4 85 10 80 	movl   $0x801085f4,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 b3 4c 00 00       	call   80105080 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 e1 80 10 80       	push   $0x801080e1
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
8010041a:	e8 31 67 00 00       	call   80106b50 <uartputc>
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
80100505:	e8 46 66 00 00       	call   80106b50 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 3a 66 00 00       	call   80106b50 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 2e 66 00 00       	call   80106b50 <uartputc>
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
80100551:	e8 3a 4e 00 00       	call   80105390 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 85 4d 00 00       	call   801052f0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 e5 80 10 80       	push   $0x801080e5
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
801005ab:	e8 80 4c 00 00       	call   80105230 <acquire>
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
801005e4:	e8 e7 4b 00 00       	call   801051d0 <release>
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
80100636:	0f b6 92 10 81 10 80 	movzbl -0x7fef7ef0(%edx),%edx
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
801007e8:	e8 43 4a 00 00       	call   80105230 <acquire>
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
80100838:	bf f8 80 10 80       	mov    $0x801080f8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 70 49 00 00       	call   801051d0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 ff 80 10 80       	push   $0x801080ff
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
80100893:	e8 98 49 00 00       	call   80105230 <acquire>
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
801009d0:	e8 fb 47 00 00       	call   801051d0 <release>
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
80100a0e:	e9 6d 3f 00 00       	jmp    80104980 <procdump>
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
80100a44:	e8 57 3e 00 00       	call   801048a0 <wakeup>
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
80100a66:	68 08 81 10 80       	push   $0x80108108
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 eb 45 00 00       	call   80105060 <initlock>

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
80100ac7:	e8 94 22 00 00       	call   80102d60 <begin_op>

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
80100b0f:	e8 bc 22 00 00       	call   80102dd0 <end_op>
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
80100b34:	e8 a7 71 00 00       	call   80107ce0 <setupkvm>
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
80100ba3:	e8 58 6f 00 00       	call   80107b00 <allocuvm>
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
80100bd9:	e8 32 6e 00 00       	call   80107a10 <loaduvm>
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
80100c1b:	e8 40 70 00 00       	call   80107c60 <freevm>
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
80100c51:	e8 7a 21 00 00       	call   80102dd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 99 6e 00 00       	call   80107b00 <allocuvm>
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
80100c83:	e8 f8 70 00 00       	call   80107d80 <clearpteu>
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
80100cd3:	e8 18 48 00 00       	call   801054f0 <strlen>
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
80100ce7:	e8 04 48 00 00       	call   801054f0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 53 72 00 00       	call   80107f50 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 4a 6f 00 00       	call   80107c60 <freevm>
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
80100d63:	e8 e8 71 00 00       	call   80107f50 <copyout>
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
80100da1:	e8 0a 47 00 00       	call   801054b0 <safestrcpy>
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
80100dcd:	e8 ae 6a 00 00       	call   80107880 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 86 6e 00 00       	call   80107c60 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 21 81 10 80       	push   $0x80108121
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
80100e16:	68 2d 81 10 80       	push   $0x8010812d
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 3b 42 00 00       	call   80105060 <initlock>
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
80100e41:	e8 ea 43 00 00       	call   80105230 <acquire>
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
80100e71:	e8 5a 43 00 00       	call   801051d0 <release>
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
80100e8a:	e8 41 43 00 00       	call   801051d0 <release>
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
80100eaf:	e8 7c 43 00 00       	call   80105230 <acquire>
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
80100ecc:	e8 ff 42 00 00       	call   801051d0 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 34 81 10 80       	push   $0x80108134
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
80100f01:	e8 2a 43 00 00       	call   80105230 <acquire>
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
80100f3c:	e8 8f 42 00 00       	call   801051d0 <release>

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
80100f6e:	e9 5d 42 00 00       	jmp    801051d0 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 e3 1d 00 00       	call   80102d60 <begin_op>
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
80100f92:	e9 39 1e 00 00       	jmp    80102dd0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 82 25 00 00       	call   80103530 <pipeclose>
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
80100fbc:	68 3c 81 10 80       	push   $0x8010813c
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
8010108d:	e9 3e 26 00 00       	jmp    801036d0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 46 81 10 80       	push   $0x80108146
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
80101109:	e8 c2 1c 00 00       	call   80102dd0 <end_op>

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
8010112e:	e8 2d 1c 00 00       	call   80102d60 <begin_op>
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
80101165:	e8 66 1c 00 00       	call   80102dd0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 4f 81 10 80       	push   $0x8010814f
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
801011a9:	e9 22 24 00 00       	jmp    801035d0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 55 81 10 80       	push   $0x80108155
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
8010120d:	e8 2e 1d 00 00       	call   80102f40 <log_write>
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
80101227:	68 5f 81 10 80       	push   $0x8010815f
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
801012e4:	68 72 81 10 80       	push   $0x80108172
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
801012fd:	e8 3e 1c 00 00       	call   80102f40 <log_write>
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
80101325:	e8 c6 3f 00 00       	call   801052f0 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 0e 1c 00 00       	call   80102f40 <log_write>
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
8010136a:	e8 c1 3e 00 00       	call   80105230 <acquire>
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
801013d7:	e8 f4 3d 00 00       	call   801051d0 <release>

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
80101405:	e8 c6 3d 00 00       	call   801051d0 <release>
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
80101438:	68 88 81 10 80       	push   $0x80108188
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
801014c5:	e8 76 1a 00 00       	call   80102f40 <log_write>
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
80101515:	68 98 81 10 80       	push   $0x80108198
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
80101541:	e8 4a 3e 00 00       	call   80105390 <memmove>
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
8010156c:	68 ab 81 10 80       	push   $0x801081ab
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 e5 3a 00 00       	call   80105060 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 b2 81 10 80       	push   $0x801081b2
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 9c 39 00 00       	call   80104f30 <initsleeplock>
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
801015bc:	e8 cf 3d 00 00       	call   80105390 <memmove>
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
801015f3:	68 18 82 10 80       	push   $0x80108218
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
8010168e:	e8 5d 3c 00 00       	call   801052f0 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 18 00 00       	call   80102f40 <log_write>
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
801016c3:	68 b8 81 10 80       	push   $0x801081b8
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
80101731:	e8 5a 3c 00 00       	call   80105390 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 02 18 00 00       	call   80102f40 <log_write>
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
8010175f:	e8 cc 3a 00 00       	call   80105230 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 5c 3a 00 00       	call   801051d0 <release>
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
801017a2:	e8 c9 37 00 00       	call   80104f70 <acquiresleep>
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
80101818:	e8 73 3b 00 00       	call   80105390 <memmove>
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
8010183d:	68 d0 81 10 80       	push   $0x801081d0
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 ca 81 10 80       	push   $0x801081ca
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
80101873:	e8 98 37 00 00       	call   80105010 <holdingsleep>
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
8010188f:	e9 3c 37 00 00       	jmp    80104fd0 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 df 81 10 80       	push   $0x801081df
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
801018c0:	e8 ab 36 00 00       	call   80104f70 <acquiresleep>
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
801018da:	e8 f1 36 00 00       	call   80104fd0 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 45 39 00 00       	call   80105230 <acquire>
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
80101900:	e9 cb 38 00 00       	jmp    801051d0 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 1b 39 00 00       	call   80105230 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 ac 38 00 00       	call   801051d0 <release>
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
80101a23:	e8 e8 35 00 00       	call   80105010 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 91 35 00 00       	call   80104fd0 <releasesleep>
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
80101a53:	68 df 81 10 80       	push   $0x801081df
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
80101b37:	e8 54 38 00 00       	call   80105390 <memmove>
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
80101c33:	e8 58 37 00 00       	call   80105390 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 13 00 00       	call   80102f40 <log_write>
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
80101cce:	e8 2d 37 00 00       	call   80105400 <strncmp>
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
80101d2d:	e8 ce 36 00 00       	call   80105400 <strncmp>
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
80101d72:	68 f9 81 10 80       	push   $0x801081f9
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 e7 81 10 80       	push   $0x801081e7
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
80101dba:	e8 71 34 00 00       	call   80105230 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 01 34 00 00       	call   801051d0 <release>
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
80101e27:	e8 64 35 00 00       	call   80105390 <memmove>
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
80101e8c:	e8 7f 31 00 00       	call   80105010 <holdingsleep>
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
80101eae:	e8 1d 31 00 00       	call   80104fd0 <releasesleep>
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
80101edb:	e8 b0 34 00 00       	call   80105390 <memmove>
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
80101f2b:	e8 e0 30 00 00       	call   80105010 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 81 30 00 00       	call   80104fd0 <releasesleep>
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
80101f6d:	e8 9e 30 00 00       	call   80105010 <holdingsleep>
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
80101f90:	e8 7b 30 00 00       	call   80105010 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 24 30 00 00       	call   80104fd0 <releasesleep>
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
80101fcf:	68 df 81 10 80       	push   $0x801081df
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
8010203d:	e8 0e 34 00 00       	call   80105450 <strncpy>
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
8010207b:	68 08 82 10 80       	push   $0x80108208
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 42 88 10 80       	push   $0x80108842
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
8010219b:	68 74 82 10 80       	push   $0x80108274
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 6b 82 10 80       	push   $0x8010826b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 86 82 10 80       	push   $0x80108286
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 8b 2e 00 00       	call   80105060 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 27 11 80       	mov    0x80112784,%eax
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
8010224e:	e8 dd 2f 00 00       	call   80105230 <acquire>

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
801022ad:	e8 ee 25 00 00       	call   801048a0 <wakeup>

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
801022cb:	e8 00 2f 00 00       	call   801051d0 <release>

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
801022ee:	e8 1d 2d 00 00       	call   80105010 <holdingsleep>
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
80102328:	e8 03 2f 00 00       	call   80105230 <acquire>

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
80102369:	e8 72 24 00 00       	call   801047e0 <sleep>
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
80102386:	e9 45 2e 00 00       	jmp    801051d0 <release>
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
801023aa:	68 b5 82 10 80       	push   $0x801082b5
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 a0 82 10 80       	push   $0x801082a0
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 8a 82 10 80       	push   $0x8010828a
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
801023fe:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
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
8010241a:	68 d4 82 10 80       	push   $0x801082d4
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
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb 70 6e 11 80    	cmp    $0x80116e70,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 f9 2d 00 00       	call   801052f0 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 78 26 11 80       	mov    0x80112678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 26 11 80       	push   $0x80112640
80102528:	e8 03 2d 00 00       	call   80105230 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 88 2c 00 00       	jmp    801051d0 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 06 83 10 80       	push   $0x80108306
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 0c 83 10 80       	push   $0x8010830c
80102620:	68 40 26 11 80       	push   $0x80112640
80102625:	e8 36 2a 00 00       	call   80105060 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 74 26 11 80       	mov    0x80112674,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 40 26 11 80       	push   $0x80112640
801026b3:	e8 78 2b 00 00       	call   80105230 <acquire>
  r = kmem.freelist;
801026b8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801026bd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 26 11 80       	push   $0x80112640
801026e1:	e8 ea 2a 00 00       	call   801051d0 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
801026fe:	55                   	push   %ebp
801026ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102704:	89 e5                	mov    %esp,%ebp
80102706:	53                   	push   %ebx
80102707:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102708:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010270e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102711:	3c e0                	cmp    $0xe0,%al
80102713:	74 5b                	je     80102770 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102715:	89 da                	mov    %ebx,%edx
80102717:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010271a:	84 c0                	test   %al,%al
8010271c:	78 62                	js     80102780 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010271e:	85 d2                	test   %edx,%edx
80102720:	74 09                	je     8010272b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102722:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102725:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102728:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010272b:	0f b6 91 40 84 10 80 	movzbl -0x7fef7bc0(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 40 83 10 80 	movzbl -0x7fef7cc0(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 20 83 10 80 	mov    -0x7fef7ce0(,%eax,4),%eax
80102752:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102756:	74 0b                	je     80102763 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102758:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275b:	83 fa 19             	cmp    $0x19,%edx
8010275e:	77 48                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102760:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave  
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 40 84 10 80 	movzbl -0x7fef7bc0(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801027a1:	31 c0                	xor    %eax,%eax
}
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b1:	c9                   	leave  
      c += 'a' - 'A';
801027b2:	83 f9 1a             	cmp    $0x1a,%ecx
801027b5:	0f 42 c2             	cmovb  %edx,%eax
}
801027b8:	c3                   	ret    
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 a0 e0 ff ff       	call   80100880 <consoleintr>
}
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	c9                   	leave  
801027e4:	c3                   	ret    
801027e5:	66 90                	xchg   %ax,%ax
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	0f 84 cb 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
801027fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102804:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102811:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102817:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010281e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102838:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102845:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102848:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284b:	8b 50 30             	mov    0x30(%eax),%edx
8010284e:	c1 ea 10             	shr    $0x10,%edx
80102851:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102857:	75 77                	jne    801028d0 <lapicinit+0xe0>
  lapic[index] = value;
80102859:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102866:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102870:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102873:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102880:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102887:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
801028a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
}
801028dd:	e9 77 ff ff ff       	jmp    80102859 <lapicinit+0x69>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 07                	je     80102900 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028f9:	8b 40 20             	mov    0x20(%eax),%eax
801028fc:	c1 e8 18             	shr    $0x18,%eax
801028ff:	c3                   	ret    
    return 0;
80102900:	31 c0                	xor    %eax,%eax
}
80102902:	c3                   	ret    
80102903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102910:	a1 80 26 11 80       	mov    0x80112680,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 0d                	je     80102926 <lapiceoi+0x16>
  lapic[index] = value;
80102919:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102920:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102923:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102926:	c3                   	ret    
80102927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292e:	66 90                	xchg   %ax,%ax

80102930 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102930:	c3                   	ret    
80102931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102941:	b8 0f 00 00 00       	mov    $0xf,%eax
80102946:	ba 70 00 00 00       	mov    $0x70,%edx
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	53                   	push   %ebx
8010294e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102954:	ee                   	out    %al,(%dx)
80102955:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295a:	ba 71 00 00 00       	mov    $0x71,%edx
8010295f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102960:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102962:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102965:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010296d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102970:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102972:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102975:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102978:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010297e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102983:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102993:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102996:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102999:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cd:	c9                   	leave  
801029ce:	c3                   	ret    
801029cf:	90                   	nop

801029d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029d0:	55                   	push   %ebp
801029d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	ba 71 00 00 00       	mov    $0x71,%edx
801029e9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f5:	8d 76 00             	lea    0x0(%esi),%esi
801029f8:	31 c0                	xor    %eax,%eax
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a08:	89 da                	mov    %ebx,%edx
80102a0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	b8 08 00 00 00       	mov    $0x8,%eax
80102a39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3a:	89 ca                	mov    %ecx,%edx
80102a3c:	ec                   	in     (%dx),%al
80102a3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3f:	89 da                	mov    %ebx,%edx
80102a41:	b8 09 00 00 00       	mov    $0x9,%eax
80102a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a57:	84 c0                	test   %al,%al
80102a59:	78 9d                	js     801029f8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a5f:	89 fa                	mov    %edi,%edx
80102a61:	0f b6 fa             	movzbl %dl,%edi
80102a64:	89 f2                	mov    %esi,%edx
80102a66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a70:	89 da                	mov    %ebx,%edx
80102a72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a89:	31 c0                	xor    %eax,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a97:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
80102aa0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa3:	89 da                	mov    %ebx,%edx
80102aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab9:	b8 07 00 00 00       	mov    $0x7,%eax
80102abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
80102ac2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aca:	b8 08 00 00 00       	mov    $0x8,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102adb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae1:	89 ca                	mov    %ecx,%edx
80102ae3:	ec                   	in     (%dx),%al
80102ae4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ae7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af0:	6a 18                	push   $0x18
80102af2:	50                   	push   %eax
80102af3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af6:	50                   	push   %eax
80102af7:	e8 44 28 00 00       	call   80105340 <memcmp>
80102afc:	83 c4 10             	add    $0x10,%esp
80102aff:	85 c0                	test   %eax,%eax
80102b01:	0f 85 f1 fe ff ff    	jne    801029f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b0b:	75 78                	jne    80102b85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b85:	8b 75 08             	mov    0x8(%ebp),%esi
80102b88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b8b:	89 06                	mov    %eax,(%esi)
80102b8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b90:	89 46 04             	mov    %eax,0x4(%esi)
80102b93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b96:	89 46 08             	mov    %eax,0x8(%esi)
80102b99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba2:	89 46 10             	mov    %eax,0x10(%esi)
80102ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bb5:	5b                   	pop    %ebx
80102bb6:	5e                   	pop    %esi
80102bb7:	5f                   	pop    %edi
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd2:	31 ff                	xor    %edi,%edi
{
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102be0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 e4 26 11 80    	push   0x801126e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c04:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 67 27 00 00       	call   80105390 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 7f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 b7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 af d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
  }
}
80102c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4f:	5b                   	pop    %ebx
80102c50:	5e                   	pop    %esi
80102c51:	5f                   	pop    %edi
80102c52:	5d                   	pop    %ebp
80102c53:	c3                   	ret    
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	c3                   	ret    
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c67:	ff 35 d4 26 11 80    	push   0x801126d4
80102c6d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102c97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d0                	cmp    %edx,%eax
80102ca0:	75 ee                	jne    80102c90 <write_head+0x30>
  }
  bwrite(buf);
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	53                   	push   %ebx
80102ca6:	e8 05 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cab:	89 1c 24             	mov    %ebx,(%esp)
80102cae:	e8 3d d5 ff ff       	call   801001f0 <brelse>
}
80102cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	c9                   	leave  
80102cba:	c3                   	ret    
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <initlog>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 2c             	sub    $0x2c,%esp
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cca:	68 40 85 10 80       	push   $0x80108540
80102ccf:	68 a0 26 11 80       	push   $0x801126a0
80102cd4:	e8 87 23 00 00       	call   80105060 <initlock>
  readsb(dev, &sb);
80102cd9:	58                   	pop    %eax
80102cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 3b e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ce8:	59                   	pop    %ecx
  log.dev = dev;
80102ce9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf2:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102cf7:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d0b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d24:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d3                	cmp    %edx,%ebx
80102d30:	75 ee                	jne    80102d20 <initlog+0x60>
  brelse(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	50                   	push   %eax
80102d36:	e8 b5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d3b:	e8 80 fe ff ff       	call   80102bc0 <install_trans>
  log.lh.n = 0;
80102d40:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d47:	00 00 00 
  write_head(); // clear the log
80102d4a:	e8 11 ff ff ff       	call   80102c60 <write_head>
}
80102d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c9                   	leave  
80102d56:	c3                   	ret    
80102d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d66:	68 a0 26 11 80       	push   $0x801126a0
80102d6b:	e8 c0 24 00 00       	call   80105230 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 26 11 80       	push   $0x801126a0
80102d80:	68 a0 26 11 80       	push   $0x801126a0
80102d85:	e8 56 1a 00 00       	call   801047e0 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d9b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102da1:	83 c0 01             	add    $0x1,%eax
80102da4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102da7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102daa:	83 fa 1e             	cmp    $0x1e,%edx
80102dad:	7f c9                	jg     80102d78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102daf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102db2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102db7:	68 a0 26 11 80       	push   $0x801126a0
80102dbc:	e8 0f 24 00 00       	call   801051d0 <release>
      break;
    }
  }
}
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    
80102dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi

80102dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	57                   	push   %edi
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dd9:	68 a0 26 11 80       	push   $0x801126a0
80102dde:	e8 4d 24 00 00       	call   80105230 <acquire>
  log.outstanding -= 1;
80102de3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102de8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 a0 26 11 80       	push   $0x801126a0
80102e1c:	e8 af 23 00 00       	call   801051d0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 a0 26 11 80       	push   $0x801126a0
80102e36:	e8 f5 23 00 00       	call   80105230 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102e42:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 4f 1a 00 00       	call   801048a0 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e58:	e8 73 23 00 00       	call   801051d0 <release>
80102e5d:	83 c4 10             	add    $0x10,%esp
}
80102e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e63:	5b                   	pop    %ebx
80102e64:	5e                   	pop    %esi
80102e65:	5f                   	pop    %edi
80102e66:	5d                   	pop    %ebp
80102e67:	c3                   	ret    
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e70:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 e4 26 11 80    	push   0x801126e4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102e94:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ea2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ea7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 d7 24 00 00       	call   80105390 <memmove>
    bwrite(to);  // write the log
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 ef d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 27 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 1f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 a0 26 11 80       	push   $0x801126a0
80102f08:	e8 93 19 00 00       	call   801048a0 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f14:	e8 b7 22 00 00       	call   801051d0 <release>
80102f19:	83 c4 10             	add    $0x10,%esp
}
80102f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5f                   	pop    %edi
80102f22:	5d                   	pop    %ebp
80102f23:	c3                   	ret    
    panic("log.committing");
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 44 85 10 80       	push   $0x80108544
80102f2c:	e8 4f d4 ff ff       	call   80100380 <panic>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f47:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f65:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 a0 26 11 80       	push   $0x801126a0
80102f76:	e8 b5 22 00 00       	call   80105230 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f7b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	85 d2                	test   %edx,%edx
80102f86:	7e 4a                	jle    80102fd2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f88:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	31 c0                	xor    %eax,%eax
80102f8d:	eb 08                	jmp    80102f97 <log_write+0x57>
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f97:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 16 22 00 00       	jmp    801051d0 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 53 85 10 80       	push   $0x80108553
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 69 85 10 80       	push   $0x80108569
80102ff3:	e8 88 d3 ff ff       	call   80100380 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 64 0c 00 00       	call   80103c70 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 5d 0c 00 00       	call   80103c70 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 84 85 10 80       	push   $0x80108584
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 f9 36 00 00       	call   80106720 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 e4 0b 00 00       	call   80103c10 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 e1 10 00 00       	call   80104120 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 25 48 00 00       	call   80107870 <switchkvm>
  seginit();
8010304b:	e8 90 47 00 00       	call   801077e0 <seginit>
  lapicinit();
80103050:	e8 9b f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 70 6e 11 80       	push   $0x80116e70
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 da 4c 00 00       	call   80107d60 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 4b 47 00 00       	call   801077e0 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 c7 39 00 00       	call   80106a70 <uartinit>
  pinit();         // process table
801030a9:	e8 42 0b 00 00       	call   80103bf0 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 cd 35 00 00       	call   80106680 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 53 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030bd:	e8 fe f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 8c b4 10 80       	push   $0x8010b48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 b7 22 00 00       	call   80105390 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030e3:	00 00 00 
801030e6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030eb:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 f2 0a 00 00       	call   80103c10 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 59 f5 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010313b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ea f7 ff ff       	call   80102940 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 2e f4 ff ff       	call   801025b0 <kinit2>
  userinit();      // first user process
80103182:	e8 39 0b 00 00       	call   80103cc0 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 fb                	cmp    %edi,%ebx
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 98 85 10 80       	push   $0x80108598
801031c3:	56                   	push   %esi
801031c4:	e8 77 21 00 00       	call   80105340 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret    
80103204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	75 1b                	jne    8010324c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103231:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103238:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010323f:	c1 e0 08             	shl    $0x8,%eax
80103242:	09 d0                	or     %edx,%eax
80103244:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103247:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324c:	ba 00 04 00 00       	mov    $0x400,%edx
80103251:	e8 3a ff ff ff       	call   80103190 <mpsearch1>
80103256:	89 c3                	mov    %eax,%ebx
80103258:	85 c0                	test   %eax,%eax
8010325a:	0f 84 40 01 00 00    	je     801033a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103260:	8b 73 04             	mov    0x4(%ebx),%esi
80103263:	85 f6                	test   %esi,%esi
80103265:	0f 84 25 01 00 00    	je     80103390 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010326e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103274:	6a 04                	push   $0x4
80103276:	68 9d 85 10 80       	push   $0x8010859d
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 bc 20 00 00       	call   80105340 <memcmp>
80103284:	83 c4 10             	add    $0x10,%esp
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 85 01 01 00 00    	jne    80103390 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010328f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103296:	3c 01                	cmp    $0x1,%al
80103298:	74 08                	je     801032a2 <mpinit+0x92>
8010329a:	3c 04                	cmp    $0x4,%al
8010329c:	0f 85 ee 00 00 00    	jne    80103390 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032a9:	66 85 d2             	test   %dx,%dx
801032ac:	74 22                	je     801032d0 <mpinit+0xc0>
801032ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032b3:	31 d2                	xor    %edx,%edx
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032c4:	39 c7                	cmp    %eax,%edi
801032c6:	75 f0                	jne    801032b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032c8:	84 d2                	test   %dl,%dl
801032ca:	0f 85 c0 00 00 00    	jne    80103390 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032d6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801032f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032f7:	90                   	nop
801032f8:	39 d0                	cmp    %edx,%eax
801032fa:	73 15                	jae    80103311 <mpinit+0x101>
    switch(*p){
801032fc:	0f b6 08             	movzbl (%eax),%ecx
801032ff:	80 f9 02             	cmp    $0x2,%cl
80103302:	74 4c                	je     80103350 <mpinit+0x140>
80103304:	77 3a                	ja     80103340 <mpinit+0x130>
80103306:	84 c9                	test   %cl,%cl
80103308:	74 56                	je     80103360 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010330a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	39 d0                	cmp    %edx,%eax
8010330f:	72 eb                	jb     801032fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103311:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103314:	85 f6                	test   %esi,%esi
80103316:	0f 84 d9 00 00 00    	je     801033f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010331c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103320:	74 15                	je     80103337 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103322:	b8 70 00 00 00       	mov    $0x70,%eax
80103327:	ba 22 00 00 00       	mov    $0x22,%edx
8010332c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010332d:	ba 23 00 00 00       	mov    $0x23,%edx
80103332:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103333:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103336:	ee                   	out    %al,(%dx)
  }
}
80103337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333a:	5b                   	pop    %ebx
8010333b:	5e                   	pop    %esi
8010333c:	5f                   	pop    %edi
8010333d:	5d                   	pop    %ebp
8010333e:	c3                   	ret    
8010333f:	90                   	nop
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 c2                	jbe    8010330a <mpinit+0xfa>
80103348:	31 f6                	xor    %esi,%esi
8010334a:	eb ac                	jmp    801032f8 <mpinit+0xe8>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103350:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103354:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103357:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010335d:	eb 99                	jmp    801032f8 <mpinit+0xe8>
8010335f:	90                   	nop
      if(ncpu < NCPU) {
80103360:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 6c ff ff ff       	jmp    801032f8 <mpinit+0xe8>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 a2 85 10 80       	push   $0x801085a2
80103398:	e8 e3 cf ff ff       	call   80100380 <panic>
8010339d:	8d 76 00             	lea    0x0(%esi),%esi
{
801033a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033a5:	eb 13                	jmp    801033ba <mpinit+0x1aa>
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033b0:	89 f3                	mov    %esi,%ebx
801033b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033b8:	74 d6                	je     80103390 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ba:	83 ec 04             	sub    $0x4,%esp
801033bd:	8d 73 10             	lea    0x10(%ebx),%esi
801033c0:	6a 04                	push   $0x4
801033c2:	68 98 85 10 80       	push   $0x80108598
801033c7:	53                   	push   %ebx
801033c8:	e8 73 1f 00 00       	call   80105340 <memcmp>
801033cd:	83 c4 10             	add    $0x10,%esp
801033d0:	85 c0                	test   %eax,%eax
801033d2:	75 dc                	jne    801033b0 <mpinit+0x1a0>
801033d4:	89 da                	mov    %ebx,%edx
801033d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e8:	39 d6                	cmp    %edx,%esi
801033ea:	75 f4                	jne    801033e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ec:	84 c0                	test   %al,%al
801033ee:	75 c0                	jne    801033b0 <mpinit+0x1a0>
801033f0:	e9 6b fe ff ff       	jmp    80103260 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033f5:	83 ec 0c             	sub    $0xc,%esp
801033f8:	68 bc 85 10 80       	push   $0x801085bc
801033fd:	e8 7e cf ff ff       	call   80100380 <panic>
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <picinit>:
80103410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103415:	ba 21 00 00 00       	mov    $0x21,%edx
8010341a:	ee                   	out    %al,(%dx)
8010341b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103420:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103421:	c3                   	ret    
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010343c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010343f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010344b:	e8 e0 d9 ff ff       	call   80100e30 <filealloc>
80103450:	89 03                	mov    %eax,(%ebx)
80103452:	85 c0                	test   %eax,%eax
80103454:	0f 84 a8 00 00 00    	je     80103502 <pipealloc+0xd2>
8010345a:	e8 d1 d9 ff ff       	call   80100e30 <filealloc>
8010345f:	89 06                	mov    %eax,(%esi)
80103461:	85 c0                	test   %eax,%eax
80103463:	0f 84 87 00 00 00    	je     801034f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103469:	e8 12 f2 ff ff       	call   80102680 <kalloc>
8010346e:	89 c7                	mov    %eax,%edi
80103470:	85 c0                	test   %eax,%eax
80103472:	0f 84 b0 00 00 00    	je     80103528 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103478:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103482:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103485:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010348c:	00 00 00 
  p->nwrite = 0;
8010348f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103496:	00 00 00 
  p->nread = 0;
80103499:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034a0:	00 00 00 
  initlock(&p->lock, "pipe");
801034a3:	68 db 85 10 80       	push   $0x801085db
801034a8:	50                   	push   %eax
801034a9:	e8 b2 1b 00 00       	call   80105060 <initlock>
  (*f0)->type = FD_PIPE;
801034ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b9:	8b 03                	mov    (%ebx),%eax
801034bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034bf:	8b 03                	mov    (%ebx),%eax
801034c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034c5:	8b 03                	mov    (%ebx),%eax
801034c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d8:	8b 06                	mov    (%esi),%eax
801034da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034e6:	31 c0                	xor    %eax,%eax
}
801034e8:	5b                   	pop    %ebx
801034e9:	5e                   	pop    %esi
801034ea:	5f                   	pop    %edi
801034eb:	5d                   	pop    %ebp
801034ec:	c3                   	ret    
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	74 1e                	je     80103514 <pipealloc+0xe4>
    fileclose(*f0);
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	50                   	push   %eax
801034fa:	e8 f1 d9 ff ff       	call   80100ef0 <fileclose>
801034ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103502:	8b 06                	mov    (%esi),%eax
80103504:	85 c0                	test   %eax,%eax
80103506:	74 0c                	je     80103514 <pipealloc+0xe4>
    fileclose(*f1);
80103508:	83 ec 0c             	sub    $0xc,%esp
8010350b:	50                   	push   %eax
8010350c:	e8 df d9 ff ff       	call   80100ef0 <fileclose>
80103511:	83 c4 10             	add    $0x10,%esp
}
80103514:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010351c:	5b                   	pop    %ebx
8010351d:	5e                   	pop    %esi
8010351e:	5f                   	pop    %edi
8010351f:	5d                   	pop    %ebp
80103520:	c3                   	ret    
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103528:	8b 03                	mov    (%ebx),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	75 c8                	jne    801034f6 <pipealloc+0xc6>
8010352e:	eb d2                	jmp    80103502 <pipealloc+0xd2>

80103530 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	56                   	push   %esi
80103534:	53                   	push   %ebx
80103535:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103538:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	53                   	push   %ebx
8010353f:	e8 ec 1c 00 00       	call   80105230 <acquire>
  if(writable){
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 f6                	test   %esi,%esi
80103549:	74 65                	je     801035b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103554:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010355b:	00 00 00 
    wakeup(&p->nread);
8010355e:	50                   	push   %eax
8010355f:	e8 3c 13 00 00       	call   801048a0 <wakeup>
80103564:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103567:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010356d:	85 d2                	test   %edx,%edx
8010356f:	75 0a                	jne    8010357b <pipeclose+0x4b>
80103571:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	74 15                	je     80103590 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010357b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010357e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103581:	5b                   	pop    %ebx
80103582:	5e                   	pop    %esi
80103583:	5d                   	pop    %ebp
    release(&p->lock);
80103584:	e9 47 1c 00 00       	jmp    801051d0 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 37 1c 00 00       	call   801051d0 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 16 ef ff ff       	jmp    801024c0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 d7 12 00 00       	call   801048a0 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb 99                	jmp    80103567 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 28             	sub    $0x28,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035dc:	53                   	push   %ebx
801035dd:	e8 4e 1c 00 00       	call   80105230 <acquire>
  for(i = 0; i < n; i++){
801035e2:	8b 45 10             	mov    0x10(%ebp),%eax
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	85 c0                	test   %eax,%eax
801035ea:	0f 8e c0 00 00 00    	jle    801036b0 <pipewrite+0xe0>
801035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103602:	03 45 10             	add    0x10(%ebp),%eax
80103605:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103608:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103614:	89 ca                	mov    %ecx,%edx
80103616:	05 00 02 00 00       	add    $0x200,%eax
8010361b:	39 c1                	cmp    %eax,%ecx
8010361d:	74 3f                	je     8010365e <pipewrite+0x8e>
8010361f:	eb 67                	jmp    80103688 <pipewrite+0xb8>
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103628:	e8 63 06 00 00       	call   80103c90 <myproc>
8010362d:	8b 48 24             	mov    0x24(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 63 12 00 00       	call   801048a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 9a 11 00 00       	call   801047e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103646:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103652:	83 c4 10             	add    $0x10,%esp
80103655:	05 00 02 00 00       	add    $0x200,%eax
8010365a:	39 c2                	cmp    %eax,%edx
8010365c:	75 2a                	jne    80103688 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010365e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c0                	jne    80103628 <pipewrite+0x58>
        release(&p->lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	53                   	push   %ebx
8010366c:	e8 5f 1b 00 00       	call   801051d0 <release>
        return -1;
80103671:	83 c4 10             	add    $0x10,%esp
80103674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103688:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010368b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010368e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103694:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010369a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010369d:	83 c6 01             	add    $0x1,%esi
801036a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036aa:	0f 85 58 ff ff ff    	jne    80103608 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036b9:	50                   	push   %eax
801036ba:	e8 e1 11 00 00       	call   801048a0 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 09 1b 00 00       	call   801051d0 <release>
  return n;
801036c7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	eb aa                	jmp    80103679 <pipewrite+0xa9>
801036cf:	90                   	nop

801036d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 18             	sub    $0x18,%esp
801036d9:	8b 75 08             	mov    0x8(%ebp),%esi
801036dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036df:	56                   	push   %esi
801036e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036e6:	e8 45 1b 00 00       	call   80105230 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 8b 05 00 00       	call   80103c90 <myproc>
80103705:	8b 48 24             	mov    0x24(%eax),%ecx
80103708:	85 c9                	test   %ecx,%ecx
8010370a:	0f 85 80 00 00 00    	jne    80103790 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 c6 10 00 00       	call   801047e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103720:	83 c4 10             	add    $0x10,%esp
80103723:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103729:	75 0a                	jne    80103735 <piperead+0x65>
8010372b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103731:	85 c0                	test   %eax,%eax
80103733:	75 cb                	jne    80103700 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103735:	8b 55 10             	mov    0x10(%ebp),%edx
80103738:	31 db                	xor    %ebx,%ebx
8010373a:	85 d2                	test   %edx,%edx
8010373c:	7f 20                	jg     8010375e <piperead+0x8e>
8010373e:	eb 2c                	jmp    8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010374e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010375e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103764:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 25 11 00 00       	call   801048a0 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 4d 1a 00 00       	call   801051d0 <release>
  return i;
80103783:	83 c4 10             	add    $0x10,%esp
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret    
      release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103798:	56                   	push   %esi
80103799:	e8 32 1a 00 00       	call   801051d0 <release>
      return -1;
8010379e:	83 c4 10             	add    $0x10,%esp
}
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret    
801037ab:	66 90                	xchg   %ax,%ax
801037ad:	66 90                	xchg   %ax,%ax
801037af:	90                   	nop

801037b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 20 2d 11 80       	push   $0x80112d20
801037c1:	e8 6a 1a 00 00       	call   80105230 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 17                	jmp    801037e2 <allocproc+0x32>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801037d6:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
801037dc:	0f 84 9e 00 00 00    	je     80103880 <allocproc+0xd0>
    if(p->state == UNUSED)
801037e2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037e5:	85 c0                	test   %eax,%eax
801037e7:	75 e7                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->level = -1;
  p->priority = 0;
  p->tq = 0;
  p->yielded = 0;

  release(&ptable.lock);
801037ee:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037f1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->level = -1;
801037f8:	c7 43 7c ff ff ff ff 	movl   $0xffffffff,0x7c(%ebx)
  p->pid = nextpid++;
801037ff:	89 43 10             	mov    %eax,0x10(%ebx)
80103802:	8d 50 01             	lea    0x1(%eax),%edx
  p->priority = 0;
80103805:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010380c:	00 00 00 
  p->tq = 0;
8010380f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103816:	00 00 00 
  p->yielded = 0;
80103819:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103820:	00 00 00 
  release(&ptable.lock);
80103823:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103828:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
8010382e:	e8 9d 19 00 00       	call   801051d0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103833:	e8 48 ee ff ff       	call   80102680 <kalloc>
80103838:	83 c4 10             	add    $0x10,%esp
8010383b:	89 43 08             	mov    %eax,0x8(%ebx)
8010383e:	85 c0                	test   %eax,%eax
80103840:	74 57                	je     80103899 <allocproc+0xe9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103842:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103848:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010384b:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103850:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103853:	c7 40 14 67 66 10 80 	movl   $0x80106667,0x14(%eax)
  p->context = (struct context*)sp;
8010385a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010385d:	6a 14                	push   $0x14
8010385f:	6a 00                	push   $0x0
80103861:	50                   	push   %eax
80103862:	e8 89 1a 00 00       	call   801052f0 <memset>
  p->context->eip = (uint)forkret;
80103867:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010386a:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010386d:	c7 40 10 b0 38 10 80 	movl   $0x801038b0,0x10(%eax)
}
80103874:	89 d8                	mov    %ebx,%eax
80103876:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103879:	c9                   	leave  
8010387a:	c3                   	ret    
8010387b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010387f:	90                   	nop
  release(&ptable.lock);
80103880:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103883:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103885:	68 20 2d 11 80       	push   $0x80112d20
8010388a:	e8 41 19 00 00       	call   801051d0 <release>
}
8010388f:	89 d8                	mov    %ebx,%eax
  return 0;
80103891:	83 c4 10             	add    $0x10,%esp
}
80103894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103897:	c9                   	leave  
80103898:	c3                   	ret    
    p->state = UNUSED;
80103899:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038a0:	31 db                	xor    %ebx,%ebx
}
801038a2:	89 d8                	mov    %ebx,%eax
801038a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a7:	c9                   	leave  
801038a8:	c3                   	ret    
801038a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038b6:	68 20 2d 11 80       	push   $0x80112d20
801038bb:	e8 10 19 00 00       	call   801051d0 <release>

  if (first) {
801038c0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038c5:	83 c4 10             	add    $0x10,%esp
801038c8:	85 c0                	test   %eax,%eax
801038ca:	75 04                	jne    801038d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038cc:	c9                   	leave  
801038cd:	c3                   	ret    
801038ce:	66 90                	xchg   %ax,%ax
    first = 0;
801038d0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038d7:	00 00 00 
    iinit(ROOTDEV);
801038da:	83 ec 0c             	sub    $0xc,%esp
801038dd:	6a 01                	push   $0x1
801038df:	e8 7c dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801038e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038eb:	e8 d0 f3 ff ff       	call   80102cc0 <initlog>
}
801038f0:	83 c4 10             	add    $0x10,%esp
801038f3:	c9                   	leave  
801038f4:	c3                   	ret    
801038f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103900 <swap>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	53                   	push   %ebx
80103904:	8b 55 08             	mov    0x8(%ebp),%edx
80103907:	8b 45 0c             	mov    0xc(%ebp),%eax
  tmp = *p1;
8010390a:	8b 0a                	mov    (%edx),%ecx
  *p1 = *p2;
8010390c:	8b 18                	mov    (%eax),%ebx
8010390e:	89 1a                	mov    %ebx,(%edx)
  *p2 = tmp;
80103910:	89 08                	mov    %ecx,(%eax)
}
80103912:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103915:	c9                   	leave  
80103916:	c3                   	ret    
80103917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010391e:	66 90                	xchg   %ax,%ax

80103920 <qinit>:
  for (int i = 0; i <= 3; i ++){
80103920:	b8 80 51 11 80       	mov    $0x80115180,%eax
80103925:	31 d2                	xor    %edx,%edx
    mlfq[i].level = i;
80103927:	89 90 10 01 00 00    	mov    %edx,0x110(%eax)
  for (int i = 0; i <= 3; i ++){
8010392d:	83 c2 01             	add    $0x1,%edx
80103930:	05 18 01 00 00       	add    $0x118,%eax
    mlfq[i].size = mlfq[i].start = mlfq[i].end = 0;
80103935:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
8010393c:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
80103943:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
  for (int i = 0; i <= 3; i ++){
8010394a:	83 fa 04             	cmp    $0x4,%edx
8010394d:	75 d8                	jne    80103927 <qinit+0x7>
  moq.size = moq.start = moq.end = 0;
8010394f:	c7 05 68 51 11 80 00 	movl   $0x0,0x80115168
80103956:	00 00 00 
80103959:	c7 05 64 51 11 80 00 	movl   $0x0,0x80115164
80103960:	00 00 00 
80103963:	c7 05 6c 51 11 80 00 	movl   $0x0,0x8011516c
8010396a:	00 00 00 
  moq.level = 99;
8010396d:	c7 05 70 51 11 80 63 	movl   $0x63,0x80115170
80103974:	00 00 00 
}
80103977:	c3                   	ret    
80103978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010397f:	90                   	nop

80103980 <qprint>:
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	57                   	push   %edi
80103984:	56                   	push   %esi
80103985:	53                   	push   %ebx
80103986:	83 ec 14             	sub    $0x14,%esp
80103989:	8b 7d 08             	mov    0x8(%ebp),%edi
  cprintf("queue %d start\n", q->level);
8010398c:	ff b7 10 01 00 00    	push   0x110(%edi)
80103992:	68 e0 85 10 80       	push   $0x801085e0
80103997:	e8 04 cd ff ff       	call   801006a0 <cprintf>
  for (int i = 1; i <= q->size; i ++){
8010399c:	8b 87 0c 01 00 00    	mov    0x10c(%edi),%eax
801039a2:	83 c4 10             	add    $0x10,%esp
801039a5:	85 c0                	test   %eax,%eax
801039a7:	7e 67                	jle    80103a10 <qprint+0x90>
801039a9:	bb 01 00 00 00       	mov    $0x1,%ebx
    else p = q->heap[(q->start + i - 1) % (NPROC + 1)];
801039ae:	be 7f e0 07 7e       	mov    $0x7e07e07f,%esi
801039b3:	eb 4a                	jmp    801039ff <qprint+0x7f>
801039b5:	8d 76 00             	lea    0x0(%esi),%esi
801039b8:	8b 8f 04 01 00 00    	mov    0x104(%edi),%ecx
801039be:	01 d9                	add    %ebx,%ecx
801039c0:	83 e9 01             	sub    $0x1,%ecx
801039c3:	89 c8                	mov    %ecx,%eax
801039c5:	f7 ee                	imul   %esi
801039c7:	89 c8                	mov    %ecx,%eax
801039c9:	c1 f8 1f             	sar    $0x1f,%eax
801039cc:	c1 fa 05             	sar    $0x5,%edx
801039cf:	29 c2                	sub    %eax,%edx
801039d1:	89 d0                	mov    %edx,%eax
801039d3:	c1 e0 06             	shl    $0x6,%eax
801039d6:	01 d0                	add    %edx,%eax
801039d8:	29 c1                	sub    %eax,%ecx
801039da:	8b 04 8f             	mov    (%edi,%ecx,4),%eax
    cprintf("pid = %d, name = %s, state = %d\n", p->pid, p->name, p->state);
801039dd:	8d 50 6c             	lea    0x6c(%eax),%edx
801039e0:	ff 70 0c             	push   0xc(%eax)
  for (int i = 1; i <= q->size; i ++){
801039e3:	83 c3 01             	add    $0x1,%ebx
    cprintf("pid = %d, name = %s, state = %d\n", p->pid, p->name, p->state);
801039e6:	52                   	push   %edx
801039e7:	ff 70 10             	push   0x10(%eax)
801039ea:	68 d8 86 10 80       	push   $0x801086d8
801039ef:	e8 ac cc ff ff       	call   801006a0 <cprintf>
  for (int i = 1; i <= q->size; i ++){
801039f4:	83 c4 10             	add    $0x10,%esp
801039f7:	39 9f 0c 01 00 00    	cmp    %ebx,0x10c(%edi)
801039fd:	7c 11                	jl     80103a10 <qprint+0x90>
    if (q->level == 3) p = q->heap[i];
801039ff:	83 bf 10 01 00 00 03 	cmpl   $0x3,0x110(%edi)
80103a06:	75 b0                	jne    801039b8 <qprint+0x38>
80103a08:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
80103a0b:	eb d0                	jmp    801039dd <qprint+0x5d>
80103a0d:	8d 76 00             	lea    0x0(%esi),%esi
  cprintf("end\n\n");
80103a10:	c7 45 08 f0 85 10 80 	movl   $0x801085f0,0x8(%ebp)
}
80103a17:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a1a:	5b                   	pop    %ebx
80103a1b:	5e                   	pop    %esi
80103a1c:	5f                   	pop    %edi
80103a1d:	5d                   	pop    %ebp
  cprintf("end\n\n");
80103a1e:	e9 7d cc ff ff       	jmp    801006a0 <cprintf>
80103a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a30 <enqueue>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	57                   	push   %edi
80103a34:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103a37:	56                   	push   %esi
80103a38:	53                   	push   %ebx
80103a39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if (q->size == NPROC)
80103a3c:	8b 81 0c 01 00 00    	mov    0x10c(%ecx),%eax
80103a42:	83 f8 40             	cmp    $0x40,%eax
80103a45:	74 4f                	je     80103a96 <enqueue+0x66>
	q->size = q->size + 1;
80103a47:	83 c0 01             	add    $0x1,%eax
  if(q->level == 3){
80103a4a:	83 b9 10 01 00 00 03 	cmpl   $0x3,0x110(%ecx)
	q->size = q->size + 1;
80103a51:	89 81 0c 01 00 00    	mov    %eax,0x10c(%ecx)
  if(q->level == 3){
80103a57:	74 64                	je     80103abd <enqueue+0x8d>
    q->heap[q->end] = p;
80103a59:	8b 81 08 01 00 00    	mov    0x108(%ecx),%eax
    q->end = (q->end + 1) % (NPROC + 1);
80103a5f:	ba 7f e0 07 7e       	mov    $0x7e07e07f,%edx
    q->heap[q->end] = p;
80103a64:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    q->end = (q->end + 1) % (NPROC + 1);
80103a67:	8d 58 01             	lea    0x1(%eax),%ebx
80103a6a:	89 d8                	mov    %ebx,%eax
80103a6c:	f7 ea                	imul   %edx
80103a6e:	89 d8                	mov    %ebx,%eax
80103a70:	c1 f8 1f             	sar    $0x1f,%eax
80103a73:	c1 fa 05             	sar    $0x5,%edx
80103a76:	29 c2                	sub    %eax,%edx
80103a78:	89 d0                	mov    %edx,%eax
80103a7a:	c1 e0 06             	shl    $0x6,%eax
80103a7d:	01 d0                	add    %edx,%eax
80103a7f:	29 c3                	sub    %eax,%ebx
    q->front = q->heap[q->start];
80103a81:	8b 81 04 01 00 00    	mov    0x104(%ecx),%eax
    q->end = (q->end + 1) % (NPROC + 1);
80103a87:	89 99 08 01 00 00    	mov    %ebx,0x108(%ecx)
    q->front = q->heap[q->start];
80103a8d:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80103a90:	89 81 14 01 00 00    	mov    %eax,0x114(%ecx)
}
80103a96:	5b                   	pop    %ebx
80103a97:	5e                   	pop    %esi
80103a98:	5f                   	pop    %edi
80103a99:	5d                   	pop    %ebp
80103a9a:	c3                   	ret    
80103a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a9f:	90                   	nop
80103aa0:	89 c2                	mov    %eax,%edx
    while ((i != 1) && ((p->priority) > (q->heap[i / 2]->priority))){
80103aa2:	c1 e8 1f             	shr    $0x1f,%eax
80103aa5:	01 d0                	add    %edx,%eax
80103aa7:	d1 f8                	sar    %eax
80103aa9:	8b 34 81             	mov    (%ecx,%eax,4),%esi
80103aac:	8b be 80 00 00 00    	mov    0x80(%esi),%edi
80103ab2:	39 bb 80 00 00 00    	cmp    %edi,0x80(%ebx)
80103ab8:	7e 0d                	jle    80103ac7 <enqueue+0x97>
      q->heap[i] = q->heap[i / 2];
80103aba:	89 34 91             	mov    %esi,(%ecx,%edx,4)
    while ((i != 1) && ((p->priority) > (q->heap[i / 2]->priority))){
80103abd:	83 f8 01             	cmp    $0x1,%eax
80103ac0:	75 de                	jne    80103aa0 <enqueue+0x70>
{
80103ac2:	ba 01 00 00 00       	mov    $0x1,%edx
    q->heap[i] = p;
80103ac7:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    q->front = q->heap[1];
80103aca:	8b 41 04             	mov    0x4(%ecx),%eax
80103acd:	89 81 14 01 00 00    	mov    %eax,0x114(%ecx)
}
80103ad3:	5b                   	pop    %ebx
80103ad4:	5e                   	pop    %esi
80103ad5:	5f                   	pop    %edi
80103ad6:	5d                   	pop    %ebp
80103ad7:	c3                   	ret    
80103ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103adf:	90                   	nop

80103ae0 <heapify>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	57                   	push   %edi
80103ae4:	56                   	push   %esi
80103ae5:	53                   	push   %ebx
80103ae6:	83 ec 04             	sub    $0x4,%esp
80103ae9:	8b 55 08             	mov    0x8(%ebp),%edx
80103aec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  if (left <= q->size && q->heap[left]->priority > q->heap[front]->priority)
80103aef:	8b ba 0c 01 00 00    	mov    0x10c(%edx),%edi
80103af5:	89 7d f0             	mov    %edi,-0x10(%ebp)
80103af8:	eb 33                	jmp    80103b2d <heapify+0x4d>
80103afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b00:	8b 34 8a             	mov    (%edx,%ecx,4),%esi
80103b03:	8b 3c 9a             	mov    (%edx,%ebx,4),%edi
80103b06:	8b b6 80 00 00 00    	mov    0x80(%esi),%esi
80103b0c:	39 b7 80 00 00 00    	cmp    %esi,0x80(%edi)
80103b12:	7e 24                	jle    80103b38 <heapify+0x58>
  if (right <= q->size && q->heap[right]->priority > q->heap[front]->priority)
80103b14:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80103b17:	7d 40                	jge    80103b59 <heapify+0x79>
80103b19:	89 d8                	mov    %ebx,%eax
  if (front != i){
80103b1b:	39 c8                	cmp    %ecx,%eax
80103b1d:	74 32                	je     80103b51 <heapify+0x71>
  *p1 = *p2;
80103b1f:	8b 34 8a             	mov    (%edx,%ecx,4),%esi
  tmp = *p1;
80103b22:	8b 1c 82             	mov    (%edx,%eax,4),%ebx
  *p1 = *p2;
80103b25:	89 34 82             	mov    %esi,(%edx,%eax,4)
  *p2 = tmp;
80103b28:	89 1c 8a             	mov    %ebx,(%edx,%ecx,4)
80103b2b:	89 c1                	mov    %eax,%ecx
  int left = i * 2;
80103b2d:	8d 1c 09             	lea    (%ecx,%ecx,1),%ebx
  int right = i * 2 + 1;
80103b30:	8d 43 01             	lea    0x1(%ebx),%eax
  if (left <= q->size && q->heap[left]->priority > q->heap[front]->priority)
80103b33:	39 5d f0             	cmp    %ebx,-0x10(%ebp)
80103b36:	7d c8                	jge    80103b00 <heapify+0x20>
  if (right <= q->size && q->heap[right]->priority > q->heap[front]->priority)
80103b38:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80103b3b:	7c 14                	jl     80103b51 <heapify+0x71>
80103b3d:	8b 1c 82             	mov    (%edx,%eax,4),%ebx
80103b40:	8b 34 8a             	mov    (%edx,%ecx,4),%esi
80103b43:	8b 9b 80 00 00 00    	mov    0x80(%ebx),%ebx
80103b49:	39 9e 80 00 00 00    	cmp    %ebx,0x80(%esi)
80103b4f:	7c ca                	jl     80103b1b <heapify+0x3b>
}
80103b51:	83 c4 04             	add    $0x4,%esp
80103b54:	5b                   	pop    %ebx
80103b55:	5e                   	pop    %esi
80103b56:	5f                   	pop    %edi
80103b57:	5d                   	pop    %ebp
80103b58:	c3                   	ret    
80103b59:	8b 34 82             	mov    (%edx,%eax,4),%esi
80103b5c:	8b bf 80 00 00 00    	mov    0x80(%edi),%edi
80103b62:	39 be 80 00 00 00    	cmp    %edi,0x80(%esi)
80103b68:	0f 4e c3             	cmovle %ebx,%eax
80103b6b:	eb ae                	jmp    80103b1b <heapify+0x3b>
80103b6d:	8d 76 00             	lea    0x0(%esi),%esi

80103b70 <dequeue>:
{ 
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	56                   	push   %esi
80103b74:	53                   	push   %ebx
80103b75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (q->size == 0) 
80103b78:	8b b3 0c 01 00 00    	mov    0x10c(%ebx),%esi
80103b7e:	85 f6                	test   %esi,%esi
80103b80:	74 46                	je     80103bc8 <dequeue+0x58>
  if (q->level == 3){
80103b82:	83 bb 10 01 00 00 03 	cmpl   $0x3,0x110(%ebx)
80103b89:	74 45                	je     80103bd0 <dequeue+0x60>
    q->start = (q->start + 1) % (NPROC + 1);
80103b8b:	8b 83 04 01 00 00    	mov    0x104(%ebx),%eax
80103b91:	ba 7f e0 07 7e       	mov    $0x7e07e07f,%edx
80103b96:	8d 48 01             	lea    0x1(%eax),%ecx
80103b99:	89 c8                	mov    %ecx,%eax
80103b9b:	f7 ea                	imul   %edx
80103b9d:	89 c8                	mov    %ecx,%eax
80103b9f:	c1 f8 1f             	sar    $0x1f,%eax
80103ba2:	c1 fa 05             	sar    $0x5,%edx
80103ba5:	29 c2                	sub    %eax,%edx
80103ba7:	89 d0                	mov    %edx,%eax
80103ba9:	c1 e0 06             	shl    $0x6,%eax
80103bac:	01 d0                	add    %edx,%eax
80103bae:	29 c1                	sub    %eax,%ecx
80103bb0:	89 8b 04 01 00 00    	mov    %ecx,0x104(%ebx)
    q->front = q->heap[q->start];
80103bb6:	8b 04 8b             	mov    (%ebx,%ecx,4),%eax
  q->size = q->size - 1;
80103bb9:	83 ee 01             	sub    $0x1,%esi
    q->front = q->heap[1];
80103bbc:	89 83 14 01 00 00    	mov    %eax,0x114(%ebx)
  q->size = q->size - 1;
80103bc2:	89 b3 0c 01 00 00    	mov    %esi,0x10c(%ebx)
}
80103bc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bcb:	5b                   	pop    %ebx
80103bcc:	5e                   	pop    %esi
80103bcd:	5d                   	pop    %ebp
80103bce:	c3                   	ret    
80103bcf:	90                   	nop
    q->heap[1] = q->heap[q->size];
80103bd0:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
80103bd3:	89 43 04             	mov    %eax,0x4(%ebx)
    heapify(q, 1);
80103bd6:	6a 01                	push   $0x1
80103bd8:	53                   	push   %ebx
80103bd9:	e8 02 ff ff ff       	call   80103ae0 <heapify>
    q->front = q->heap[1];
80103bde:	5a                   	pop    %edx
80103bdf:	8b 43 04             	mov    0x4(%ebx),%eax
80103be2:	59                   	pop    %ecx
80103be3:	eb d4                	jmp    80103bb9 <dequeue+0x49>
80103be5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103bf0 <pinit>:
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103bf6:	68 f6 85 10 80       	push   $0x801085f6
80103bfb:	68 20 2d 11 80       	push   $0x80112d20
80103c00:	e8 5b 14 00 00       	call   80105060 <initlock>
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
80103c1c:	e8 cf ec ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103c21:	8b 35 84 27 11 80    	mov    0x80112784,%esi
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
80103c3d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103c44:	39 c3                	cmp    %eax,%ebx
80103c46:	75 e8                	jne    80103c30 <mycpu+0x20>
}
80103c48:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103c4b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103c51:	5b                   	pop    %ebx
80103c52:	5e                   	pop    %esi
80103c53:	5d                   	pop    %ebp
80103c54:	c3                   	ret    
  panic("unknown apicid\n");
80103c55:	83 ec 0c             	sub    $0xc,%esp
80103c58:	68 fd 85 10 80       	push   $0x801085fd
80103c5d:	e8 1e c7 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103c62:	83 ec 0c             	sub    $0xc,%esp
80103c65:	68 fc 86 10 80       	push   $0x801086fc
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
80103c7c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
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
80103c97:	e8 44 14 00 00       	call   801050e0 <pushcli>
  c = mycpu();
80103c9c:	e8 6f ff ff ff       	call   80103c10 <mycpu>
  p = c->proc;
80103ca1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ca7:	e8 84 14 00 00       	call   80105130 <popcli>
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
80103cc1:	b8 80 51 11 80       	mov    $0x80115180,%eax
  for (int i = 0; i <= 3; i ++){
80103cc6:	31 d2                	xor    %edx,%edx
{
80103cc8:	89 e5                	mov    %esp,%ebp
80103cca:	53                   	push   %ebx
80103ccb:	83 ec 04             	sub    $0x4,%esp
    mlfq[i].level = i;
80103cce:	89 90 10 01 00 00    	mov    %edx,0x110(%eax)
  for (int i = 0; i <= 3; i ++){
80103cd4:	83 c2 01             	add    $0x1,%edx
80103cd7:	05 18 01 00 00       	add    $0x118,%eax
    mlfq[i].size = mlfq[i].start = mlfq[i].end = 0;
80103cdc:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
80103ce3:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
80103cea:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
  for (int i = 0; i <= 3; i ++){
80103cf1:	83 fa 04             	cmp    $0x4,%edx
80103cf4:	75 d8                	jne    80103cce <userinit+0xe>
  moq.size = moq.start = moq.end = 0;
80103cf6:	c7 05 68 51 11 80 00 	movl   $0x0,0x80115168
80103cfd:	00 00 00 
80103d00:	c7 05 64 51 11 80 00 	movl   $0x0,0x80115164
80103d07:	00 00 00 
80103d0a:	c7 05 6c 51 11 80 00 	movl   $0x0,0x8011516c
80103d11:	00 00 00 
  moq.level = 99;
80103d14:	c7 05 70 51 11 80 63 	movl   $0x63,0x80115170
80103d1b:	00 00 00 
  p = allocproc();
80103d1e:	e8 8d fa ff ff       	call   801037b0 <allocproc>
80103d23:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103d25:	a3 e0 55 11 80       	mov    %eax,0x801155e0
  if((p->pgdir = setupkvm()) == 0)
80103d2a:	e8 b1 3f 00 00       	call   80107ce0 <setupkvm>
80103d2f:	89 43 04             	mov    %eax,0x4(%ebx)
80103d32:	85 c0                	test   %eax,%eax
80103d34:	0f 84 db 00 00 00    	je     80103e15 <userinit+0x155>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103d3a:	83 ec 04             	sub    $0x4,%esp
80103d3d:	68 2c 00 00 00       	push   $0x2c
80103d42:	68 60 b4 10 80       	push   $0x8010b460
80103d47:	50                   	push   %eax
80103d48:	e8 43 3c 00 00       	call   80107990 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103d4d:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103d50:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103d56:	6a 4c                	push   $0x4c
80103d58:	6a 00                	push   $0x0
80103d5a:	ff 73 18             	push   0x18(%ebx)
80103d5d:	e8 8e 15 00 00       	call   801052f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d62:	8b 43 18             	mov    0x18(%ebx),%eax
80103d65:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d6a:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d6d:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d72:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d76:	8b 43 18             	mov    0x18(%ebx),%eax
80103d79:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103d7d:	8b 43 18             	mov    0x18(%ebx),%eax
80103d80:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d84:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d88:	8b 43 18             	mov    0x18(%ebx),%eax
80103d8b:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d8f:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d93:	8b 43 18             	mov    0x18(%ebx),%eax
80103d96:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d9d:	8b 43 18             	mov    0x18(%ebx),%eax
80103da0:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103da7:	8b 43 18             	mov    0x18(%ebx),%eax
80103daa:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103db1:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103db4:	6a 10                	push   $0x10
80103db6:	68 26 86 10 80       	push   $0x80108626
80103dbb:	50                   	push   %eax
80103dbc:	e8 ef 16 00 00       	call   801054b0 <safestrcpy>
  p->cwd = namei("/");
80103dc1:	c7 04 24 2f 86 10 80 	movl   $0x8010862f,(%esp)
80103dc8:	e8 d3 e2 ff ff       	call   801020a0 <namei>
80103dcd:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103dd0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dd7:	e8 54 14 00 00       	call   80105230 <acquire>
  p->state = RUNNABLE;
80103ddc:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->level = 0;
80103de3:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->tq = 2 * p->level + 2;
80103dea:	c7 83 84 00 00 00 02 	movl   $0x2,0x84(%ebx)
80103df1:	00 00 00 
  enqueue(&mlfq[0], p);
80103df4:	58                   	pop    %eax
80103df5:	5a                   	pop    %edx
80103df6:	53                   	push   %ebx
80103df7:	68 80 51 11 80       	push   $0x80115180
80103dfc:	e8 2f fc ff ff       	call   80103a30 <enqueue>
  release(&ptable.lock);
80103e01:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e08:	e8 c3 13 00 00       	call   801051d0 <release>
}
80103e0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e10:	83 c4 10             	add    $0x10,%esp
80103e13:	c9                   	leave  
80103e14:	c3                   	ret    
    panic("userinit: out of memory?");
80103e15:	83 ec 0c             	sub    $0xc,%esp
80103e18:	68 0d 86 10 80       	push   $0x8010860d
80103e1d:	e8 5e c5 ff ff       	call   80100380 <panic>
80103e22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e30 <growproc>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	56                   	push   %esi
80103e34:	53                   	push   %ebx
80103e35:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103e38:	e8 a3 12 00 00       	call   801050e0 <pushcli>
  c = mycpu();
80103e3d:	e8 ce fd ff ff       	call   80103c10 <mycpu>
  p = c->proc;
80103e42:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e48:	e8 e3 12 00 00       	call   80105130 <popcli>
  sz = curproc->sz;
80103e4d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103e4f:	85 f6                	test   %esi,%esi
80103e51:	7f 1d                	jg     80103e70 <growproc+0x40>
  } else if(n < 0){
80103e53:	75 3b                	jne    80103e90 <growproc+0x60>
  switchuvm(curproc);
80103e55:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103e58:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103e5a:	53                   	push   %ebx
80103e5b:	e8 20 3a 00 00       	call   80107880 <switchuvm>
  return 0;
80103e60:	83 c4 10             	add    $0x10,%esp
80103e63:	31 c0                	xor    %eax,%eax
}
80103e65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e68:	5b                   	pop    %ebx
80103e69:	5e                   	pop    %esi
80103e6a:	5d                   	pop    %ebp
80103e6b:	c3                   	ret    
80103e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e70:	83 ec 04             	sub    $0x4,%esp
80103e73:	01 c6                	add    %eax,%esi
80103e75:	56                   	push   %esi
80103e76:	50                   	push   %eax
80103e77:	ff 73 04             	push   0x4(%ebx)
80103e7a:	e8 81 3c 00 00       	call   80107b00 <allocuvm>
80103e7f:	83 c4 10             	add    $0x10,%esp
80103e82:	85 c0                	test   %eax,%eax
80103e84:	75 cf                	jne    80103e55 <growproc+0x25>
      return -1;
80103e86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e8b:	eb d8                	jmp    80103e65 <growproc+0x35>
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e90:	83 ec 04             	sub    $0x4,%esp
80103e93:	01 c6                	add    %eax,%esi
80103e95:	56                   	push   %esi
80103e96:	50                   	push   %eax
80103e97:	ff 73 04             	push   0x4(%ebx)
80103e9a:	e8 91 3d 00 00       	call   80107c30 <deallocuvm>
80103e9f:	83 c4 10             	add    $0x10,%esp
80103ea2:	85 c0                	test   %eax,%eax
80103ea4:	75 af                	jne    80103e55 <growproc+0x25>
80103ea6:	eb de                	jmp    80103e86 <growproc+0x56>
80103ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eaf:	90                   	nop

80103eb0 <fork>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	57                   	push   %edi
80103eb4:	56                   	push   %esi
80103eb5:	53                   	push   %ebx
80103eb6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103eb9:	e8 22 12 00 00       	call   801050e0 <pushcli>
  c = mycpu();
80103ebe:	e8 4d fd ff ff       	call   80103c10 <mycpu>
  p = c->proc;
80103ec3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ec9:	e8 62 12 00 00       	call   80105130 <popcli>
  if((np = allocproc()) == 0){
80103ece:	e8 dd f8 ff ff       	call   801037b0 <allocproc>
80103ed3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ed6:	85 c0                	test   %eax,%eax
80103ed8:	0f 84 d5 00 00 00    	je     80103fb3 <fork+0x103>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103ede:	83 ec 08             	sub    $0x8,%esp
80103ee1:	ff 33                	push   (%ebx)
80103ee3:	89 c7                	mov    %eax,%edi
80103ee5:	ff 73 04             	push   0x4(%ebx)
80103ee8:	e8 e3 3e 00 00       	call   80107dd0 <copyuvm>
80103eed:	83 c4 10             	add    $0x10,%esp
80103ef0:	89 47 04             	mov    %eax,0x4(%edi)
80103ef3:	85 c0                	test   %eax,%eax
80103ef5:	0f 84 bf 00 00 00    	je     80103fba <fork+0x10a>
  np->sz = curproc->sz;
80103efb:	8b 03                	mov    (%ebx),%eax
80103efd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103f00:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103f02:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103f05:	89 c8                	mov    %ecx,%eax
80103f07:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103f0a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103f0f:	8b 73 18             	mov    0x18(%ebx),%esi
80103f12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103f14:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103f16:	8b 40 18             	mov    0x18(%eax),%eax
80103f19:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103f20:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f24:	85 c0                	test   %eax,%eax
80103f26:	74 13                	je     80103f3b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f28:	83 ec 0c             	sub    $0xc,%esp
80103f2b:	50                   	push   %eax
80103f2c:	e8 6f cf ff ff       	call   80100ea0 <filedup>
80103f31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f34:	83 c4 10             	add    $0x10,%esp
80103f37:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103f3b:	83 c6 01             	add    $0x1,%esi
80103f3e:	83 fe 10             	cmp    $0x10,%esi
80103f41:	75 dd                	jne    80103f20 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103f43:	83 ec 0c             	sub    $0xc,%esp
80103f46:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f49:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103f4c:	e8 ff d7 ff ff       	call   80101750 <idup>
80103f51:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f54:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103f57:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f5a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103f5d:	6a 10                	push   $0x10
80103f5f:	53                   	push   %ebx
80103f60:	50                   	push   %eax
80103f61:	e8 4a 15 00 00       	call   801054b0 <safestrcpy>
  pid = np->pid;
80103f66:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103f69:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f70:	e8 bb 12 00 00       	call   80105230 <acquire>
  np->state = RUNNABLE;
80103f75:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  np->level = 0;
80103f7c:	c7 47 7c 00 00 00 00 	movl   $0x0,0x7c(%edi)
  np->tq = 2 * np->level + 2;
80103f83:	c7 87 84 00 00 00 02 	movl   $0x2,0x84(%edi)
80103f8a:	00 00 00 
  enqueue(&mlfq[0], np);
80103f8d:	58                   	pop    %eax
80103f8e:	5a                   	pop    %edx
80103f8f:	57                   	push   %edi
80103f90:	68 80 51 11 80       	push   $0x80115180
80103f95:	e8 96 fa ff ff       	call   80103a30 <enqueue>
  release(&ptable.lock);
80103f9a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fa1:	e8 2a 12 00 00       	call   801051d0 <release>
  return pid;
80103fa6:	83 c4 10             	add    $0x10,%esp
}
80103fa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fac:	89 d8                	mov    %ebx,%eax
80103fae:	5b                   	pop    %ebx
80103faf:	5e                   	pop    %esi
80103fb0:	5f                   	pop    %edi
80103fb1:	5d                   	pop    %ebp
80103fb2:	c3                   	ret    
    return -1;
80103fb3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103fb8:	eb ef                	jmp    80103fa9 <fork+0xf9>
    kfree(np->kstack);
80103fba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103fbd:	83 ec 0c             	sub    $0xc,%esp
80103fc0:	ff 73 08             	push   0x8(%ebx)
80103fc3:	e8 f8 e4 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103fc8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103fcf:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103fd2:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103fd9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103fde:	eb c9                	jmp    80103fa9 <fork+0xf9>

80103fe0 <findproc>:
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	57                   	push   %edi
80103fe4:	56                   	push   %esi
80103fe5:	53                   	push   %ebx
80103fe6:	83 ec 1c             	sub    $0x1c,%esp
80103fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cnt = q->size;
80103fec:	8b 8b 0c 01 00 00    	mov    0x10c(%ebx),%ecx
  while(q->size && cnt--){
80103ff2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80103ff5:	85 c9                	test   %ecx,%ecx
80103ff7:	0f 84 b5 00 00 00    	je     801040b2 <findproc+0xd2>
80103ffd:	89 cf                	mov    %ecx,%edi
80103fff:	e9 81 00 00 00       	jmp    80104085 <findproc+0xa5>
80104004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (q->level == 3){
80104008:	83 f9 03             	cmp    $0x3,%ecx
8010400b:	0f 84 c7 00 00 00    	je     801040d8 <findproc+0xf8>
    q->start = (q->start + 1) % (NPROC + 1);
80104011:	8b 83 04 01 00 00    	mov    0x104(%ebx),%eax
80104017:	83 c0 01             	add    $0x1,%eax
8010401a:	89 c2                	mov    %eax,%edx
8010401c:	b8 7f e0 07 7e       	mov    $0x7e07e07f,%eax
80104021:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104024:	f7 ea                	imul   %edx
80104026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104029:	c1 f8 1f             	sar    $0x1f,%eax
8010402c:	c1 fa 05             	sar    $0x5,%edx
8010402f:	29 c2                	sub    %eax,%edx
80104031:	89 d0                	mov    %edx,%eax
80104033:	c1 e0 06             	shl    $0x6,%eax
80104036:	01 d0                	add    %edx,%eax
80104038:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010403b:	29 c2                	sub    %eax,%edx
8010403d:	89 93 04 01 00 00    	mov    %edx,0x104(%ebx)
    q->front = q->heap[q->start];
80104043:	8b 04 93             	mov    (%ebx,%edx,4),%eax
  q->size = q->size - 1;
80104046:	83 ef 01             	sub    $0x1,%edi
    q->front = q->heap[1];
80104049:	89 83 14 01 00 00    	mov    %eax,0x114(%ebx)
  q->size = q->size - 1;
8010404f:	89 bb 0c 01 00 00    	mov    %edi,0x10c(%ebx)
    if(p->level != q->level)
80104055:	39 4e 7c             	cmp    %ecx,0x7c(%esi)
80104058:	75 21                	jne    8010407b <findproc+0x9b>
    if(p->yielded){
8010405a:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
80104060:	85 c0                	test   %eax,%eax
80104062:	75 5c                	jne    801040c0 <findproc+0xe0>
    if (p->state == SLEEPING)
80104064:	83 7e 0c 02          	cmpl   $0x2,0xc(%esi)
80104068:	0f 84 92 00 00 00    	je     80104100 <findproc+0x120>
      p->level = -1;
8010406e:	c7 46 7c ff ff ff ff 	movl   $0xffffffff,0x7c(%esi)
  while(q->size && cnt--){
80104075:	8b bb 0c 01 00 00    	mov    0x10c(%ebx),%edi
8010407b:	85 ff                	test   %edi,%edi
8010407d:	74 33                	je     801040b2 <findproc+0xd2>
8010407f:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
80104083:	74 2d                	je     801040b2 <findproc+0xd2>
    p = q->front;
80104085:	8b b3 14 01 00 00    	mov    0x114(%ebx),%esi
    if (p->state == RUNNABLE && p->level == q->level && p->yielded == 0) 
8010408b:	8b 8b 10 01 00 00    	mov    0x110(%ebx),%ecx
80104091:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
80104095:	0f 85 6d ff ff ff    	jne    80104008 <findproc+0x28>
8010409b:	39 4e 7c             	cmp    %ecx,0x7c(%esi)
8010409e:	0f 85 64 ff ff ff    	jne    80104008 <findproc+0x28>
801040a4:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
801040aa:	85 c0                	test   %eax,%eax
801040ac:	0f 85 56 ff ff ff    	jne    80104008 <findproc+0x28>
}
801040b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040b5:	5b                   	pop    %ebx
801040b6:	5e                   	pop    %esi
801040b7:	5f                   	pop    %edi
801040b8:	5d                   	pop    %ebp
801040b9:	c3                   	ret    
801040ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p->yielded = p->yielded - 1;
801040c0:	83 e8 01             	sub    $0x1,%eax
801040c3:	89 86 88 00 00 00    	mov    %eax,0x88(%esi)
  while(q->size && cnt--){
801040c9:	8b bb 0c 01 00 00    	mov    0x10c(%ebx),%edi
      continue;
801040cf:	eb aa                	jmp    8010407b <findproc+0x9b>
801040d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    q->heap[1] = q->heap[q->size];
801040d8:	8b 04 bb             	mov    (%ebx,%edi,4),%eax
801040db:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801040de:	89 43 04             	mov    %eax,0x4(%ebx)
    heapify(q, 1);
801040e1:	6a 01                	push   $0x1
801040e3:	53                   	push   %ebx
801040e4:	e8 f7 f9 ff ff       	call   80103ae0 <heapify>
    q->front = q->heap[1];
801040e9:	5a                   	pop    %edx
801040ea:	8b 43 04             	mov    0x4(%ebx),%eax
801040ed:	59                   	pop    %ecx
801040ee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801040f1:	e9 50 ff ff ff       	jmp    80104046 <findproc+0x66>
801040f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040fd:	8d 76 00             	lea    0x0(%esi),%esi
      enqueue(q, p);
80104100:	83 ec 08             	sub    $0x8,%esp
80104103:	56                   	push   %esi
80104104:	53                   	push   %ebx
80104105:	e8 26 f9 ff ff       	call   80103a30 <enqueue>
  while(q->size && cnt--){
8010410a:	8b bb 0c 01 00 00    	mov    0x10c(%ebx),%edi
80104110:	83 c4 10             	add    $0x10,%esp
80104113:	e9 63 ff ff ff       	jmp    8010407b <findproc+0x9b>
80104118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010411f:	90                   	nop

80104120 <scheduler>:
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	56                   	push   %esi
80104124:	53                   	push   %ebx
  struct cpu *c = mycpu();
80104125:	e8 e6 fa ff ff       	call   80103c10 <mycpu>
  c->proc = 0;
8010412a:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104131:	00 00 00 
80104134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104138:	fb                   	sti    
    acquire(&ptable.lock);
80104139:	83 ec 0c             	sub    $0xc,%esp
8010413c:	68 20 2d 11 80       	push   $0x80112d20
80104141:	e8 ea 10 00 00       	call   80105230 <acquire>
    if(monopoly){
80104146:	a1 54 50 11 80       	mov    0x80115054,%eax
8010414b:	83 c4 10             	add    $0x10,%esp
8010414e:	85 c0                	test   %eax,%eax
80104150:	75 66                	jne    801041b8 <scheduler+0x98>
{
80104152:	31 f6                	xor    %esi,%esi
      if (monopoly) break;
80104154:	85 c0                	test   %eax,%eax
80104156:	75 48                	jne    801041a0 <scheduler+0x80>
      findproc(&mlfq[qlv]);
80104158:	69 de 18 01 00 00    	imul   $0x118,%esi,%ebx
8010415e:	83 ec 0c             	sub    $0xc,%esp
80104161:	81 c3 80 51 11 80    	add    $0x80115180,%ebx
80104167:	53                   	push   %ebx
80104168:	e8 73 fe ff ff       	call   80103fe0 <findproc>
      if (mlfq[qlv].size){
8010416d:	8b 8b 0c 01 00 00    	mov    0x10c(%ebx),%ecx
80104173:	83 c4 10             	add    $0x10,%esp
80104176:	85 c9                	test   %ecx,%ecx
80104178:	74 0c                	je     80104186 <scheduler+0x66>
        p = mlfq[qlv].front;
8010417a:	8b 9b 14 01 00 00    	mov    0x114(%ebx),%ebx
        if (p->state == RUNNABLE){
80104180:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104184:	74 6a                	je     801041f0 <scheduler+0xd0>
    for(int qlv = 0; qlv <= 3; qlv ++){ 
80104186:	83 c6 01             	add    $0x1,%esi
80104189:	83 fe 04             	cmp    $0x4,%esi
8010418c:	74 12                	je     801041a0 <scheduler+0x80>
      if (monopoly) break;
8010418e:	a1 54 50 11 80       	mov    0x80115054,%eax
80104193:	85 c0                	test   %eax,%eax
80104195:	74 c1                	je     80104158 <scheduler+0x38>
80104197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010419e:	66 90                	xchg   %ax,%ax
    release(&ptable.lock);
801041a0:	83 ec 0c             	sub    $0xc,%esp
801041a3:	68 20 2d 11 80       	push   $0x80112d20
801041a8:	e8 23 10 00 00       	call   801051d0 <release>
    sti();
801041ad:	83 c4 10             	add    $0x10,%esp
801041b0:	eb 86                	jmp    80104138 <scheduler+0x18>
801041b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      findproc(&moq);
801041b8:	83 ec 0c             	sub    $0xc,%esp
801041bb:	68 60 50 11 80       	push   $0x80115060
801041c0:	e8 1b fe ff ff       	call   80103fe0 <findproc>
      if (moq.size){
801041c5:	8b 1d 6c 51 11 80    	mov    0x8011516c,%ebx
801041cb:	83 c4 10             	add    $0x10,%esp
801041ce:	85 db                	test   %ebx,%ebx
801041d0:	0f 84 aa 00 00 00    	je     80104280 <scheduler+0x160>
        p = moq.front;
801041d6:	8b 1d 74 51 11 80    	mov    0x80115174,%ebx
        if (p->state == RUNNABLE){
801041dc:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801041e0:	74 52                	je     80104234 <scheduler+0x114>
      if (monopoly) break;
801041e2:	a1 54 50 11 80       	mov    0x80115054,%eax
801041e7:	e9 66 ff ff ff       	jmp    80104152 <scheduler+0x32>
801041ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct cpu *c = mycpu();
801041f0:	e8 1b fa ff ff       	call   80103c10 <mycpu>
  switchuvm(p);
801041f5:	83 ec 0c             	sub    $0xc,%esp
  c->proc = p;
801041f8:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
  struct cpu *c = mycpu();
801041fe:	89 c6                	mov    %eax,%esi
  switchuvm(p);
80104200:	53                   	push   %ebx
80104201:	e8 7a 36 00 00       	call   80107880 <switchuvm>
  p->state = RUNNING;
80104206:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
  swtch(&(c->scheduler), p->context);
8010420d:	58                   	pop    %eax
8010420e:	8d 46 04             	lea    0x4(%esi),%eax
80104211:	5a                   	pop    %edx
80104212:	ff 73 1c             	push   0x1c(%ebx)
80104215:	50                   	push   %eax
80104216:	e8 f0 12 00 00       	call   8010550b <swtch>
  switchkvm();
8010421b:	e8 50 36 00 00       	call   80107870 <switchkvm>
  c->proc = 0;
80104220:	83 c4 10             	add    $0x10,%esp
80104223:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
8010422a:	00 00 00 
    for(int qlv = 0; qlv <= 3; qlv ++){ 
8010422d:	31 f6                	xor    %esi,%esi
8010422f:	e9 5a ff ff ff       	jmp    8010418e <scheduler+0x6e>
  struct cpu *c = mycpu();
80104234:	e8 d7 f9 ff ff       	call   80103c10 <mycpu>
  switchuvm(p);
80104239:	83 ec 0c             	sub    $0xc,%esp
  c->proc = p;
8010423c:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
  struct cpu *c = mycpu();
80104242:	89 c6                	mov    %eax,%esi
  switchuvm(p);
80104244:	53                   	push   %ebx
80104245:	e8 36 36 00 00       	call   80107880 <switchuvm>
  p->state = RUNNING;
8010424a:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
  swtch(&(c->scheduler), p->context);
80104251:	58                   	pop    %eax
80104252:	8d 46 04             	lea    0x4(%esi),%eax
80104255:	5a                   	pop    %edx
80104256:	ff 73 1c             	push   0x1c(%ebx)
80104259:	50                   	push   %eax
8010425a:	e8 ac 12 00 00       	call   8010550b <swtch>
  switchkvm();
8010425f:	e8 0c 36 00 00       	call   80107870 <switchkvm>
      if(!moq.size)
80104264:	83 c4 10             	add    $0x10,%esp
  c->proc = 0;
80104267:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
8010426e:	00 00 00 
      if(!moq.size)
80104271:	8b 0d 6c 51 11 80    	mov    0x8011516c,%ecx
80104277:	85 c9                	test   %ecx,%ecx
80104279:	0f 85 63 ff ff ff    	jne    801041e2 <scheduler+0xc2>
8010427f:	90                   	nop


static void
unmonopolize1()
{ 
  monopoly = 0;
80104280:	c7 05 54 50 11 80 00 	movl   $0x0,0x80115054
80104287:	00 00 00 

  acquire(&tickslock);
8010428a:	83 ec 0c             	sub    $0xc,%esp
8010428d:	68 20 56 11 80       	push   $0x80115620
80104292:	e8 99 0f 00 00       	call   80105230 <acquire>
  ticks = 0;
  release(&tickslock);
80104297:	c7 04 24 20 56 11 80 	movl   $0x80115620,(%esp)
  ticks = 0;
8010429e:	c7 05 00 56 11 80 00 	movl   $0x0,0x80115600
801042a5:	00 00 00 
  release(&tickslock);
801042a8:	e8 23 0f 00 00       	call   801051d0 <release>
      if (monopoly) break;
801042ad:	a1 54 50 11 80       	mov    0x80115054,%eax
}
801042b2:	83 c4 10             	add    $0x10,%esp
801042b5:	e9 98 fe ff ff       	jmp    80104152 <scheduler+0x32>
801042ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042c0 <schedule>:
{ 
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	56                   	push   %esi
801042c4:	53                   	push   %ebx
801042c5:	8b 75 08             	mov    0x8(%ebp),%esi
  struct cpu *c = mycpu();
801042c8:	e8 43 f9 ff ff       	call   80103c10 <mycpu>
  switchuvm(p);
801042cd:	83 ec 0c             	sub    $0xc,%esp
  c->proc = p;
801042d0:	89 b0 ac 00 00 00    	mov    %esi,0xac(%eax)
  struct cpu *c = mycpu();
801042d6:	89 c3                	mov    %eax,%ebx
  switchuvm(p);
801042d8:	56                   	push   %esi
801042d9:	e8 a2 35 00 00       	call   80107880 <switchuvm>
  p->state = RUNNING;
801042de:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
  swtch(&(c->scheduler), p->context);
801042e5:	58                   	pop    %eax
801042e6:	8d 43 04             	lea    0x4(%ebx),%eax
801042e9:	5a                   	pop    %edx
801042ea:	ff 76 1c             	push   0x1c(%esi)
801042ed:	50                   	push   %eax
801042ee:	e8 18 12 00 00       	call   8010550b <swtch>
  switchkvm();
801042f3:	e8 78 35 00 00       	call   80107870 <switchkvm>
}
801042f8:	83 c4 10             	add    $0x10,%esp
  c->proc = 0;
801042fb:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104302:	00 00 00 
}
80104305:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104308:	5b                   	pop    %ebx
80104309:	5e                   	pop    %esi
8010430a:	5d                   	pop    %ebp
8010430b:	c3                   	ret    
8010430c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104310 <sched>:
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	56                   	push   %esi
80104314:	53                   	push   %ebx
  pushcli();
80104315:	e8 c6 0d 00 00       	call   801050e0 <pushcli>
  c = mycpu();
8010431a:	e8 f1 f8 ff ff       	call   80103c10 <mycpu>
  p = c->proc;
8010431f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104325:	e8 06 0e 00 00       	call   80105130 <popcli>
  if(!holding(&ptable.lock))
8010432a:	83 ec 0c             	sub    $0xc,%esp
8010432d:	68 20 2d 11 80       	push   $0x80112d20
80104332:	e8 59 0e 00 00       	call   80105190 <holding>
80104337:	83 c4 10             	add    $0x10,%esp
8010433a:	85 c0                	test   %eax,%eax
8010433c:	74 4f                	je     8010438d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010433e:	e8 cd f8 ff ff       	call   80103c10 <mycpu>
80104343:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010434a:	75 68                	jne    801043b4 <sched+0xa4>
  if(p->state == RUNNING)
8010434c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104350:	74 55                	je     801043a7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104352:	9c                   	pushf  
80104353:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104354:	f6 c4 02             	test   $0x2,%ah
80104357:	75 41                	jne    8010439a <sched+0x8a>
  intena = mycpu()->intena;
80104359:	e8 b2 f8 ff ff       	call   80103c10 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010435e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104361:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104367:	e8 a4 f8 ff ff       	call   80103c10 <mycpu>
8010436c:	83 ec 08             	sub    $0x8,%esp
8010436f:	ff 70 04             	push   0x4(%eax)
80104372:	53                   	push   %ebx
80104373:	e8 93 11 00 00       	call   8010550b <swtch>
  mycpu()->intena = intena;
80104378:	e8 93 f8 ff ff       	call   80103c10 <mycpu>
}
8010437d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104380:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104386:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104389:	5b                   	pop    %ebx
8010438a:	5e                   	pop    %esi
8010438b:	5d                   	pop    %ebp
8010438c:	c3                   	ret    
    panic("sched ptable.lock");
8010438d:	83 ec 0c             	sub    $0xc,%esp
80104390:	68 31 86 10 80       	push   $0x80108631
80104395:	e8 e6 bf ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010439a:	83 ec 0c             	sub    $0xc,%esp
8010439d:	68 5d 86 10 80       	push   $0x8010865d
801043a2:	e8 d9 bf ff ff       	call   80100380 <panic>
    panic("sched running");
801043a7:	83 ec 0c             	sub    $0xc,%esp
801043aa:	68 4f 86 10 80       	push   $0x8010864f
801043af:	e8 cc bf ff ff       	call   80100380 <panic>
    panic("sched locks");
801043b4:	83 ec 0c             	sub    $0xc,%esp
801043b7:	68 43 86 10 80       	push   $0x80108643
801043bc:	e8 bf bf ff ff       	call   80100380 <panic>
801043c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043cf:	90                   	nop

801043d0 <exit>:
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	57                   	push   %edi
801043d4:	56                   	push   %esi
801043d5:	53                   	push   %ebx
801043d6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801043d9:	e8 b2 f8 ff ff       	call   80103c90 <myproc>
  if(curproc == initproc)
801043de:	39 05 e0 55 11 80    	cmp    %eax,0x801155e0
801043e4:	0f 84 07 01 00 00    	je     801044f1 <exit+0x121>
801043ea:	89 c3                	mov    %eax,%ebx
801043ec:	8d 70 28             	lea    0x28(%eax),%esi
801043ef:	8d 78 68             	lea    0x68(%eax),%edi
801043f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801043f8:	8b 06                	mov    (%esi),%eax
801043fa:	85 c0                	test   %eax,%eax
801043fc:	74 12                	je     80104410 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801043fe:	83 ec 0c             	sub    $0xc,%esp
80104401:	50                   	push   %eax
80104402:	e8 e9 ca ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80104407:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010440d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104410:	83 c6 04             	add    $0x4,%esi
80104413:	39 f7                	cmp    %esi,%edi
80104415:	75 e1                	jne    801043f8 <exit+0x28>
  begin_op();
80104417:	e8 44 e9 ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
8010441c:	83 ec 0c             	sub    $0xc,%esp
8010441f:	ff 73 68             	push   0x68(%ebx)
80104422:	e8 89 d4 ff ff       	call   801018b0 <iput>
  end_op();
80104427:	e8 a4 e9 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
8010442c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104433:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010443a:	e8 f1 0d 00 00       	call   80105230 <acquire>
  wakeup1(curproc->parent);
8010443f:	8b 53 14             	mov    0x14(%ebx),%edx
80104442:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104445:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010444a:	eb 10                	jmp    8010445c <exit+0x8c>
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104450:	05 8c 00 00 00       	add    $0x8c,%eax
80104455:	3d 54 50 11 80       	cmp    $0x80115054,%eax
8010445a:	74 1e                	je     8010447a <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
8010445c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104460:	75 ee                	jne    80104450 <exit+0x80>
80104462:	3b 50 20             	cmp    0x20(%eax),%edx
80104465:	75 e9                	jne    80104450 <exit+0x80>
      p->state = RUNNABLE;
80104467:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010446e:	05 8c 00 00 00       	add    $0x8c,%eax
80104473:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80104478:	75 e2                	jne    8010445c <exit+0x8c>
      p->parent = initproc;
8010447a:	8b 0d e0 55 11 80    	mov    0x801155e0,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104480:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80104485:	eb 17                	jmp    8010449e <exit+0xce>
80104487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010448e:	66 90                	xchg   %ax,%ax
80104490:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80104496:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
8010449c:	74 3a                	je     801044d8 <exit+0x108>
    if(p->parent == curproc){
8010449e:	39 5a 14             	cmp    %ebx,0x14(%edx)
801044a1:	75 ed                	jne    80104490 <exit+0xc0>
      if(p->state == ZOMBIE)
801044a3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801044a7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801044aa:	75 e4                	jne    80104490 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044ac:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801044b1:	eb 11                	jmp    801044c4 <exit+0xf4>
801044b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044b7:	90                   	nop
801044b8:	05 8c 00 00 00       	add    $0x8c,%eax
801044bd:	3d 54 50 11 80       	cmp    $0x80115054,%eax
801044c2:	74 cc                	je     80104490 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801044c4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044c8:	75 ee                	jne    801044b8 <exit+0xe8>
801044ca:	3b 48 20             	cmp    0x20(%eax),%ecx
801044cd:	75 e9                	jne    801044b8 <exit+0xe8>
      p->state = RUNNABLE;
801044cf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801044d6:	eb e0                	jmp    801044b8 <exit+0xe8>
  curproc->state = ZOMBIE;
801044d8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801044df:	e8 2c fe ff ff       	call   80104310 <sched>
  panic("zombie exit");
801044e4:	83 ec 0c             	sub    $0xc,%esp
801044e7:	68 7e 86 10 80       	push   $0x8010867e
801044ec:	e8 8f be ff ff       	call   80100380 <panic>
    panic("init exiting");
801044f1:	83 ec 0c             	sub    $0xc,%esp
801044f4:	68 71 86 10 80       	push   $0x80108671
801044f9:	e8 82 be ff ff       	call   80100380 <panic>
801044fe:	66 90                	xchg   %ax,%ax

80104500 <yield1>:
{ 
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	53                   	push   %ebx
80104504:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104507:	e8 d4 0b 00 00       	call   801050e0 <pushcli>
  c = mycpu();
8010450c:	e8 ff f6 ff ff       	call   80103c10 <mycpu>
  p = c->proc;
80104511:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104517:	e8 14 0c 00 00       	call   80105130 <popcli>
  level = p->level;
8010451c:	8b 43 7c             	mov    0x7c(%ebx),%eax
  if (level == 0){
8010451f:	85 c0                	test   %eax,%eax
80104521:	75 4d                	jne    80104570 <yield1+0x70>
    if ((p->pid) % 2) p->level = 1;
80104523:	8b 53 10             	mov    0x10(%ebx),%edx
80104526:	b8 02 00 00 00       	mov    $0x2,%eax
    enqueue(&mlfq[p->level], p);
8010452b:	83 ec 08             	sub    $0x8,%esp
    if ((p->pid) % 2) p->level = 1;
8010452e:	83 e2 01             	and    $0x1,%edx
80104531:	29 d0                	sub    %edx,%eax
80104533:	89 43 7c             	mov    %eax,0x7c(%ebx)
    enqueue(&mlfq[p->level], p);
80104536:	69 c0 18 01 00 00    	imul   $0x118,%eax,%eax
8010453c:	53                   	push   %ebx
8010453d:	05 80 51 11 80       	add    $0x80115180,%eax
80104542:	50                   	push   %eax
80104543:	e8 e8 f4 ff ff       	call   80103a30 <enqueue>
  p->tq = 2 * (p->level) + 2;
80104548:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010454b:	83 c4 10             	add    $0x10,%esp
8010454e:	8d 44 00 02          	lea    0x2(%eax,%eax,1),%eax
  p->state = RUNNABLE;
80104552:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->tq = 2 * (p->level) + 2;
80104559:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
}
8010455f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104562:	c9                   	leave  
  sched();
80104563:	e9 a8 fd ff ff       	jmp    80104310 <sched>
80104568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010456f:	90                   	nop
  else if (level == 1 || level == 2){
80104570:	8d 50 ff             	lea    -0x1(%eax),%edx
80104573:	83 fa 01             	cmp    $0x1,%edx
80104576:	76 38                	jbe    801045b0 <yield1+0xb0>
    if (p->priority > 0){
80104578:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
8010457e:	85 d2                	test   %edx,%edx
80104580:	7e cc                	jle    8010454e <yield1+0x4e>
      heapify(&mlfq[level], 1);
80104582:	69 c0 18 01 00 00    	imul   $0x118,%eax,%eax
80104588:	83 ec 08             	sub    $0x8,%esp
      p->priority = p->priority - 1;
8010458b:	83 ea 01             	sub    $0x1,%edx
8010458e:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
      heapify(&mlfq[level], 1);
80104594:	6a 01                	push   $0x1
80104596:	05 80 51 11 80       	add    $0x80115180,%eax
8010459b:	50                   	push   %eax
8010459c:	e8 3f f5 ff ff       	call   80103ae0 <heapify>
  p->tq = 2 * (p->level) + 2;
801045a1:	8b 43 7c             	mov    0x7c(%ebx),%eax
801045a4:	83 c4 10             	add    $0x10,%esp
801045a7:	eb a5                	jmp    8010454e <yield1+0x4e>
801045a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    enqueue(&mlfq[p->level], p);
801045b0:	83 ec 08             	sub    $0x8,%esp
    p->level = 3;
801045b3:	c7 43 7c 03 00 00 00 	movl   $0x3,0x7c(%ebx)
    enqueue(&mlfq[p->level], p);
801045ba:	53                   	push   %ebx
801045bb:	68 c8 54 11 80       	push   $0x801154c8
801045c0:	e8 6b f4 ff ff       	call   80103a30 <enqueue>
  p->tq = 2 * (p->level) + 2;
801045c5:	8b 43 7c             	mov    0x7c(%ebx),%eax
801045c8:	83 c4 10             	add    $0x10,%esp
801045cb:	eb 81                	jmp    8010454e <yield1+0x4e>
801045cd:	8d 76 00             	lea    0x0(%esi),%esi

801045d0 <yield2>:
{ 
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801045d7:	e8 04 0b 00 00       	call   801050e0 <pushcli>
  c = mycpu();
801045dc:	e8 2f f6 ff ff       	call   80103c10 <mycpu>
  p = c->proc;
801045e1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045e7:	e8 44 0b 00 00       	call   80105130 <popcli>
  if (p->level == 99)
801045ec:	8b 43 7c             	mov    0x7c(%ebx),%eax
  p->yielded = p->yielded + 1;
801045ef:	83 83 88 00 00 00 01 	addl   $0x1,0x88(%ebx)
  p->state = RUNNABLE;
801045f6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  if (p->level == 99)
801045fd:	83 f8 63             	cmp    $0x63,%eax
80104600:	74 26                	je     80104628 <yield2+0x58>
    enqueue(&mlfq[p->level], p);
80104602:	69 c0 18 01 00 00    	imul   $0x118,%eax,%eax
80104608:	83 ec 08             	sub    $0x8,%esp
8010460b:	53                   	push   %ebx
8010460c:	05 80 51 11 80       	add    $0x80115180,%eax
80104611:	50                   	push   %eax
80104612:	e8 19 f4 ff ff       	call   80103a30 <enqueue>
}
80104617:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    enqueue(&mlfq[p->level], p);
8010461a:	83 c4 10             	add    $0x10,%esp
}
8010461d:	c9                   	leave  
  sched();
8010461e:	e9 ed fc ff ff       	jmp    80104310 <sched>
80104623:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104627:	90                   	nop
    enqueue(&moq, p);
80104628:	83 ec 08             	sub    $0x8,%esp
8010462b:	53                   	push   %ebx
8010462c:	68 60 50 11 80       	push   $0x80115060
80104631:	e8 fa f3 ff ff       	call   80103a30 <enqueue>
}
80104636:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104639:	83 c4 10             	add    $0x10,%esp
8010463c:	c9                   	leave  
  sched();
8010463d:	e9 ce fc ff ff       	jmp    80104310 <sched>
80104642:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104650 <wait>:
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
  pushcli();
80104655:	e8 86 0a 00 00       	call   801050e0 <pushcli>
  c = mycpu();
8010465a:	e8 b1 f5 ff ff       	call   80103c10 <mycpu>
  p = c->proc;
8010465f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104665:	e8 c6 0a 00 00       	call   80105130 <popcli>
  acquire(&ptable.lock);
8010466a:	83 ec 0c             	sub    $0xc,%esp
8010466d:	68 20 2d 11 80       	push   $0x80112d20
80104672:	e8 b9 0b 00 00       	call   80105230 <acquire>
80104677:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010467a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010467c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104681:	eb 13                	jmp    80104696 <wait+0x46>
80104683:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104687:	90                   	nop
80104688:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
8010468e:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80104694:	74 1e                	je     801046b4 <wait+0x64>
      if(p->parent != curproc)
80104696:	39 73 14             	cmp    %esi,0x14(%ebx)
80104699:	75 ed                	jne    80104688 <wait+0x38>
      if(p->state == ZOMBIE){
8010469b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010469f:	74 5f                	je     80104700 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046a1:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      havekids = 1;
801046a7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046ac:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
801046b2:	75 e2                	jne    80104696 <wait+0x46>
    if(!havekids || curproc->killed){
801046b4:	85 c0                	test   %eax,%eax
801046b6:	0f 84 9a 00 00 00    	je     80104756 <wait+0x106>
801046bc:	8b 46 24             	mov    0x24(%esi),%eax
801046bf:	85 c0                	test   %eax,%eax
801046c1:	0f 85 8f 00 00 00    	jne    80104756 <wait+0x106>
  pushcli();
801046c7:	e8 14 0a 00 00       	call   801050e0 <pushcli>
  c = mycpu();
801046cc:	e8 3f f5 ff ff       	call   80103c10 <mycpu>
  p = c->proc;
801046d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046d7:	e8 54 0a 00 00       	call   80105130 <popcli>
  if(p == 0)
801046dc:	85 db                	test   %ebx,%ebx
801046de:	0f 84 89 00 00 00    	je     8010476d <wait+0x11d>
  p->chan = chan;
801046e4:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801046e7:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801046ee:	e8 1d fc ff ff       	call   80104310 <sched>
  p->chan = 0;
801046f3:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801046fa:	e9 7b ff ff ff       	jmp    8010467a <wait+0x2a>
801046ff:	90                   	nop
        kfree(p->kstack);
80104700:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104703:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104706:	ff 73 08             	push   0x8(%ebx)
80104709:	e8 b2 dd ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010470e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104715:	5a                   	pop    %edx
80104716:	ff 73 04             	push   0x4(%ebx)
80104719:	e8 42 35 00 00       	call   80107c60 <freevm>
        p->pid = 0;
8010471e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104725:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010472c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104730:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104737:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010473e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104745:	e8 86 0a 00 00       	call   801051d0 <release>
        return pid;
8010474a:	83 c4 10             	add    $0x10,%esp
}
8010474d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104750:	89 f0                	mov    %esi,%eax
80104752:	5b                   	pop    %ebx
80104753:	5e                   	pop    %esi
80104754:	5d                   	pop    %ebp
80104755:	c3                   	ret    
      release(&ptable.lock);
80104756:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104759:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010475e:	68 20 2d 11 80       	push   $0x80112d20
80104763:	e8 68 0a 00 00       	call   801051d0 <release>
      return -1;
80104768:	83 c4 10             	add    $0x10,%esp
8010476b:	eb e0                	jmp    8010474d <wait+0xfd>
    panic("sleep");
8010476d:	83 ec 0c             	sub    $0xc,%esp
80104770:	68 8a 86 10 80       	push   $0x8010868a
80104775:	e8 06 bc ff ff       	call   80100380 <panic>
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104780 <yield>:
{ 
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	53                   	push   %ebx
80104784:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104787:	68 20 2d 11 80       	push   $0x80112d20
8010478c:	e8 9f 0a 00 00       	call   80105230 <acquire>
  pushcli();
80104791:	e8 4a 09 00 00       	call   801050e0 <pushcli>
  c = mycpu();
80104796:	e8 75 f4 ff ff       	call   80103c10 <mycpu>
  p = c->proc;
8010479b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047a1:	e8 8a 09 00 00       	call   80105130 <popcli>
  if (p->level != 99 && p->tq == 0)
801047a6:	83 c4 10             	add    $0x10,%esp
801047a9:	83 7b 7c 63          	cmpl   $0x63,0x7c(%ebx)
801047ad:	74 0a                	je     801047b9 <yield+0x39>
801047af:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
801047b5:	85 c0                	test   %eax,%eax
801047b7:	74 1f                	je     801047d8 <yield+0x58>
    yield2();
801047b9:	e8 12 fe ff ff       	call   801045d0 <yield2>
  release(&ptable.lock);
801047be:	83 ec 0c             	sub    $0xc,%esp
801047c1:	68 20 2d 11 80       	push   $0x80112d20
801047c6:	e8 05 0a 00 00       	call   801051d0 <release>
}
801047cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047ce:	83 c4 10             	add    $0x10,%esp
801047d1:	c9                   	leave  
801047d2:	c3                   	ret    
801047d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047d7:	90                   	nop
    yield1();
801047d8:	e8 23 fd ff ff       	call   80104500 <yield1>
801047dd:	eb df                	jmp    801047be <yield+0x3e>
801047df:	90                   	nop

801047e0 <sleep>:
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	57                   	push   %edi
801047e4:	56                   	push   %esi
801047e5:	53                   	push   %ebx
801047e6:	83 ec 0c             	sub    $0xc,%esp
801047e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801047ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801047ef:	e8 ec 08 00 00       	call   801050e0 <pushcli>
  c = mycpu();
801047f4:	e8 17 f4 ff ff       	call   80103c10 <mycpu>
  p = c->proc;
801047f9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047ff:	e8 2c 09 00 00       	call   80105130 <popcli>
  if(p == 0)
80104804:	85 db                	test   %ebx,%ebx
80104806:	0f 84 87 00 00 00    	je     80104893 <sleep+0xb3>
  if(lk == 0)
8010480c:	85 f6                	test   %esi,%esi
8010480e:	74 76                	je     80104886 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104810:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104816:	74 50                	je     80104868 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104818:	83 ec 0c             	sub    $0xc,%esp
8010481b:	68 20 2d 11 80       	push   $0x80112d20
80104820:	e8 0b 0a 00 00       	call   80105230 <acquire>
    release(lk);
80104825:	89 34 24             	mov    %esi,(%esp)
80104828:	e8 a3 09 00 00       	call   801051d0 <release>
  p->chan = chan;
8010482d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104830:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104837:	e8 d4 fa ff ff       	call   80104310 <sched>
  p->chan = 0;
8010483c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104843:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010484a:	e8 81 09 00 00       	call   801051d0 <release>
    acquire(lk);
8010484f:	89 75 08             	mov    %esi,0x8(%ebp)
80104852:	83 c4 10             	add    $0x10,%esp
}
80104855:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104858:	5b                   	pop    %ebx
80104859:	5e                   	pop    %esi
8010485a:	5f                   	pop    %edi
8010485b:	5d                   	pop    %ebp
    acquire(lk);
8010485c:	e9 cf 09 00 00       	jmp    80105230 <acquire>
80104861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104868:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010486b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104872:	e8 99 fa ff ff       	call   80104310 <sched>
  p->chan = 0;
80104877:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010487e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104881:	5b                   	pop    %ebx
80104882:	5e                   	pop    %esi
80104883:	5f                   	pop    %edi
80104884:	5d                   	pop    %ebp
80104885:	c3                   	ret    
    panic("sleep without lk");
80104886:	83 ec 0c             	sub    $0xc,%esp
80104889:	68 90 86 10 80       	push   $0x80108690
8010488e:	e8 ed ba ff ff       	call   80100380 <panic>
    panic("sleep");
80104893:	83 ec 0c             	sub    $0xc,%esp
80104896:	68 8a 86 10 80       	push   $0x8010868a
8010489b:	e8 e0 ba ff ff       	call   80100380 <panic>

801048a0 <wakeup>:
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	53                   	push   %ebx
801048a4:	83 ec 10             	sub    $0x10,%esp
801048a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801048aa:	68 20 2d 11 80       	push   $0x80112d20
801048af:	e8 7c 09 00 00       	call   80105230 <acquire>
801048b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048b7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801048bc:	eb 0e                	jmp    801048cc <wakeup+0x2c>
801048be:	66 90                	xchg   %ax,%ax
801048c0:	05 8c 00 00 00       	add    $0x8c,%eax
801048c5:	3d 54 50 11 80       	cmp    $0x80115054,%eax
801048ca:	74 1e                	je     801048ea <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801048cc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801048d0:	75 ee                	jne    801048c0 <wakeup+0x20>
801048d2:	3b 58 20             	cmp    0x20(%eax),%ebx
801048d5:	75 e9                	jne    801048c0 <wakeup+0x20>
      p->state = RUNNABLE;
801048d7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048de:	05 8c 00 00 00       	add    $0x8c,%eax
801048e3:	3d 54 50 11 80       	cmp    $0x80115054,%eax
801048e8:	75 e2                	jne    801048cc <wakeup+0x2c>
  release(&ptable.lock);
801048ea:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801048f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048f4:	c9                   	leave  
  release(&ptable.lock);
801048f5:	e9 d6 08 00 00       	jmp    801051d0 <release>
801048fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104900 <kill>:
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	53                   	push   %ebx
80104904:	83 ec 10             	sub    $0x10,%esp
80104907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010490a:	68 20 2d 11 80       	push   $0x80112d20
8010490f:	e8 1c 09 00 00       	call   80105230 <acquire>
80104914:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104917:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010491c:	eb 0e                	jmp    8010492c <kill+0x2c>
8010491e:	66 90                	xchg   %ax,%ax
80104920:	05 8c 00 00 00       	add    $0x8c,%eax
80104925:	3d 54 50 11 80       	cmp    $0x80115054,%eax
8010492a:	74 34                	je     80104960 <kill+0x60>
    if(p->pid == pid){
8010492c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010492f:	75 ef                	jne    80104920 <kill+0x20>
      if(p->state == SLEEPING)
80104931:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104935:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010493c:	75 07                	jne    80104945 <kill+0x45>
        p->state = RUNNABLE;
8010493e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104945:	83 ec 0c             	sub    $0xc,%esp
80104948:	68 20 2d 11 80       	push   $0x80112d20
8010494d:	e8 7e 08 00 00       	call   801051d0 <release>
}
80104952:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104955:	83 c4 10             	add    $0x10,%esp
80104958:	31 c0                	xor    %eax,%eax
}
8010495a:	c9                   	leave  
8010495b:	c3                   	ret    
8010495c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104960:	83 ec 0c             	sub    $0xc,%esp
80104963:	68 20 2d 11 80       	push   $0x80112d20
80104968:	e8 63 08 00 00       	call   801051d0 <release>
}
8010496d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104970:	83 c4 10             	add    $0x10,%esp
80104973:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104978:	c9                   	leave  
80104979:	c3                   	ret    
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104980 <procdump>:
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	57                   	push   %edi
80104984:	56                   	push   %esi
80104985:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104988:	53                   	push   %ebx
80104989:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010498e:	83 ec 3c             	sub    $0x3c,%esp
80104991:	eb 27                	jmp    801049ba <procdump+0x3a>
80104993:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104997:	90                   	nop
    cprintf("\n");
80104998:	83 ec 0c             	sub    $0xc,%esp
8010499b:	68 f4 85 10 80       	push   $0x801085f4
801049a0:	e8 fb bc ff ff       	call   801006a0 <cprintf>
801049a5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049a8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801049ae:	81 fb c0 50 11 80    	cmp    $0x801150c0,%ebx
801049b4:	0f 84 7e 00 00 00    	je     80104a38 <procdump+0xb8>
    if(p->state == UNUSED)
801049ba:	8b 43 a0             	mov    -0x60(%ebx),%eax
801049bd:	85 c0                	test   %eax,%eax
801049bf:	74 e7                	je     801049a8 <procdump+0x28>
      state = "???";
801049c1:	ba a1 86 10 80       	mov    $0x801086a1,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801049c6:	83 f8 05             	cmp    $0x5,%eax
801049c9:	77 11                	ja     801049dc <procdump+0x5c>
801049cb:	8b 14 85 24 87 10 80 	mov    -0x7fef78dc(,%eax,4),%edx
      state = "???";
801049d2:	b8 a1 86 10 80       	mov    $0x801086a1,%eax
801049d7:	85 d2                	test   %edx,%edx
801049d9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801049dc:	53                   	push   %ebx
801049dd:	52                   	push   %edx
801049de:	ff 73 a4             	push   -0x5c(%ebx)
801049e1:	68 a5 86 10 80       	push   $0x801086a5
801049e6:	e8 b5 bc ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801049eb:	83 c4 10             	add    $0x10,%esp
801049ee:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801049f2:	75 a4                	jne    80104998 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801049f4:	83 ec 08             	sub    $0x8,%esp
801049f7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801049fa:	8d 7d c0             	lea    -0x40(%ebp),%edi
801049fd:	50                   	push   %eax
801049fe:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104a01:	8b 40 0c             	mov    0xc(%eax),%eax
80104a04:	83 c0 08             	add    $0x8,%eax
80104a07:	50                   	push   %eax
80104a08:	e8 73 06 00 00       	call   80105080 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a0d:	83 c4 10             	add    $0x10,%esp
80104a10:	8b 17                	mov    (%edi),%edx
80104a12:	85 d2                	test   %edx,%edx
80104a14:	74 82                	je     80104998 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104a16:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104a19:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104a1c:	52                   	push   %edx
80104a1d:	68 e1 80 10 80       	push   $0x801080e1
80104a22:	e8 79 bc ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a27:	83 c4 10             	add    $0x10,%esp
80104a2a:	39 fe                	cmp    %edi,%esi
80104a2c:	75 e2                	jne    80104a10 <procdump+0x90>
80104a2e:	e9 65 ff ff ff       	jmp    80104998 <procdump+0x18>
80104a33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a37:	90                   	nop
}
80104a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a3b:	5b                   	pop    %ebx
80104a3c:	5e                   	pop    %esi
80104a3d:	5f                   	pop    %edi
80104a3e:	5d                   	pop    %ebp
80104a3f:	c3                   	ret    

80104a40 <proctimer>:
{ 
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104a47:	68 20 2d 11 80       	push   $0x80112d20
80104a4c:	e8 df 07 00 00       	call   80105230 <acquire>
  pushcli();
80104a51:	e8 8a 06 00 00       	call   801050e0 <pushcli>
  c = mycpu();
80104a56:	e8 b5 f1 ff ff       	call   80103c10 <mycpu>
  p = c->proc;
80104a5b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a61:	e8 ca 06 00 00       	call   80105130 <popcli>
  if (p->level == 99){
80104a66:	83 c4 10             	add    $0x10,%esp
80104a69:	83 7b 7c 63          	cmpl   $0x63,0x7c(%ebx)
80104a6d:	74 09                	je     80104a78 <proctimer+0x38>
    p->tq = p->tq - 1;
80104a6f:	83 ab 84 00 00 00 01 	subl   $0x1,0x84(%ebx)
    if(p->tq == 0)
80104a76:	74 18                	je     80104a90 <proctimer+0x50>
    release(&ptable.lock);
80104a78:	83 ec 0c             	sub    $0xc,%esp
80104a7b:	68 20 2d 11 80       	push   $0x80112d20
80104a80:	e8 4b 07 00 00       	call   801051d0 <release>
}
80104a85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a88:	c9                   	leave  
80104a89:	c3                   	ret    
80104a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      yield1();
80104a90:	e8 6b fa ff ff       	call   80104500 <yield1>
80104a95:	eb e1                	jmp    80104a78 <proctimer+0x38>
80104a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9e:	66 90                	xchg   %ax,%ax

80104aa0 <prboost>:
{ 
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	53                   	push   %ebx
80104aa4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104aa9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104aac:	68 20 2d 11 80       	push   $0x80112d20
80104ab1:	e8 7a 07 00 00       	call   80105230 <acquire>
  if (monopoly){
80104ab6:	a1 54 50 11 80       	mov    0x80115054,%eax
80104abb:	83 c4 10             	add    $0x10,%esp
80104abe:	85 c0                	test   %eax,%eax
80104ac0:	74 26                	je     80104ae8 <prboost+0x48>
80104ac2:	e9 94 00 00 00       	jmp    80104b5b <prboost+0xbb>
80104ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ace:	66 90                	xchg   %ax,%ax
    p->tq = 2 * p->level + 2;
80104ad0:	c7 83 84 00 00 00 02 	movl   $0x2,0x84(%ebx)
80104ad7:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ada:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80104ae0:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80104ae6:	74 35                	je     80104b1d <prboost+0x7d>
    if(p->level == -1 || p->level == 99)
80104ae8:	8b 43 7c             	mov    0x7c(%ebx),%eax
80104aeb:	83 f8 ff             	cmp    $0xffffffff,%eax
80104aee:	74 ea                	je     80104ada <prboost+0x3a>
80104af0:	83 f8 63             	cmp    $0x63,%eax
80104af3:	74 e5                	je     80104ada <prboost+0x3a>
    if(p->level){
80104af5:	85 c0                	test   %eax,%eax
80104af7:	74 d7                	je     80104ad0 <prboost+0x30>
      enqueue(&mlfq[0], p);
80104af9:	83 ec 08             	sub    $0x8,%esp
      p->level = 0;
80104afc:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
      enqueue(&mlfq[0], p);
80104b03:	53                   	push   %ebx
80104b04:	68 80 51 11 80       	push   $0x80115180
      p->priority = 0;
80104b09:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104b10:	00 00 00 
      enqueue(&mlfq[0], p);
80104b13:	e8 18 ef ff ff       	call   80103a30 <enqueue>
80104b18:	83 c4 10             	add    $0x10,%esp
80104b1b:	eb b3                	jmp    80104ad0 <prboost+0x30>
80104b1d:	ba 9c 53 11 80       	mov    $0x8011539c,%edx
    mlfq[qlv].size = mlfq[qlv].start = mlfq[qlv].end = 0;
80104b22:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
80104b29:	8d 82 fc fe ff ff    	lea    -0x104(%edx),%eax
80104b2f:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
80104b35:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    for (int idx = 0; idx <= NPROC; idx ++)
80104b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      mlfq[qlv].heap[idx] = 0;
80104b40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (int idx = 0; idx <= NPROC; idx ++)
80104b46:	83 c0 04             	add    $0x4,%eax
80104b49:	39 d0                	cmp    %edx,%eax
80104b4b:	75 f3                	jne    80104b40 <prboost+0xa0>
  for (int qlv = 1; qlv <= 3; qlv ++){
80104b4d:	81 c2 18 01 00 00    	add    $0x118,%edx
80104b53:	81 fa e4 56 11 80    	cmp    $0x801156e4,%edx
80104b59:	75 c7                	jne    80104b22 <prboost+0x82>
    release(&ptable.lock);
80104b5b:	83 ec 0c             	sub    $0xc,%esp
80104b5e:	68 20 2d 11 80       	push   $0x80112d20
80104b63:	e8 68 06 00 00       	call   801051d0 <release>
}
80104b68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b6b:	c9                   	leave  
80104b6c:	c3                   	ret    
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi

80104b70 <getlev>:
{ 
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	53                   	push   %ebx
80104b74:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104b77:	68 20 2d 11 80       	push   $0x80112d20
80104b7c:	e8 af 06 00 00       	call   80105230 <acquire>
  pushcli();
80104b81:	e8 5a 05 00 00       	call   801050e0 <pushcli>
  c = mycpu();
80104b86:	e8 85 f0 ff ff       	call   80103c10 <mycpu>
  p = c->proc;
80104b8b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104b91:	e8 9a 05 00 00       	call   80105130 <popcli>
  level = myproc()->level;
80104b96:	8b 5b 7c             	mov    0x7c(%ebx),%ebx
  release(&ptable.lock);
80104b99:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104ba0:	e8 2b 06 00 00       	call   801051d0 <release>
}
80104ba5:	89 d8                	mov    %ebx,%eax
80104ba7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104baa:	c9                   	leave  
80104bab:	c3                   	ret    
80104bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bb0 <setpriority>:
{ 
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	57                   	push   %edi
80104bb4:	56                   	push   %esi
80104bb5:	53                   	push   %ebx
80104bb6:	83 ec 0c             	sub    $0xc,%esp
  if (priority < 0 || priority > 10) return -2;
80104bb9:	83 7d 0c 0a          	cmpl   $0xa,0xc(%ebp)
{ 
80104bbd:	8b 75 08             	mov    0x8(%ebp),%esi
  if (priority < 0 || priority > 10) return -2;
80104bc0:	0f 87 6c 01 00 00    	ja     80104d32 <setpriority+0x182>
  acquire(&ptable.lock);
80104bc6:	83 ec 0c             	sub    $0xc,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bc9:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  acquire(&ptable.lock);
80104bce:	68 20 2d 11 80       	push   $0x80112d20
80104bd3:	e8 58 06 00 00       	call   80105230 <acquire>
80104bd8:	83 c4 10             	add    $0x10,%esp
    if (p->pid != pid) continue;
80104bdb:	39 73 10             	cmp    %esi,0x10(%ebx)
80104bde:	74 28                	je     80104c08 <setpriority+0x58>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104be0:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80104be6:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80104bec:	75 ed                	jne    80104bdb <setpriority+0x2b>
  release(&ptable.lock);
80104bee:	83 ec 0c             	sub    $0xc,%esp
80104bf1:	68 20 2d 11 80       	push   $0x80112d20
80104bf6:	e8 d5 05 00 00       	call   801051d0 <release>
  return -1;
80104bfb:	83 c4 10             	add    $0x10,%esp
80104bfe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c03:	eb 24                	jmp    80104c29 <setpriority+0x79>
80104c05:	8d 76 00             	lea    0x0(%esi),%esi
    if (p->level == 3){
80104c08:	83 7b 7c 03          	cmpl   $0x3,0x7c(%ebx)
80104c0c:	74 2a                	je     80104c38 <setpriority+0x88>
    release(&ptable.lock);
80104c0e:	83 ec 0c             	sub    $0xc,%esp
    p->priority = priority;
80104c11:	8b 45 0c             	mov    0xc(%ebp),%eax
    release(&ptable.lock);
80104c14:	68 20 2d 11 80       	push   $0x80112d20
    p->priority = priority;
80104c19:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
    release(&ptable.lock);
80104c1f:	e8 ac 05 00 00       	call   801051d0 <release>
    return 0;
80104c24:	83 c4 10             	add    $0x10,%esp
80104c27:	31 c0                	xor    %eax,%eax
}
80104c29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c2c:	5b                   	pop    %ebx
80104c2d:	5e                   	pop    %esi
80104c2e:	5f                   	pop    %edi
80104c2f:	5d                   	pop    %ebp
80104c30:	c3                   	ret    
80104c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      p->priority = 11;
80104c38:	c7 83 80 00 00 00 0b 	movl   $0xb,0x80(%ebx)
80104c3f:	00 00 00 
      while(cnt){
80104c42:	8b bb 88 00 00 00    	mov    0x88(%ebx),%edi
80104c48:	83 c7 01             	add    $0x1,%edi
80104c4b:	74 79                	je     80104cc6 <setpriority+0x116>
80104c4d:	8d 76 00             	lea    0x0(%esi),%esi
        if(mlfq[3].front == p) cnt --;
80104c50:	a1 dc 55 11 80       	mov    0x801155dc,%eax
80104c55:	39 d8                	cmp    %ebx,%eax
80104c57:	0f 84 93 00 00 00    	je     80104cf0 <setpriority+0x140>
        else enqueue(&mlfq[3], mlfq[3].front);
80104c5d:	83 ec 08             	sub    $0x8,%esp
80104c60:	50                   	push   %eax
80104c61:	68 c8 54 11 80       	push   $0x801154c8
80104c66:	e8 c5 ed ff ff       	call   80103a30 <enqueue>
  if (q->size == 0) 
80104c6b:	8b 35 d4 55 11 80    	mov    0x801155d4,%esi
80104c71:	83 c4 10             	add    $0x10,%esp
80104c74:	85 f6                	test   %esi,%esi
80104c76:	74 d8                	je     80104c50 <setpriority+0xa0>
  if (q->level == 3){
80104c78:	83 3d d8 55 11 80 03 	cmpl   $0x3,0x801155d8
80104c7f:	0f 84 85 00 00 00    	je     80104d0a <setpriority+0x15a>
    q->start = (q->start + 1) % (NPROC + 1);
80104c85:	a1 cc 55 11 80       	mov    0x801155cc,%eax
80104c8a:	8d 48 01             	lea    0x1(%eax),%ecx
80104c8d:	b8 7f e0 07 7e       	mov    $0x7e07e07f,%eax
80104c92:	f7 e9                	imul   %ecx
80104c94:	89 c8                	mov    %ecx,%eax
80104c96:	c1 f8 1f             	sar    $0x1f,%eax
80104c99:	c1 fa 05             	sar    $0x5,%edx
80104c9c:	29 c2                	sub    %eax,%edx
80104c9e:	89 d0                	mov    %edx,%eax
80104ca0:	c1 e0 06             	shl    $0x6,%eax
80104ca3:	01 d0                	add    %edx,%eax
80104ca5:	29 c1                	sub    %eax,%ecx
80104ca7:	89 0d cc 55 11 80    	mov    %ecx,0x801155cc
    q->front = q->heap[q->start];
80104cad:	8b 04 8d c8 54 11 80 	mov    -0x7feeab38(,%ecx,4),%eax
  q->size = q->size - 1;
80104cb4:	83 ee 01             	sub    $0x1,%esi
    q->front = q->heap[1];
80104cb7:	a3 dc 55 11 80       	mov    %eax,0x801155dc
  q->size = q->size - 1;
80104cbc:	89 35 d4 55 11 80    	mov    %esi,0x801155d4
      while(cnt){
80104cc2:	85 ff                	test   %edi,%edi
80104cc4:	75 8a                	jne    80104c50 <setpriority+0xa0>
      p->yielded = 0;
80104cc6:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80104ccd:	00 00 00 
      enqueue(&mlfq[3], p);
80104cd0:	83 ec 08             	sub    $0x8,%esp
      p->priority = priority;
80104cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
      enqueue(&mlfq[3], p);
80104cd6:	53                   	push   %ebx
80104cd7:	68 c8 54 11 80       	push   $0x801154c8
      p->priority = priority;
80104cdc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
      enqueue(&mlfq[3], p);
80104ce2:	e8 49 ed ff ff       	call   80103a30 <enqueue>
80104ce7:	83 c4 10             	add    $0x10,%esp
80104cea:	e9 1f ff ff ff       	jmp    80104c0e <setpriority+0x5e>
80104cef:	90                   	nop
  if (q->size == 0) 
80104cf0:	8b 35 d4 55 11 80    	mov    0x801155d4,%esi
        if(mlfq[3].front == p) cnt --;
80104cf6:	83 ef 01             	sub    $0x1,%edi
  if (q->size == 0) 
80104cf9:	85 f6                	test   %esi,%esi
80104cfb:	74 c5                	je     80104cc2 <setpriority+0x112>
  if (q->level == 3){
80104cfd:	83 3d d8 55 11 80 03 	cmpl   $0x3,0x801155d8
80104d04:	0f 85 7b ff ff ff    	jne    80104c85 <setpriority+0xd5>
    heapify(q, 1);
80104d0a:	83 ec 08             	sub    $0x8,%esp
    q->heap[1] = q->heap[q->size];
80104d0d:	8b 04 b5 c8 54 11 80 	mov    -0x7feeab38(,%esi,4),%eax
    heapify(q, 1);
80104d14:	6a 01                	push   $0x1
80104d16:	68 c8 54 11 80       	push   $0x801154c8
    q->heap[1] = q->heap[q->size];
80104d1b:	a3 cc 54 11 80       	mov    %eax,0x801154cc
    heapify(q, 1);
80104d20:	e8 bb ed ff ff       	call   80103ae0 <heapify>
    q->front = q->heap[1];
80104d25:	a1 cc 54 11 80       	mov    0x801154cc,%eax
80104d2a:	83 c4 10             	add    $0x10,%esp
80104d2d:	e9 82 ff ff ff       	jmp    80104cb4 <setpriority+0x104>
  if (priority < 0 || priority > 10) return -2;
80104d32:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80104d37:	e9 ed fe ff ff       	jmp    80104c29 <setpriority+0x79>
80104d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d40 <setmonopoly>:
{ 
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
  if (password != studentid){
80104d44:	81 7d 0c 10 00 77 78 	cmpl   $0x78770010,0xc(%ebp)
{ 
80104d4b:	53                   	push   %ebx
80104d4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (password != studentid){
80104d4f:	0f 85 9b 00 00 00    	jne    80104df0 <setmonopoly+0xb0>
  acquire(&ptable.lock);
80104d55:	83 ec 0c             	sub    $0xc,%esp
80104d58:	68 20 2d 11 80       	push   $0x80112d20
80104d5d:	e8 ce 04 00 00       	call   80105230 <acquire>
  pushcli();
80104d62:	e8 79 03 00 00       	call   801050e0 <pushcli>
  c = mycpu();
80104d67:	e8 a4 ee ff ff       	call   80103c10 <mycpu>
  p = c->proc;
80104d6c:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104d72:	e8 b9 03 00 00       	call   80105130 <popcli>
  if (pid == myproc()->pid){
80104d77:	83 c4 10             	add    $0x10,%esp
80104d7a:	39 5e 10             	cmp    %ebx,0x10(%esi)
80104d7d:	0f 84 8b 00 00 00    	je     80104e0e <setmonopoly+0xce>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d83:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
    if (p->pid != pid) 
80104d88:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d8b:	74 23                	je     80104db0 <setmonopoly+0x70>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d8d:	05 8c 00 00 00       	add    $0x8c,%eax
80104d92:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80104d97:	75 ef                	jne    80104d88 <setmonopoly+0x48>
  release(&ptable.lock);
80104d99:	83 ec 0c             	sub    $0xc,%esp
80104d9c:	68 20 2d 11 80       	push   $0x80112d20
80104da1:	e8 2a 04 00 00       	call   801051d0 <release>
  return -1;
80104da6:	83 c4 10             	add    $0x10,%esp
80104da9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dae:	eb 2f                	jmp    80104ddf <setmonopoly+0x9f>
    if (p->level == 99){
80104db0:	83 78 7c 63          	cmpl   $0x63,0x7c(%eax)
80104db4:	74 41                	je     80104df7 <setmonopoly+0xb7>
    enqueue(&moq, p);
80104db6:	83 ec 08             	sub    $0x8,%esp
    p->level = 99;
80104db9:	c7 40 7c 63 00 00 00 	movl   $0x63,0x7c(%eax)
    enqueue(&moq, p);
80104dc0:	50                   	push   %eax
80104dc1:	68 60 50 11 80       	push   $0x80115060
80104dc6:	e8 65 ec ff ff       	call   80103a30 <enqueue>
    release(&ptable.lock);
80104dcb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104dd2:	e8 f9 03 00 00       	call   801051d0 <release>
    return moq.size;
80104dd7:	a1 6c 51 11 80       	mov    0x8011516c,%eax
80104ddc:	83 c4 10             	add    $0x10,%esp
}
80104ddf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104de2:	5b                   	pop    %ebx
80104de3:	5e                   	pop    %esi
80104de4:	5d                   	pop    %ebp
80104de5:	c3                   	ret    
80104de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ded:	8d 76 00             	lea    0x0(%esi),%esi
    return -2;
80104df0:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80104df5:	eb e8                	jmp    80104ddf <setmonopoly+0x9f>
      release(&ptable.lock);
80104df7:	83 ec 0c             	sub    $0xc,%esp
80104dfa:	68 20 2d 11 80       	push   $0x80112d20
80104dff:	e8 cc 03 00 00       	call   801051d0 <release>
      return -3;
80104e04:	83 c4 10             	add    $0x10,%esp
80104e07:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80104e0c:	eb d1                	jmp    80104ddf <setmonopoly+0x9f>
    release(&ptable.lock);
80104e0e:	83 ec 0c             	sub    $0xc,%esp
80104e11:	68 20 2d 11 80       	push   $0x80112d20
80104e16:	e8 b5 03 00 00       	call   801051d0 <release>
    return -4;
80104e1b:	83 c4 10             	add    $0x10,%esp
80104e1e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
80104e23:	eb ba                	jmp    80104ddf <setmonopoly+0x9f>
80104e25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e30 <monopolize>:
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	53                   	push   %ebx
80104e34:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104e37:	68 20 2d 11 80       	push   $0x80112d20
80104e3c:	e8 ef 03 00 00       	call   80105230 <acquire>
  pushcli();
80104e41:	e8 9a 02 00 00       	call   801050e0 <pushcli>
  c = mycpu();
80104e46:	e8 c5 ed ff ff       	call   80103c10 <mycpu>
  p = c->proc;
80104e4b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104e51:	e8 da 02 00 00       	call   80105130 <popcli>
  if(p->level == 99){
80104e56:	83 c4 10             	add    $0x10,%esp
80104e59:	83 7b 7c 63          	cmpl   $0x63,0x7c(%ebx)
80104e5d:	74 19                	je     80104e78 <monopolize+0x48>
  if(p->tq == 0) yield1();
80104e5f:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  monopoly = 1;
80104e65:	c7 05 54 50 11 80 01 	movl   $0x1,0x80115054
80104e6c:	00 00 00 
  if(p->tq == 0) yield1();
80104e6f:	85 c0                	test   %eax,%eax
80104e71:	75 1d                	jne    80104e90 <monopolize+0x60>
80104e73:	e8 88 f6 ff ff       	call   80104500 <yield1>
    release(&ptable.lock);
80104e78:	83 ec 0c             	sub    $0xc,%esp
80104e7b:	68 20 2d 11 80       	push   $0x80112d20
80104e80:	e8 4b 03 00 00       	call   801051d0 <release>
}
80104e85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e88:	c9                   	leave  
80104e89:	c3                   	ret    
80104e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else yield2();
80104e90:	e8 3b f7 ff ff       	call   801045d0 <yield2>
80104e95:	eb e1                	jmp    80104e78 <monopolize+0x48>
80104e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9e:	66 90                	xchg   %ax,%ax

80104ea0 <unmonopolize>:

void
unmonopolize()
{ 
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	53                   	push   %ebx
80104ea4:	83 ec 10             	sub    $0x10,%esp
  struct proc * p;
  acquire(&ptable.lock);
80104ea7:	68 20 2d 11 80       	push   $0x80112d20
80104eac:	e8 7f 03 00 00       	call   80105230 <acquire>
  pushcli();
80104eb1:	e8 2a 02 00 00       	call   801050e0 <pushcli>
  c = mycpu();
80104eb6:	e8 55 ed ff ff       	call   80103c10 <mycpu>
  p = c->proc;
80104ebb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104ec1:	e8 6a 02 00 00       	call   80105130 <popcli>

  p = myproc();

  if(p->level != 99){
80104ec6:	83 c4 10             	add    $0x10,%esp
80104ec9:	83 7b 7c 63          	cmpl   $0x63,0x7c(%ebx)
80104ecd:	74 19                	je     80104ee8 <unmonopolize+0x48>
    release(&ptable.lock);
80104ecf:	83 ec 0c             	sub    $0xc,%esp
80104ed2:	68 20 2d 11 80       	push   $0x80112d20
80104ed7:	e8 f4 02 00 00       	call   801051d0 <release>
    return;
  }
  unmonopolize1();
  yield2();
  release(&ptable.lock);
}
80104edc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return;
80104edf:	83 c4 10             	add    $0x10,%esp
}
80104ee2:	c9                   	leave  
80104ee3:	c3                   	ret    
80104ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  monopoly = 0;
80104ee8:	c7 05 54 50 11 80 00 	movl   $0x0,0x80115054
80104eef:	00 00 00 
  acquire(&tickslock);
80104ef2:	83 ec 0c             	sub    $0xc,%esp
80104ef5:	68 20 56 11 80       	push   $0x80115620
80104efa:	e8 31 03 00 00       	call   80105230 <acquire>
  release(&tickslock);
80104eff:	c7 04 24 20 56 11 80 	movl   $0x80115620,(%esp)
  ticks = 0;
80104f06:	c7 05 00 56 11 80 00 	movl   $0x0,0x80115600
80104f0d:	00 00 00 
  release(&tickslock);
80104f10:	e8 bb 02 00 00       	call   801051d0 <release>
  yield2();
80104f15:	e8 b6 f6 ff ff       	call   801045d0 <yield2>
  release(&ptable.lock);
80104f1a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104f21:	e8 aa 02 00 00       	call   801051d0 <release>
}
80104f26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&ptable.lock);
80104f29:	83 c4 10             	add    $0x10,%esp
}
80104f2c:	c9                   	leave  
80104f2d:	c3                   	ret    
80104f2e:	66 90                	xchg   %ax,%ax

80104f30 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	53                   	push   %ebx
80104f34:	83 ec 0c             	sub    $0xc,%esp
80104f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104f3a:	68 3c 87 10 80       	push   $0x8010873c
80104f3f:	8d 43 04             	lea    0x4(%ebx),%eax
80104f42:	50                   	push   %eax
80104f43:	e8 18 01 00 00       	call   80105060 <initlock>
  lk->name = name;
80104f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104f4b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104f51:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104f54:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104f5b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104f5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f61:	c9                   	leave  
80104f62:	c3                   	ret    
80104f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f70 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	56                   	push   %esi
80104f74:	53                   	push   %ebx
80104f75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104f78:	8d 73 04             	lea    0x4(%ebx),%esi
80104f7b:	83 ec 0c             	sub    $0xc,%esp
80104f7e:	56                   	push   %esi
80104f7f:	e8 ac 02 00 00       	call   80105230 <acquire>
  while (lk->locked) {
80104f84:	8b 13                	mov    (%ebx),%edx
80104f86:	83 c4 10             	add    $0x10,%esp
80104f89:	85 d2                	test   %edx,%edx
80104f8b:	74 16                	je     80104fa3 <acquiresleep+0x33>
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104f90:	83 ec 08             	sub    $0x8,%esp
80104f93:	56                   	push   %esi
80104f94:	53                   	push   %ebx
80104f95:	e8 46 f8 ff ff       	call   801047e0 <sleep>
  while (lk->locked) {
80104f9a:	8b 03                	mov    (%ebx),%eax
80104f9c:	83 c4 10             	add    $0x10,%esp
80104f9f:	85 c0                	test   %eax,%eax
80104fa1:	75 ed                	jne    80104f90 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104fa3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104fa9:	e8 e2 ec ff ff       	call   80103c90 <myproc>
80104fae:	8b 40 10             	mov    0x10(%eax),%eax
80104fb1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104fb4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104fb7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fba:	5b                   	pop    %ebx
80104fbb:	5e                   	pop    %esi
80104fbc:	5d                   	pop    %ebp
  release(&lk->lk);
80104fbd:	e9 0e 02 00 00       	jmp    801051d0 <release>
80104fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fd0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
80104fd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104fd8:	8d 73 04             	lea    0x4(%ebx),%esi
80104fdb:	83 ec 0c             	sub    $0xc,%esp
80104fde:	56                   	push   %esi
80104fdf:	e8 4c 02 00 00       	call   80105230 <acquire>
  lk->locked = 0;
80104fe4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104fea:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104ff1:	89 1c 24             	mov    %ebx,(%esp)
80104ff4:	e8 a7 f8 ff ff       	call   801048a0 <wakeup>
  release(&lk->lk);
80104ff9:	89 75 08             	mov    %esi,0x8(%ebp)
80104ffc:	83 c4 10             	add    $0x10,%esp
}
80104fff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105002:	5b                   	pop    %ebx
80105003:	5e                   	pop    %esi
80105004:	5d                   	pop    %ebp
  release(&lk->lk);
80105005:	e9 c6 01 00 00       	jmp    801051d0 <release>
8010500a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105010 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	57                   	push   %edi
80105014:	31 ff                	xor    %edi,%edi
80105016:	56                   	push   %esi
80105017:	53                   	push   %ebx
80105018:	83 ec 18             	sub    $0x18,%esp
8010501b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010501e:	8d 73 04             	lea    0x4(%ebx),%esi
80105021:	56                   	push   %esi
80105022:	e8 09 02 00 00       	call   80105230 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105027:	8b 03                	mov    (%ebx),%eax
80105029:	83 c4 10             	add    $0x10,%esp
8010502c:	85 c0                	test   %eax,%eax
8010502e:	75 18                	jne    80105048 <holdingsleep+0x38>
  release(&lk->lk);
80105030:	83 ec 0c             	sub    $0xc,%esp
80105033:	56                   	push   %esi
80105034:	e8 97 01 00 00       	call   801051d0 <release>
  return r;
}
80105039:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010503c:	89 f8                	mov    %edi,%eax
8010503e:	5b                   	pop    %ebx
8010503f:	5e                   	pop    %esi
80105040:	5f                   	pop    %edi
80105041:	5d                   	pop    %ebp
80105042:	c3                   	ret    
80105043:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105047:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80105048:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010504b:	e8 40 ec ff ff       	call   80103c90 <myproc>
80105050:	39 58 10             	cmp    %ebx,0x10(%eax)
80105053:	0f 94 c0             	sete   %al
80105056:	0f b6 c0             	movzbl %al,%eax
80105059:	89 c7                	mov    %eax,%edi
8010505b:	eb d3                	jmp    80105030 <holdingsleep+0x20>
8010505d:	66 90                	xchg   %ax,%ax
8010505f:	90                   	nop

80105060 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105066:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105069:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010506f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105072:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105079:	5d                   	pop    %ebp
8010507a:	c3                   	ret    
8010507b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010507f:	90                   	nop

80105080 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105080:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105081:	31 d2                	xor    %edx,%edx
{
80105083:	89 e5                	mov    %esp,%ebp
80105085:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105086:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105089:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010508c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010508f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105090:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105096:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010509c:	77 1a                	ja     801050b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010509e:	8b 58 04             	mov    0x4(%eax),%ebx
801050a1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801050a4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801050a7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801050a9:	83 fa 0a             	cmp    $0xa,%edx
801050ac:	75 e2                	jne    80105090 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801050ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050b1:	c9                   	leave  
801050b2:	c3                   	ret    
801050b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050b7:	90                   	nop
  for(; i < 10; i++)
801050b8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801050bb:	8d 51 28             	lea    0x28(%ecx),%edx
801050be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801050c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801050c6:	83 c0 04             	add    $0x4,%eax
801050c9:	39 d0                	cmp    %edx,%eax
801050cb:	75 f3                	jne    801050c0 <getcallerpcs+0x40>
}
801050cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050d0:	c9                   	leave  
801050d1:	c3                   	ret    
801050d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801050e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	53                   	push   %ebx
801050e4:	83 ec 04             	sub    $0x4,%esp
801050e7:	9c                   	pushf  
801050e8:	5b                   	pop    %ebx
  asm volatile("cli");
801050e9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801050ea:	e8 21 eb ff ff       	call   80103c10 <mycpu>
801050ef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801050f5:	85 c0                	test   %eax,%eax
801050f7:	74 17                	je     80105110 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801050f9:	e8 12 eb ff ff       	call   80103c10 <mycpu>
801050fe:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105105:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105108:	c9                   	leave  
80105109:	c3                   	ret    
8010510a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80105110:	e8 fb ea ff ff       	call   80103c10 <mycpu>
80105115:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010511b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105121:	eb d6                	jmp    801050f9 <pushcli+0x19>
80105123:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105130 <popcli>:

void
popcli(void)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105136:	9c                   	pushf  
80105137:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105138:	f6 c4 02             	test   $0x2,%ah
8010513b:	75 35                	jne    80105172 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010513d:	e8 ce ea ff ff       	call   80103c10 <mycpu>
80105142:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105149:	78 34                	js     8010517f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010514b:	e8 c0 ea ff ff       	call   80103c10 <mycpu>
80105150:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105156:	85 d2                	test   %edx,%edx
80105158:	74 06                	je     80105160 <popcli+0x30>
    sti();
}
8010515a:	c9                   	leave  
8010515b:	c3                   	ret    
8010515c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105160:	e8 ab ea ff ff       	call   80103c10 <mycpu>
80105165:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010516b:	85 c0                	test   %eax,%eax
8010516d:	74 eb                	je     8010515a <popcli+0x2a>
  asm volatile("sti");
8010516f:	fb                   	sti    
}
80105170:	c9                   	leave  
80105171:	c3                   	ret    
    panic("popcli - interruptible");
80105172:	83 ec 0c             	sub    $0xc,%esp
80105175:	68 47 87 10 80       	push   $0x80108747
8010517a:	e8 01 b2 ff ff       	call   80100380 <panic>
    panic("popcli");
8010517f:	83 ec 0c             	sub    $0xc,%esp
80105182:	68 5e 87 10 80       	push   $0x8010875e
80105187:	e8 f4 b1 ff ff       	call   80100380 <panic>
8010518c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105190 <holding>:
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	56                   	push   %esi
80105194:	53                   	push   %ebx
80105195:	8b 75 08             	mov    0x8(%ebp),%esi
80105198:	31 db                	xor    %ebx,%ebx
  pushcli();
8010519a:	e8 41 ff ff ff       	call   801050e0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010519f:	8b 06                	mov    (%esi),%eax
801051a1:	85 c0                	test   %eax,%eax
801051a3:	75 0b                	jne    801051b0 <holding+0x20>
  popcli();
801051a5:	e8 86 ff ff ff       	call   80105130 <popcli>
}
801051aa:	89 d8                	mov    %ebx,%eax
801051ac:	5b                   	pop    %ebx
801051ad:	5e                   	pop    %esi
801051ae:	5d                   	pop    %ebp
801051af:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801051b0:	8b 5e 08             	mov    0x8(%esi),%ebx
801051b3:	e8 58 ea ff ff       	call   80103c10 <mycpu>
801051b8:	39 c3                	cmp    %eax,%ebx
801051ba:	0f 94 c3             	sete   %bl
  popcli();
801051bd:	e8 6e ff ff ff       	call   80105130 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801051c2:	0f b6 db             	movzbl %bl,%ebx
}
801051c5:	89 d8                	mov    %ebx,%eax
801051c7:	5b                   	pop    %ebx
801051c8:	5e                   	pop    %esi
801051c9:	5d                   	pop    %ebp
801051ca:	c3                   	ret    
801051cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051cf:	90                   	nop

801051d0 <release>:
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	56                   	push   %esi
801051d4:	53                   	push   %ebx
801051d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801051d8:	e8 03 ff ff ff       	call   801050e0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801051dd:	8b 03                	mov    (%ebx),%eax
801051df:	85 c0                	test   %eax,%eax
801051e1:	75 15                	jne    801051f8 <release+0x28>
  popcli();
801051e3:	e8 48 ff ff ff       	call   80105130 <popcli>
    panic("release");
801051e8:	83 ec 0c             	sub    $0xc,%esp
801051eb:	68 65 87 10 80       	push   $0x80108765
801051f0:	e8 8b b1 ff ff       	call   80100380 <panic>
801051f5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801051f8:	8b 73 08             	mov    0x8(%ebx),%esi
801051fb:	e8 10 ea ff ff       	call   80103c10 <mycpu>
80105200:	39 c6                	cmp    %eax,%esi
80105202:	75 df                	jne    801051e3 <release+0x13>
  popcli();
80105204:	e8 27 ff ff ff       	call   80105130 <popcli>
  lk->pcs[0] = 0;
80105209:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105210:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105217:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010521c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105222:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105225:	5b                   	pop    %ebx
80105226:	5e                   	pop    %esi
80105227:	5d                   	pop    %ebp
  popcli();
80105228:	e9 03 ff ff ff       	jmp    80105130 <popcli>
8010522d:	8d 76 00             	lea    0x0(%esi),%esi

80105230 <acquire>:
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	53                   	push   %ebx
80105234:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105237:	e8 a4 fe ff ff       	call   801050e0 <pushcli>
  if(holding(lk))
8010523c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010523f:	e8 9c fe ff ff       	call   801050e0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105244:	8b 03                	mov    (%ebx),%eax
80105246:	85 c0                	test   %eax,%eax
80105248:	75 7e                	jne    801052c8 <acquire+0x98>
  popcli();
8010524a:	e8 e1 fe ff ff       	call   80105130 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010524f:	b9 01 00 00 00       	mov    $0x1,%ecx
80105254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80105258:	8b 55 08             	mov    0x8(%ebp),%edx
8010525b:	89 c8                	mov    %ecx,%eax
8010525d:	f0 87 02             	lock xchg %eax,(%edx)
80105260:	85 c0                	test   %eax,%eax
80105262:	75 f4                	jne    80105258 <acquire+0x28>
  __sync_synchronize();
80105264:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105269:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010526c:	e8 9f e9 ff ff       	call   80103c10 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105271:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80105274:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80105276:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80105279:	31 c0                	xor    %eax,%eax
8010527b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010527f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105280:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105286:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010528c:	77 1a                	ja     801052a8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010528e:	8b 5a 04             	mov    0x4(%edx),%ebx
80105291:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105295:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105298:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010529a:	83 f8 0a             	cmp    $0xa,%eax
8010529d:	75 e1                	jne    80105280 <acquire+0x50>
}
8010529f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052a2:	c9                   	leave  
801052a3:	c3                   	ret    
801052a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801052a8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801052ac:	8d 51 34             	lea    0x34(%ecx),%edx
801052af:	90                   	nop
    pcs[i] = 0;
801052b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801052b6:	83 c0 04             	add    $0x4,%eax
801052b9:	39 c2                	cmp    %eax,%edx
801052bb:	75 f3                	jne    801052b0 <acquire+0x80>
}
801052bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052c0:	c9                   	leave  
801052c1:	c3                   	ret    
801052c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801052c8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801052cb:	e8 40 e9 ff ff       	call   80103c10 <mycpu>
801052d0:	39 c3                	cmp    %eax,%ebx
801052d2:	0f 85 72 ff ff ff    	jne    8010524a <acquire+0x1a>
  popcli();
801052d8:	e8 53 fe ff ff       	call   80105130 <popcli>
    panic("acquire");
801052dd:	83 ec 0c             	sub    $0xc,%esp
801052e0:	68 6d 87 10 80       	push   $0x8010876d
801052e5:	e8 96 b0 ff ff       	call   80100380 <panic>
801052ea:	66 90                	xchg   %ax,%ax
801052ec:	66 90                	xchg   %ax,%ax
801052ee:	66 90                	xchg   %ax,%ax

801052f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	57                   	push   %edi
801052f4:	8b 55 08             	mov    0x8(%ebp),%edx
801052f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801052fa:	53                   	push   %ebx
801052fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801052fe:	89 d7                	mov    %edx,%edi
80105300:	09 cf                	or     %ecx,%edi
80105302:	83 e7 03             	and    $0x3,%edi
80105305:	75 29                	jne    80105330 <memset+0x40>
    c &= 0xFF;
80105307:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010530a:	c1 e0 18             	shl    $0x18,%eax
8010530d:	89 fb                	mov    %edi,%ebx
8010530f:	c1 e9 02             	shr    $0x2,%ecx
80105312:	c1 e3 10             	shl    $0x10,%ebx
80105315:	09 d8                	or     %ebx,%eax
80105317:	09 f8                	or     %edi,%eax
80105319:	c1 e7 08             	shl    $0x8,%edi
8010531c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010531e:	89 d7                	mov    %edx,%edi
80105320:	fc                   	cld    
80105321:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105323:	5b                   	pop    %ebx
80105324:	89 d0                	mov    %edx,%eax
80105326:	5f                   	pop    %edi
80105327:	5d                   	pop    %ebp
80105328:	c3                   	ret    
80105329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80105330:	89 d7                	mov    %edx,%edi
80105332:	fc                   	cld    
80105333:	f3 aa                	rep stos %al,%es:(%edi)
80105335:	5b                   	pop    %ebx
80105336:	89 d0                	mov    %edx,%eax
80105338:	5f                   	pop    %edi
80105339:	5d                   	pop    %ebp
8010533a:	c3                   	ret    
8010533b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010533f:	90                   	nop

80105340 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	56                   	push   %esi
80105344:	8b 75 10             	mov    0x10(%ebp),%esi
80105347:	8b 55 08             	mov    0x8(%ebp),%edx
8010534a:	53                   	push   %ebx
8010534b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010534e:	85 f6                	test   %esi,%esi
80105350:	74 2e                	je     80105380 <memcmp+0x40>
80105352:	01 c6                	add    %eax,%esi
80105354:	eb 14                	jmp    8010536a <memcmp+0x2a>
80105356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105360:	83 c0 01             	add    $0x1,%eax
80105363:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105366:	39 f0                	cmp    %esi,%eax
80105368:	74 16                	je     80105380 <memcmp+0x40>
    if(*s1 != *s2)
8010536a:	0f b6 0a             	movzbl (%edx),%ecx
8010536d:	0f b6 18             	movzbl (%eax),%ebx
80105370:	38 d9                	cmp    %bl,%cl
80105372:	74 ec                	je     80105360 <memcmp+0x20>
      return *s1 - *s2;
80105374:	0f b6 c1             	movzbl %cl,%eax
80105377:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105379:	5b                   	pop    %ebx
8010537a:	5e                   	pop    %esi
8010537b:	5d                   	pop    %ebp
8010537c:	c3                   	ret    
8010537d:	8d 76 00             	lea    0x0(%esi),%esi
80105380:	5b                   	pop    %ebx
  return 0;
80105381:	31 c0                	xor    %eax,%eax
}
80105383:	5e                   	pop    %esi
80105384:	5d                   	pop    %ebp
80105385:	c3                   	ret    
80105386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538d:	8d 76 00             	lea    0x0(%esi),%esi

80105390 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	57                   	push   %edi
80105394:	8b 55 08             	mov    0x8(%ebp),%edx
80105397:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010539a:	56                   	push   %esi
8010539b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010539e:	39 d6                	cmp    %edx,%esi
801053a0:	73 26                	jae    801053c8 <memmove+0x38>
801053a2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801053a5:	39 fa                	cmp    %edi,%edx
801053a7:	73 1f                	jae    801053c8 <memmove+0x38>
801053a9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801053ac:	85 c9                	test   %ecx,%ecx
801053ae:	74 0c                	je     801053bc <memmove+0x2c>
      *--d = *--s;
801053b0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801053b4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801053b7:	83 e8 01             	sub    $0x1,%eax
801053ba:	73 f4                	jae    801053b0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801053bc:	5e                   	pop    %esi
801053bd:	89 d0                	mov    %edx,%eax
801053bf:	5f                   	pop    %edi
801053c0:	5d                   	pop    %ebp
801053c1:	c3                   	ret    
801053c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801053c8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801053cb:	89 d7                	mov    %edx,%edi
801053cd:	85 c9                	test   %ecx,%ecx
801053cf:	74 eb                	je     801053bc <memmove+0x2c>
801053d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801053d8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801053d9:	39 c6                	cmp    %eax,%esi
801053db:	75 fb                	jne    801053d8 <memmove+0x48>
}
801053dd:	5e                   	pop    %esi
801053de:	89 d0                	mov    %edx,%eax
801053e0:	5f                   	pop    %edi
801053e1:	5d                   	pop    %ebp
801053e2:	c3                   	ret    
801053e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801053f0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801053f0:	eb 9e                	jmp    80105390 <memmove>
801053f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105400 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	56                   	push   %esi
80105404:	8b 75 10             	mov    0x10(%ebp),%esi
80105407:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010540a:	53                   	push   %ebx
8010540b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010540e:	85 f6                	test   %esi,%esi
80105410:	74 2e                	je     80105440 <strncmp+0x40>
80105412:	01 d6                	add    %edx,%esi
80105414:	eb 18                	jmp    8010542e <strncmp+0x2e>
80105416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010541d:	8d 76 00             	lea    0x0(%esi),%esi
80105420:	38 d8                	cmp    %bl,%al
80105422:	75 14                	jne    80105438 <strncmp+0x38>
    n--, p++, q++;
80105424:	83 c2 01             	add    $0x1,%edx
80105427:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010542a:	39 f2                	cmp    %esi,%edx
8010542c:	74 12                	je     80105440 <strncmp+0x40>
8010542e:	0f b6 01             	movzbl (%ecx),%eax
80105431:	0f b6 1a             	movzbl (%edx),%ebx
80105434:	84 c0                	test   %al,%al
80105436:	75 e8                	jne    80105420 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105438:	29 d8                	sub    %ebx,%eax
}
8010543a:	5b                   	pop    %ebx
8010543b:	5e                   	pop    %esi
8010543c:	5d                   	pop    %ebp
8010543d:	c3                   	ret    
8010543e:	66 90                	xchg   %ax,%ax
80105440:	5b                   	pop    %ebx
    return 0;
80105441:	31 c0                	xor    %eax,%eax
}
80105443:	5e                   	pop    %esi
80105444:	5d                   	pop    %ebp
80105445:	c3                   	ret    
80105446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010544d:	8d 76 00             	lea    0x0(%esi),%esi

80105450 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	57                   	push   %edi
80105454:	56                   	push   %esi
80105455:	8b 75 08             	mov    0x8(%ebp),%esi
80105458:	53                   	push   %ebx
80105459:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010545c:	89 f0                	mov    %esi,%eax
8010545e:	eb 15                	jmp    80105475 <strncpy+0x25>
80105460:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105464:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105467:	83 c0 01             	add    $0x1,%eax
8010546a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010546e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105471:	84 d2                	test   %dl,%dl
80105473:	74 09                	je     8010547e <strncpy+0x2e>
80105475:	89 cb                	mov    %ecx,%ebx
80105477:	83 e9 01             	sub    $0x1,%ecx
8010547a:	85 db                	test   %ebx,%ebx
8010547c:	7f e2                	jg     80105460 <strncpy+0x10>
    ;
  while(n-- > 0)
8010547e:	89 c2                	mov    %eax,%edx
80105480:	85 c9                	test   %ecx,%ecx
80105482:	7e 17                	jle    8010549b <strncpy+0x4b>
80105484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105488:	83 c2 01             	add    $0x1,%edx
8010548b:	89 c1                	mov    %eax,%ecx
8010548d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105491:	29 d1                	sub    %edx,%ecx
80105493:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105497:	85 c9                	test   %ecx,%ecx
80105499:	7f ed                	jg     80105488 <strncpy+0x38>
  return os;
}
8010549b:	5b                   	pop    %ebx
8010549c:	89 f0                	mov    %esi,%eax
8010549e:	5e                   	pop    %esi
8010549f:	5f                   	pop    %edi
801054a0:	5d                   	pop    %ebp
801054a1:	c3                   	ret    
801054a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	56                   	push   %esi
801054b4:	8b 55 10             	mov    0x10(%ebp),%edx
801054b7:	8b 75 08             	mov    0x8(%ebp),%esi
801054ba:	53                   	push   %ebx
801054bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801054be:	85 d2                	test   %edx,%edx
801054c0:	7e 25                	jle    801054e7 <safestrcpy+0x37>
801054c2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801054c6:	89 f2                	mov    %esi,%edx
801054c8:	eb 16                	jmp    801054e0 <safestrcpy+0x30>
801054ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801054d0:	0f b6 08             	movzbl (%eax),%ecx
801054d3:	83 c0 01             	add    $0x1,%eax
801054d6:	83 c2 01             	add    $0x1,%edx
801054d9:	88 4a ff             	mov    %cl,-0x1(%edx)
801054dc:	84 c9                	test   %cl,%cl
801054de:	74 04                	je     801054e4 <safestrcpy+0x34>
801054e0:	39 d8                	cmp    %ebx,%eax
801054e2:	75 ec                	jne    801054d0 <safestrcpy+0x20>
    ;
  *s = 0;
801054e4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801054e7:	89 f0                	mov    %esi,%eax
801054e9:	5b                   	pop    %ebx
801054ea:	5e                   	pop    %esi
801054eb:	5d                   	pop    %ebp
801054ec:	c3                   	ret    
801054ed:	8d 76 00             	lea    0x0(%esi),%esi

801054f0 <strlen>:

int
strlen(const char *s)
{
801054f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801054f1:	31 c0                	xor    %eax,%eax
{
801054f3:	89 e5                	mov    %esp,%ebp
801054f5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801054f8:	80 3a 00             	cmpb   $0x0,(%edx)
801054fb:	74 0c                	je     80105509 <strlen+0x19>
801054fd:	8d 76 00             	lea    0x0(%esi),%esi
80105500:	83 c0 01             	add    $0x1,%eax
80105503:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105507:	75 f7                	jne    80105500 <strlen+0x10>
    ;
  return n;
}
80105509:	5d                   	pop    %ebp
8010550a:	c3                   	ret    

8010550b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010550b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010550f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105513:	55                   	push   %ebp
  pushl %ebx
80105514:	53                   	push   %ebx
  pushl %esi
80105515:	56                   	push   %esi
  pushl %edi
80105516:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105517:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105519:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010551b:	5f                   	pop    %edi
  popl %esi
8010551c:	5e                   	pop    %esi
  popl %ebx
8010551d:	5b                   	pop    %ebx
  popl %ebp
8010551e:	5d                   	pop    %ebp
  ret
8010551f:	c3                   	ret    

80105520 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	53                   	push   %ebx
80105524:	83 ec 04             	sub    $0x4,%esp
80105527:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010552a:	e8 61 e7 ff ff       	call   80103c90 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010552f:	8b 00                	mov    (%eax),%eax
80105531:	39 d8                	cmp    %ebx,%eax
80105533:	76 1b                	jbe    80105550 <fetchint+0x30>
80105535:	8d 53 04             	lea    0x4(%ebx),%edx
80105538:	39 d0                	cmp    %edx,%eax
8010553a:	72 14                	jb     80105550 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010553c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010553f:	8b 13                	mov    (%ebx),%edx
80105541:	89 10                	mov    %edx,(%eax)
  return 0;
80105543:	31 c0                	xor    %eax,%eax
}
80105545:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105548:	c9                   	leave  
80105549:	c3                   	ret    
8010554a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105555:	eb ee                	jmp    80105545 <fetchint+0x25>
80105557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010555e:	66 90                	xchg   %ax,%ax

80105560 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	53                   	push   %ebx
80105564:	83 ec 04             	sub    $0x4,%esp
80105567:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010556a:	e8 21 e7 ff ff       	call   80103c90 <myproc>

  if(addr >= curproc->sz)
8010556f:	39 18                	cmp    %ebx,(%eax)
80105571:	76 2d                	jbe    801055a0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105573:	8b 55 0c             	mov    0xc(%ebp),%edx
80105576:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105578:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010557a:	39 d3                	cmp    %edx,%ebx
8010557c:	73 22                	jae    801055a0 <fetchstr+0x40>
8010557e:	89 d8                	mov    %ebx,%eax
80105580:	eb 0d                	jmp    8010558f <fetchstr+0x2f>
80105582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105588:	83 c0 01             	add    $0x1,%eax
8010558b:	39 c2                	cmp    %eax,%edx
8010558d:	76 11                	jbe    801055a0 <fetchstr+0x40>
    if(*s == 0)
8010558f:	80 38 00             	cmpb   $0x0,(%eax)
80105592:	75 f4                	jne    80105588 <fetchstr+0x28>
      return s - *pp;
80105594:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105596:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105599:	c9                   	leave  
8010559a:	c3                   	ret    
8010559b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010559f:	90                   	nop
801055a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801055a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055a8:	c9                   	leave  
801055a9:	c3                   	ret    
801055aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801055b0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	56                   	push   %esi
801055b4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801055b5:	e8 d6 e6 ff ff       	call   80103c90 <myproc>
801055ba:	8b 55 08             	mov    0x8(%ebp),%edx
801055bd:	8b 40 18             	mov    0x18(%eax),%eax
801055c0:	8b 40 44             	mov    0x44(%eax),%eax
801055c3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801055c6:	e8 c5 e6 ff ff       	call   80103c90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801055cb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801055ce:	8b 00                	mov    (%eax),%eax
801055d0:	39 c6                	cmp    %eax,%esi
801055d2:	73 1c                	jae    801055f0 <argint+0x40>
801055d4:	8d 53 08             	lea    0x8(%ebx),%edx
801055d7:	39 d0                	cmp    %edx,%eax
801055d9:	72 15                	jb     801055f0 <argint+0x40>
  *ip = *(int*)(addr);
801055db:	8b 45 0c             	mov    0xc(%ebp),%eax
801055de:	8b 53 04             	mov    0x4(%ebx),%edx
801055e1:	89 10                	mov    %edx,(%eax)
  return 0;
801055e3:	31 c0                	xor    %eax,%eax
}
801055e5:	5b                   	pop    %ebx
801055e6:	5e                   	pop    %esi
801055e7:	5d                   	pop    %ebp
801055e8:	c3                   	ret    
801055e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801055f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801055f5:	eb ee                	jmp    801055e5 <argint+0x35>
801055f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055fe:	66 90                	xchg   %ax,%ax

80105600 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	57                   	push   %edi
80105604:	56                   	push   %esi
80105605:	53                   	push   %ebx
80105606:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105609:	e8 82 e6 ff ff       	call   80103c90 <myproc>
8010560e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105610:	e8 7b e6 ff ff       	call   80103c90 <myproc>
80105615:	8b 55 08             	mov    0x8(%ebp),%edx
80105618:	8b 40 18             	mov    0x18(%eax),%eax
8010561b:	8b 40 44             	mov    0x44(%eax),%eax
8010561e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105621:	e8 6a e6 ff ff       	call   80103c90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105626:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105629:	8b 00                	mov    (%eax),%eax
8010562b:	39 c7                	cmp    %eax,%edi
8010562d:	73 31                	jae    80105660 <argptr+0x60>
8010562f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105632:	39 c8                	cmp    %ecx,%eax
80105634:	72 2a                	jb     80105660 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105636:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105639:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010563c:	85 d2                	test   %edx,%edx
8010563e:	78 20                	js     80105660 <argptr+0x60>
80105640:	8b 16                	mov    (%esi),%edx
80105642:	39 c2                	cmp    %eax,%edx
80105644:	76 1a                	jbe    80105660 <argptr+0x60>
80105646:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105649:	01 c3                	add    %eax,%ebx
8010564b:	39 da                	cmp    %ebx,%edx
8010564d:	72 11                	jb     80105660 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010564f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105652:	89 02                	mov    %eax,(%edx)
  return 0;
80105654:	31 c0                	xor    %eax,%eax
}
80105656:	83 c4 0c             	add    $0xc,%esp
80105659:	5b                   	pop    %ebx
8010565a:	5e                   	pop    %esi
8010565b:	5f                   	pop    %edi
8010565c:	5d                   	pop    %ebp
8010565d:	c3                   	ret    
8010565e:	66 90                	xchg   %ax,%ax
    return -1;
80105660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105665:	eb ef                	jmp    80105656 <argptr+0x56>
80105667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010566e:	66 90                	xchg   %ax,%ax

80105670 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	56                   	push   %esi
80105674:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105675:	e8 16 e6 ff ff       	call   80103c90 <myproc>
8010567a:	8b 55 08             	mov    0x8(%ebp),%edx
8010567d:	8b 40 18             	mov    0x18(%eax),%eax
80105680:	8b 40 44             	mov    0x44(%eax),%eax
80105683:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105686:	e8 05 e6 ff ff       	call   80103c90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010568b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010568e:	8b 00                	mov    (%eax),%eax
80105690:	39 c6                	cmp    %eax,%esi
80105692:	73 44                	jae    801056d8 <argstr+0x68>
80105694:	8d 53 08             	lea    0x8(%ebx),%edx
80105697:	39 d0                	cmp    %edx,%eax
80105699:	72 3d                	jb     801056d8 <argstr+0x68>
  *ip = *(int*)(addr);
8010569b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010569e:	e8 ed e5 ff ff       	call   80103c90 <myproc>
  if(addr >= curproc->sz)
801056a3:	3b 18                	cmp    (%eax),%ebx
801056a5:	73 31                	jae    801056d8 <argstr+0x68>
  *pp = (char*)addr;
801056a7:	8b 55 0c             	mov    0xc(%ebp),%edx
801056aa:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801056ac:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801056ae:	39 d3                	cmp    %edx,%ebx
801056b0:	73 26                	jae    801056d8 <argstr+0x68>
801056b2:	89 d8                	mov    %ebx,%eax
801056b4:	eb 11                	jmp    801056c7 <argstr+0x57>
801056b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056bd:	8d 76 00             	lea    0x0(%esi),%esi
801056c0:	83 c0 01             	add    $0x1,%eax
801056c3:	39 c2                	cmp    %eax,%edx
801056c5:	76 11                	jbe    801056d8 <argstr+0x68>
    if(*s == 0)
801056c7:	80 38 00             	cmpb   $0x0,(%eax)
801056ca:	75 f4                	jne    801056c0 <argstr+0x50>
      return s - *pp;
801056cc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801056ce:	5b                   	pop    %ebx
801056cf:	5e                   	pop    %esi
801056d0:	5d                   	pop    %ebp
801056d1:	c3                   	ret    
801056d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801056d8:	5b                   	pop    %ebx
    return -1;
801056d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056de:	5e                   	pop    %esi
801056df:	5d                   	pop    %ebp
801056e0:	c3                   	ret    
801056e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ef:	90                   	nop

801056f0 <syscall>:
[SYS_unmonopolize]  sys_unmonopolize,
};

void
syscall(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	53                   	push   %ebx
801056f4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801056f7:	e8 94 e5 ff ff       	call   80103c90 <myproc>
801056fc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801056fe:	8b 40 18             	mov    0x18(%eax),%eax
80105701:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105704:	8d 50 ff             	lea    -0x1(%eax),%edx
80105707:	83 fa 1d             	cmp    $0x1d,%edx
8010570a:	77 24                	ja     80105730 <syscall+0x40>
8010570c:	8b 14 85 a0 87 10 80 	mov    -0x7fef7860(,%eax,4),%edx
80105713:	85 d2                	test   %edx,%edx
80105715:	74 19                	je     80105730 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105717:	ff d2                	call   *%edx
80105719:	89 c2                	mov    %eax,%edx
8010571b:	8b 43 18             	mov    0x18(%ebx),%eax
8010571e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105721:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105724:	c9                   	leave  
80105725:	c3                   	ret    
80105726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010572d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105730:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105731:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105734:	50                   	push   %eax
80105735:	ff 73 10             	push   0x10(%ebx)
80105738:	68 75 87 10 80       	push   $0x80108775
8010573d:	e8 5e af ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80105742:	8b 43 18             	mov    0x18(%ebx),%eax
80105745:	83 c4 10             	add    $0x10,%esp
80105748:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010574f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105752:	c9                   	leave  
80105753:	c3                   	ret    
80105754:	66 90                	xchg   %ax,%ax
80105756:	66 90                	xchg   %ax,%ax
80105758:	66 90                	xchg   %ax,%ax
8010575a:	66 90                	xchg   %ax,%ax
8010575c:	66 90                	xchg   %ax,%ax
8010575e:	66 90                	xchg   %ax,%ax

80105760 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	57                   	push   %edi
80105764:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105765:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105768:	53                   	push   %ebx
80105769:	83 ec 34             	sub    $0x34,%esp
8010576c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010576f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105772:	57                   	push   %edi
80105773:	50                   	push   %eax
{
80105774:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105777:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010577a:	e8 41 c9 ff ff       	call   801020c0 <nameiparent>
8010577f:	83 c4 10             	add    $0x10,%esp
80105782:	85 c0                	test   %eax,%eax
80105784:	0f 84 46 01 00 00    	je     801058d0 <create+0x170>
    return 0;
  ilock(dp);
8010578a:	83 ec 0c             	sub    $0xc,%esp
8010578d:	89 c3                	mov    %eax,%ebx
8010578f:	50                   	push   %eax
80105790:	e8 eb bf ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105795:	83 c4 0c             	add    $0xc,%esp
80105798:	6a 00                	push   $0x0
8010579a:	57                   	push   %edi
8010579b:	53                   	push   %ebx
8010579c:	e8 3f c5 ff ff       	call   80101ce0 <dirlookup>
801057a1:	83 c4 10             	add    $0x10,%esp
801057a4:	89 c6                	mov    %eax,%esi
801057a6:	85 c0                	test   %eax,%eax
801057a8:	74 56                	je     80105800 <create+0xa0>
    iunlockput(dp);
801057aa:	83 ec 0c             	sub    $0xc,%esp
801057ad:	53                   	push   %ebx
801057ae:	e8 5d c2 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
801057b3:	89 34 24             	mov    %esi,(%esp)
801057b6:	e8 c5 bf ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801057bb:	83 c4 10             	add    $0x10,%esp
801057be:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801057c3:	75 1b                	jne    801057e0 <create+0x80>
801057c5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801057ca:	75 14                	jne    801057e0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801057cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057cf:	89 f0                	mov    %esi,%eax
801057d1:	5b                   	pop    %ebx
801057d2:	5e                   	pop    %esi
801057d3:	5f                   	pop    %edi
801057d4:	5d                   	pop    %ebp
801057d5:	c3                   	ret    
801057d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057dd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801057e0:	83 ec 0c             	sub    $0xc,%esp
801057e3:	56                   	push   %esi
    return 0;
801057e4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801057e6:	e8 25 c2 ff ff       	call   80101a10 <iunlockput>
    return 0;
801057eb:	83 c4 10             	add    $0x10,%esp
}
801057ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057f1:	89 f0                	mov    %esi,%eax
801057f3:	5b                   	pop    %ebx
801057f4:	5e                   	pop    %esi
801057f5:	5f                   	pop    %edi
801057f6:	5d                   	pop    %ebp
801057f7:	c3                   	ret    
801057f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ff:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105800:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105804:	83 ec 08             	sub    $0x8,%esp
80105807:	50                   	push   %eax
80105808:	ff 33                	push   (%ebx)
8010580a:	e8 01 be ff ff       	call   80101610 <ialloc>
8010580f:	83 c4 10             	add    $0x10,%esp
80105812:	89 c6                	mov    %eax,%esi
80105814:	85 c0                	test   %eax,%eax
80105816:	0f 84 cd 00 00 00    	je     801058e9 <create+0x189>
  ilock(ip);
8010581c:	83 ec 0c             	sub    $0xc,%esp
8010581f:	50                   	push   %eax
80105820:	e8 5b bf ff ff       	call   80101780 <ilock>
  ip->major = major;
80105825:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105829:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010582d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105831:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105835:	b8 01 00 00 00       	mov    $0x1,%eax
8010583a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010583e:	89 34 24             	mov    %esi,(%esp)
80105841:	e8 8a be ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105846:	83 c4 10             	add    $0x10,%esp
80105849:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010584e:	74 30                	je     80105880 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105850:	83 ec 04             	sub    $0x4,%esp
80105853:	ff 76 04             	push   0x4(%esi)
80105856:	57                   	push   %edi
80105857:	53                   	push   %ebx
80105858:	e8 83 c7 ff ff       	call   80101fe0 <dirlink>
8010585d:	83 c4 10             	add    $0x10,%esp
80105860:	85 c0                	test   %eax,%eax
80105862:	78 78                	js     801058dc <create+0x17c>
  iunlockput(dp);
80105864:	83 ec 0c             	sub    $0xc,%esp
80105867:	53                   	push   %ebx
80105868:	e8 a3 c1 ff ff       	call   80101a10 <iunlockput>
  return ip;
8010586d:	83 c4 10             	add    $0x10,%esp
}
80105870:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105873:	89 f0                	mov    %esi,%eax
80105875:	5b                   	pop    %ebx
80105876:	5e                   	pop    %esi
80105877:	5f                   	pop    %edi
80105878:	5d                   	pop    %ebp
80105879:	c3                   	ret    
8010587a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105880:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105883:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105888:	53                   	push   %ebx
80105889:	e8 42 be ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010588e:	83 c4 0c             	add    $0xc,%esp
80105891:	ff 76 04             	push   0x4(%esi)
80105894:	68 38 88 10 80       	push   $0x80108838
80105899:	56                   	push   %esi
8010589a:	e8 41 c7 ff ff       	call   80101fe0 <dirlink>
8010589f:	83 c4 10             	add    $0x10,%esp
801058a2:	85 c0                	test   %eax,%eax
801058a4:	78 18                	js     801058be <create+0x15e>
801058a6:	83 ec 04             	sub    $0x4,%esp
801058a9:	ff 73 04             	push   0x4(%ebx)
801058ac:	68 37 88 10 80       	push   $0x80108837
801058b1:	56                   	push   %esi
801058b2:	e8 29 c7 ff ff       	call   80101fe0 <dirlink>
801058b7:	83 c4 10             	add    $0x10,%esp
801058ba:	85 c0                	test   %eax,%eax
801058bc:	79 92                	jns    80105850 <create+0xf0>
      panic("create dots");
801058be:	83 ec 0c             	sub    $0xc,%esp
801058c1:	68 2b 88 10 80       	push   $0x8010882b
801058c6:	e8 b5 aa ff ff       	call   80100380 <panic>
801058cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058cf:	90                   	nop
}
801058d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801058d3:	31 f6                	xor    %esi,%esi
}
801058d5:	5b                   	pop    %ebx
801058d6:	89 f0                	mov    %esi,%eax
801058d8:	5e                   	pop    %esi
801058d9:	5f                   	pop    %edi
801058da:	5d                   	pop    %ebp
801058db:	c3                   	ret    
    panic("create: dirlink");
801058dc:	83 ec 0c             	sub    $0xc,%esp
801058df:	68 3a 88 10 80       	push   $0x8010883a
801058e4:	e8 97 aa ff ff       	call   80100380 <panic>
    panic("create: ialloc");
801058e9:	83 ec 0c             	sub    $0xc,%esp
801058ec:	68 1c 88 10 80       	push   $0x8010881c
801058f1:	e8 8a aa ff ff       	call   80100380 <panic>
801058f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058fd:	8d 76 00             	lea    0x0(%esi),%esi

80105900 <sys_dup>:
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	56                   	push   %esi
80105904:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105905:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105908:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010590b:	50                   	push   %eax
8010590c:	6a 00                	push   $0x0
8010590e:	e8 9d fc ff ff       	call   801055b0 <argint>
80105913:	83 c4 10             	add    $0x10,%esp
80105916:	85 c0                	test   %eax,%eax
80105918:	78 36                	js     80105950 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010591a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010591e:	77 30                	ja     80105950 <sys_dup+0x50>
80105920:	e8 6b e3 ff ff       	call   80103c90 <myproc>
80105925:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105928:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010592c:	85 f6                	test   %esi,%esi
8010592e:	74 20                	je     80105950 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105930:	e8 5b e3 ff ff       	call   80103c90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105935:	31 db                	xor    %ebx,%ebx
80105937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105940:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105944:	85 d2                	test   %edx,%edx
80105946:	74 18                	je     80105960 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105948:	83 c3 01             	add    $0x1,%ebx
8010594b:	83 fb 10             	cmp    $0x10,%ebx
8010594e:	75 f0                	jne    80105940 <sys_dup+0x40>
}
80105950:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105953:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105958:	89 d8                	mov    %ebx,%eax
8010595a:	5b                   	pop    %ebx
8010595b:	5e                   	pop    %esi
8010595c:	5d                   	pop    %ebp
8010595d:	c3                   	ret    
8010595e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105960:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105963:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105967:	56                   	push   %esi
80105968:	e8 33 b5 ff ff       	call   80100ea0 <filedup>
  return fd;
8010596d:	83 c4 10             	add    $0x10,%esp
}
80105970:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105973:	89 d8                	mov    %ebx,%eax
80105975:	5b                   	pop    %ebx
80105976:	5e                   	pop    %esi
80105977:	5d                   	pop    %ebp
80105978:	c3                   	ret    
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105980 <sys_read>:
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	56                   	push   %esi
80105984:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105985:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105988:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010598b:	53                   	push   %ebx
8010598c:	6a 00                	push   $0x0
8010598e:	e8 1d fc ff ff       	call   801055b0 <argint>
80105993:	83 c4 10             	add    $0x10,%esp
80105996:	85 c0                	test   %eax,%eax
80105998:	78 5e                	js     801059f8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010599a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010599e:	77 58                	ja     801059f8 <sys_read+0x78>
801059a0:	e8 eb e2 ff ff       	call   80103c90 <myproc>
801059a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059a8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801059ac:	85 f6                	test   %esi,%esi
801059ae:	74 48                	je     801059f8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801059b0:	83 ec 08             	sub    $0x8,%esp
801059b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059b6:	50                   	push   %eax
801059b7:	6a 02                	push   $0x2
801059b9:	e8 f2 fb ff ff       	call   801055b0 <argint>
801059be:	83 c4 10             	add    $0x10,%esp
801059c1:	85 c0                	test   %eax,%eax
801059c3:	78 33                	js     801059f8 <sys_read+0x78>
801059c5:	83 ec 04             	sub    $0x4,%esp
801059c8:	ff 75 f0             	push   -0x10(%ebp)
801059cb:	53                   	push   %ebx
801059cc:	6a 01                	push   $0x1
801059ce:	e8 2d fc ff ff       	call   80105600 <argptr>
801059d3:	83 c4 10             	add    $0x10,%esp
801059d6:	85 c0                	test   %eax,%eax
801059d8:	78 1e                	js     801059f8 <sys_read+0x78>
  return fileread(f, p, n);
801059da:	83 ec 04             	sub    $0x4,%esp
801059dd:	ff 75 f0             	push   -0x10(%ebp)
801059e0:	ff 75 f4             	push   -0xc(%ebp)
801059e3:	56                   	push   %esi
801059e4:	e8 37 b6 ff ff       	call   80101020 <fileread>
801059e9:	83 c4 10             	add    $0x10,%esp
}
801059ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059ef:	5b                   	pop    %ebx
801059f0:	5e                   	pop    %esi
801059f1:	5d                   	pop    %ebp
801059f2:	c3                   	ret    
801059f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059f7:	90                   	nop
    return -1;
801059f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059fd:	eb ed                	jmp    801059ec <sys_read+0x6c>
801059ff:	90                   	nop

80105a00 <sys_write>:
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	56                   	push   %esi
80105a04:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105a05:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105a08:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105a0b:	53                   	push   %ebx
80105a0c:	6a 00                	push   $0x0
80105a0e:	e8 9d fb ff ff       	call   801055b0 <argint>
80105a13:	83 c4 10             	add    $0x10,%esp
80105a16:	85 c0                	test   %eax,%eax
80105a18:	78 5e                	js     80105a78 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105a1a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105a1e:	77 58                	ja     80105a78 <sys_write+0x78>
80105a20:	e8 6b e2 ff ff       	call   80103c90 <myproc>
80105a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a28:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105a2c:	85 f6                	test   %esi,%esi
80105a2e:	74 48                	je     80105a78 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a30:	83 ec 08             	sub    $0x8,%esp
80105a33:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a36:	50                   	push   %eax
80105a37:	6a 02                	push   $0x2
80105a39:	e8 72 fb ff ff       	call   801055b0 <argint>
80105a3e:	83 c4 10             	add    $0x10,%esp
80105a41:	85 c0                	test   %eax,%eax
80105a43:	78 33                	js     80105a78 <sys_write+0x78>
80105a45:	83 ec 04             	sub    $0x4,%esp
80105a48:	ff 75 f0             	push   -0x10(%ebp)
80105a4b:	53                   	push   %ebx
80105a4c:	6a 01                	push   $0x1
80105a4e:	e8 ad fb ff ff       	call   80105600 <argptr>
80105a53:	83 c4 10             	add    $0x10,%esp
80105a56:	85 c0                	test   %eax,%eax
80105a58:	78 1e                	js     80105a78 <sys_write+0x78>
  return filewrite(f, p, n);
80105a5a:	83 ec 04             	sub    $0x4,%esp
80105a5d:	ff 75 f0             	push   -0x10(%ebp)
80105a60:	ff 75 f4             	push   -0xc(%ebp)
80105a63:	56                   	push   %esi
80105a64:	e8 47 b6 ff ff       	call   801010b0 <filewrite>
80105a69:	83 c4 10             	add    $0x10,%esp
}
80105a6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a6f:	5b                   	pop    %ebx
80105a70:	5e                   	pop    %esi
80105a71:	5d                   	pop    %ebp
80105a72:	c3                   	ret    
80105a73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a77:	90                   	nop
    return -1;
80105a78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a7d:	eb ed                	jmp    80105a6c <sys_write+0x6c>
80105a7f:	90                   	nop

80105a80 <sys_close>:
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	56                   	push   %esi
80105a84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105a85:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105a8b:	50                   	push   %eax
80105a8c:	6a 00                	push   $0x0
80105a8e:	e8 1d fb ff ff       	call   801055b0 <argint>
80105a93:	83 c4 10             	add    $0x10,%esp
80105a96:	85 c0                	test   %eax,%eax
80105a98:	78 3e                	js     80105ad8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105a9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105a9e:	77 38                	ja     80105ad8 <sys_close+0x58>
80105aa0:	e8 eb e1 ff ff       	call   80103c90 <myproc>
80105aa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105aa8:	8d 5a 08             	lea    0x8(%edx),%ebx
80105aab:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80105aaf:	85 f6                	test   %esi,%esi
80105ab1:	74 25                	je     80105ad8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105ab3:	e8 d8 e1 ff ff       	call   80103c90 <myproc>
  fileclose(f);
80105ab8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105abb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105ac2:	00 
  fileclose(f);
80105ac3:	56                   	push   %esi
80105ac4:	e8 27 b4 ff ff       	call   80100ef0 <fileclose>
  return 0;
80105ac9:	83 c4 10             	add    $0x10,%esp
80105acc:	31 c0                	xor    %eax,%eax
}
80105ace:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ad1:	5b                   	pop    %ebx
80105ad2:	5e                   	pop    %esi
80105ad3:	5d                   	pop    %ebp
80105ad4:	c3                   	ret    
80105ad5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ad8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105add:	eb ef                	jmp    80105ace <sys_close+0x4e>
80105adf:	90                   	nop

80105ae0 <sys_fstat>:
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	56                   	push   %esi
80105ae4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105ae5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105ae8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105aeb:	53                   	push   %ebx
80105aec:	6a 00                	push   $0x0
80105aee:	e8 bd fa ff ff       	call   801055b0 <argint>
80105af3:	83 c4 10             	add    $0x10,%esp
80105af6:	85 c0                	test   %eax,%eax
80105af8:	78 46                	js     80105b40 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105afa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105afe:	77 40                	ja     80105b40 <sys_fstat+0x60>
80105b00:	e8 8b e1 ff ff       	call   80103c90 <myproc>
80105b05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b08:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105b0c:	85 f6                	test   %esi,%esi
80105b0e:	74 30                	je     80105b40 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105b10:	83 ec 04             	sub    $0x4,%esp
80105b13:	6a 14                	push   $0x14
80105b15:	53                   	push   %ebx
80105b16:	6a 01                	push   $0x1
80105b18:	e8 e3 fa ff ff       	call   80105600 <argptr>
80105b1d:	83 c4 10             	add    $0x10,%esp
80105b20:	85 c0                	test   %eax,%eax
80105b22:	78 1c                	js     80105b40 <sys_fstat+0x60>
  return filestat(f, st);
80105b24:	83 ec 08             	sub    $0x8,%esp
80105b27:	ff 75 f4             	push   -0xc(%ebp)
80105b2a:	56                   	push   %esi
80105b2b:	e8 a0 b4 ff ff       	call   80100fd0 <filestat>
80105b30:	83 c4 10             	add    $0x10,%esp
}
80105b33:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b36:	5b                   	pop    %ebx
80105b37:	5e                   	pop    %esi
80105b38:	5d                   	pop    %ebp
80105b39:	c3                   	ret    
80105b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b45:	eb ec                	jmp    80105b33 <sys_fstat+0x53>
80105b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b4e:	66 90                	xchg   %ax,%ax

80105b50 <sys_link>:
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	57                   	push   %edi
80105b54:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105b55:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105b58:	53                   	push   %ebx
80105b59:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105b5c:	50                   	push   %eax
80105b5d:	6a 00                	push   $0x0
80105b5f:	e8 0c fb ff ff       	call   80105670 <argstr>
80105b64:	83 c4 10             	add    $0x10,%esp
80105b67:	85 c0                	test   %eax,%eax
80105b69:	0f 88 fb 00 00 00    	js     80105c6a <sys_link+0x11a>
80105b6f:	83 ec 08             	sub    $0x8,%esp
80105b72:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105b75:	50                   	push   %eax
80105b76:	6a 01                	push   $0x1
80105b78:	e8 f3 fa ff ff       	call   80105670 <argstr>
80105b7d:	83 c4 10             	add    $0x10,%esp
80105b80:	85 c0                	test   %eax,%eax
80105b82:	0f 88 e2 00 00 00    	js     80105c6a <sys_link+0x11a>
  begin_op();
80105b88:	e8 d3 d1 ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
80105b8d:	83 ec 0c             	sub    $0xc,%esp
80105b90:	ff 75 d4             	push   -0x2c(%ebp)
80105b93:	e8 08 c5 ff ff       	call   801020a0 <namei>
80105b98:	83 c4 10             	add    $0x10,%esp
80105b9b:	89 c3                	mov    %eax,%ebx
80105b9d:	85 c0                	test   %eax,%eax
80105b9f:	0f 84 e4 00 00 00    	je     80105c89 <sys_link+0x139>
  ilock(ip);
80105ba5:	83 ec 0c             	sub    $0xc,%esp
80105ba8:	50                   	push   %eax
80105ba9:	e8 d2 bb ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
80105bae:	83 c4 10             	add    $0x10,%esp
80105bb1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105bb6:	0f 84 b5 00 00 00    	je     80105c71 <sys_link+0x121>
  iupdate(ip);
80105bbc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105bbf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105bc4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105bc7:	53                   	push   %ebx
80105bc8:	e8 03 bb ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
80105bcd:	89 1c 24             	mov    %ebx,(%esp)
80105bd0:	e8 8b bc ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105bd5:	58                   	pop    %eax
80105bd6:	5a                   	pop    %edx
80105bd7:	57                   	push   %edi
80105bd8:	ff 75 d0             	push   -0x30(%ebp)
80105bdb:	e8 e0 c4 ff ff       	call   801020c0 <nameiparent>
80105be0:	83 c4 10             	add    $0x10,%esp
80105be3:	89 c6                	mov    %eax,%esi
80105be5:	85 c0                	test   %eax,%eax
80105be7:	74 5b                	je     80105c44 <sys_link+0xf4>
  ilock(dp);
80105be9:	83 ec 0c             	sub    $0xc,%esp
80105bec:	50                   	push   %eax
80105bed:	e8 8e bb ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105bf2:	8b 03                	mov    (%ebx),%eax
80105bf4:	83 c4 10             	add    $0x10,%esp
80105bf7:	39 06                	cmp    %eax,(%esi)
80105bf9:	75 3d                	jne    80105c38 <sys_link+0xe8>
80105bfb:	83 ec 04             	sub    $0x4,%esp
80105bfe:	ff 73 04             	push   0x4(%ebx)
80105c01:	57                   	push   %edi
80105c02:	56                   	push   %esi
80105c03:	e8 d8 c3 ff ff       	call   80101fe0 <dirlink>
80105c08:	83 c4 10             	add    $0x10,%esp
80105c0b:	85 c0                	test   %eax,%eax
80105c0d:	78 29                	js     80105c38 <sys_link+0xe8>
  iunlockput(dp);
80105c0f:	83 ec 0c             	sub    $0xc,%esp
80105c12:	56                   	push   %esi
80105c13:	e8 f8 bd ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105c18:	89 1c 24             	mov    %ebx,(%esp)
80105c1b:	e8 90 bc ff ff       	call   801018b0 <iput>
  end_op();
80105c20:	e8 ab d1 ff ff       	call   80102dd0 <end_op>
  return 0;
80105c25:	83 c4 10             	add    $0x10,%esp
80105c28:	31 c0                	xor    %eax,%eax
}
80105c2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c2d:	5b                   	pop    %ebx
80105c2e:	5e                   	pop    %esi
80105c2f:	5f                   	pop    %edi
80105c30:	5d                   	pop    %ebp
80105c31:	c3                   	ret    
80105c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105c38:	83 ec 0c             	sub    $0xc,%esp
80105c3b:	56                   	push   %esi
80105c3c:	e8 cf bd ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105c41:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105c44:	83 ec 0c             	sub    $0xc,%esp
80105c47:	53                   	push   %ebx
80105c48:	e8 33 bb ff ff       	call   80101780 <ilock>
  ip->nlink--;
80105c4d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105c52:	89 1c 24             	mov    %ebx,(%esp)
80105c55:	e8 76 ba ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105c5a:	89 1c 24             	mov    %ebx,(%esp)
80105c5d:	e8 ae bd ff ff       	call   80101a10 <iunlockput>
  end_op();
80105c62:	e8 69 d1 ff ff       	call   80102dd0 <end_op>
  return -1;
80105c67:	83 c4 10             	add    $0x10,%esp
80105c6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c6f:	eb b9                	jmp    80105c2a <sys_link+0xda>
    iunlockput(ip);
80105c71:	83 ec 0c             	sub    $0xc,%esp
80105c74:	53                   	push   %ebx
80105c75:	e8 96 bd ff ff       	call   80101a10 <iunlockput>
    end_op();
80105c7a:	e8 51 d1 ff ff       	call   80102dd0 <end_op>
    return -1;
80105c7f:	83 c4 10             	add    $0x10,%esp
80105c82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c87:	eb a1                	jmp    80105c2a <sys_link+0xda>
    end_op();
80105c89:	e8 42 d1 ff ff       	call   80102dd0 <end_op>
    return -1;
80105c8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c93:	eb 95                	jmp    80105c2a <sys_link+0xda>
80105c95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ca0 <sys_unlink>:
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	57                   	push   %edi
80105ca4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105ca5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105ca8:	53                   	push   %ebx
80105ca9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105cac:	50                   	push   %eax
80105cad:	6a 00                	push   $0x0
80105caf:	e8 bc f9 ff ff       	call   80105670 <argstr>
80105cb4:	83 c4 10             	add    $0x10,%esp
80105cb7:	85 c0                	test   %eax,%eax
80105cb9:	0f 88 7a 01 00 00    	js     80105e39 <sys_unlink+0x199>
  begin_op();
80105cbf:	e8 9c d0 ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105cc4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105cc7:	83 ec 08             	sub    $0x8,%esp
80105cca:	53                   	push   %ebx
80105ccb:	ff 75 c0             	push   -0x40(%ebp)
80105cce:	e8 ed c3 ff ff       	call   801020c0 <nameiparent>
80105cd3:	83 c4 10             	add    $0x10,%esp
80105cd6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105cd9:	85 c0                	test   %eax,%eax
80105cdb:	0f 84 62 01 00 00    	je     80105e43 <sys_unlink+0x1a3>
  ilock(dp);
80105ce1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105ce4:	83 ec 0c             	sub    $0xc,%esp
80105ce7:	57                   	push   %edi
80105ce8:	e8 93 ba ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105ced:	58                   	pop    %eax
80105cee:	5a                   	pop    %edx
80105cef:	68 38 88 10 80       	push   $0x80108838
80105cf4:	53                   	push   %ebx
80105cf5:	e8 c6 bf ff ff       	call   80101cc0 <namecmp>
80105cfa:	83 c4 10             	add    $0x10,%esp
80105cfd:	85 c0                	test   %eax,%eax
80105cff:	0f 84 fb 00 00 00    	je     80105e00 <sys_unlink+0x160>
80105d05:	83 ec 08             	sub    $0x8,%esp
80105d08:	68 37 88 10 80       	push   $0x80108837
80105d0d:	53                   	push   %ebx
80105d0e:	e8 ad bf ff ff       	call   80101cc0 <namecmp>
80105d13:	83 c4 10             	add    $0x10,%esp
80105d16:	85 c0                	test   %eax,%eax
80105d18:	0f 84 e2 00 00 00    	je     80105e00 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105d1e:	83 ec 04             	sub    $0x4,%esp
80105d21:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105d24:	50                   	push   %eax
80105d25:	53                   	push   %ebx
80105d26:	57                   	push   %edi
80105d27:	e8 b4 bf ff ff       	call   80101ce0 <dirlookup>
80105d2c:	83 c4 10             	add    $0x10,%esp
80105d2f:	89 c3                	mov    %eax,%ebx
80105d31:	85 c0                	test   %eax,%eax
80105d33:	0f 84 c7 00 00 00    	je     80105e00 <sys_unlink+0x160>
  ilock(ip);
80105d39:	83 ec 0c             	sub    $0xc,%esp
80105d3c:	50                   	push   %eax
80105d3d:	e8 3e ba ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105d42:	83 c4 10             	add    $0x10,%esp
80105d45:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105d4a:	0f 8e 1c 01 00 00    	jle    80105e6c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105d50:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d55:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105d58:	74 66                	je     80105dc0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105d5a:	83 ec 04             	sub    $0x4,%esp
80105d5d:	6a 10                	push   $0x10
80105d5f:	6a 00                	push   $0x0
80105d61:	57                   	push   %edi
80105d62:	e8 89 f5 ff ff       	call   801052f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d67:	6a 10                	push   $0x10
80105d69:	ff 75 c4             	push   -0x3c(%ebp)
80105d6c:	57                   	push   %edi
80105d6d:	ff 75 b4             	push   -0x4c(%ebp)
80105d70:	e8 1b be ff ff       	call   80101b90 <writei>
80105d75:	83 c4 20             	add    $0x20,%esp
80105d78:	83 f8 10             	cmp    $0x10,%eax
80105d7b:	0f 85 de 00 00 00    	jne    80105e5f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105d81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d86:	0f 84 94 00 00 00    	je     80105e20 <sys_unlink+0x180>
  iunlockput(dp);
80105d8c:	83 ec 0c             	sub    $0xc,%esp
80105d8f:	ff 75 b4             	push   -0x4c(%ebp)
80105d92:	e8 79 bc ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105d97:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105d9c:	89 1c 24             	mov    %ebx,(%esp)
80105d9f:	e8 2c b9 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105da4:	89 1c 24             	mov    %ebx,(%esp)
80105da7:	e8 64 bc ff ff       	call   80101a10 <iunlockput>
  end_op();
80105dac:	e8 1f d0 ff ff       	call   80102dd0 <end_op>
  return 0;
80105db1:	83 c4 10             	add    $0x10,%esp
80105db4:	31 c0                	xor    %eax,%eax
}
80105db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105db9:	5b                   	pop    %ebx
80105dba:	5e                   	pop    %esi
80105dbb:	5f                   	pop    %edi
80105dbc:	5d                   	pop    %ebp
80105dbd:	c3                   	ret    
80105dbe:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105dc0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105dc4:	76 94                	jbe    80105d5a <sys_unlink+0xba>
80105dc6:	be 20 00 00 00       	mov    $0x20,%esi
80105dcb:	eb 0b                	jmp    80105dd8 <sys_unlink+0x138>
80105dcd:	8d 76 00             	lea    0x0(%esi),%esi
80105dd0:	83 c6 10             	add    $0x10,%esi
80105dd3:	3b 73 58             	cmp    0x58(%ebx),%esi
80105dd6:	73 82                	jae    80105d5a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105dd8:	6a 10                	push   $0x10
80105dda:	56                   	push   %esi
80105ddb:	57                   	push   %edi
80105ddc:	53                   	push   %ebx
80105ddd:	e8 ae bc ff ff       	call   80101a90 <readi>
80105de2:	83 c4 10             	add    $0x10,%esp
80105de5:	83 f8 10             	cmp    $0x10,%eax
80105de8:	75 68                	jne    80105e52 <sys_unlink+0x1b2>
    if(de.inum != 0)
80105dea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105def:	74 df                	je     80105dd0 <sys_unlink+0x130>
    iunlockput(ip);
80105df1:	83 ec 0c             	sub    $0xc,%esp
80105df4:	53                   	push   %ebx
80105df5:	e8 16 bc ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105dfa:	83 c4 10             	add    $0x10,%esp
80105dfd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105e00:	83 ec 0c             	sub    $0xc,%esp
80105e03:	ff 75 b4             	push   -0x4c(%ebp)
80105e06:	e8 05 bc ff ff       	call   80101a10 <iunlockput>
  end_op();
80105e0b:	e8 c0 cf ff ff       	call   80102dd0 <end_op>
  return -1;
80105e10:	83 c4 10             	add    $0x10,%esp
80105e13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e18:	eb 9c                	jmp    80105db6 <sys_unlink+0x116>
80105e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105e20:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105e23:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105e26:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105e2b:	50                   	push   %eax
80105e2c:	e8 9f b8 ff ff       	call   801016d0 <iupdate>
80105e31:	83 c4 10             	add    $0x10,%esp
80105e34:	e9 53 ff ff ff       	jmp    80105d8c <sys_unlink+0xec>
    return -1;
80105e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e3e:	e9 73 ff ff ff       	jmp    80105db6 <sys_unlink+0x116>
    end_op();
80105e43:	e8 88 cf ff ff       	call   80102dd0 <end_op>
    return -1;
80105e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e4d:	e9 64 ff ff ff       	jmp    80105db6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105e52:	83 ec 0c             	sub    $0xc,%esp
80105e55:	68 5c 88 10 80       	push   $0x8010885c
80105e5a:	e8 21 a5 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105e5f:	83 ec 0c             	sub    $0xc,%esp
80105e62:	68 6e 88 10 80       	push   $0x8010886e
80105e67:	e8 14 a5 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105e6c:	83 ec 0c             	sub    $0xc,%esp
80105e6f:	68 4a 88 10 80       	push   $0x8010884a
80105e74:	e8 07 a5 ff ff       	call   80100380 <panic>
80105e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e80 <sys_open>:

int
sys_open(void)
{
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
80105e83:	57                   	push   %edi
80105e84:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e85:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105e88:	53                   	push   %ebx
80105e89:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e8c:	50                   	push   %eax
80105e8d:	6a 00                	push   $0x0
80105e8f:	e8 dc f7 ff ff       	call   80105670 <argstr>
80105e94:	83 c4 10             	add    $0x10,%esp
80105e97:	85 c0                	test   %eax,%eax
80105e99:	0f 88 8e 00 00 00    	js     80105f2d <sys_open+0xad>
80105e9f:	83 ec 08             	sub    $0x8,%esp
80105ea2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ea5:	50                   	push   %eax
80105ea6:	6a 01                	push   $0x1
80105ea8:	e8 03 f7 ff ff       	call   801055b0 <argint>
80105ead:	83 c4 10             	add    $0x10,%esp
80105eb0:	85 c0                	test   %eax,%eax
80105eb2:	78 79                	js     80105f2d <sys_open+0xad>
    return -1;

  begin_op();
80105eb4:	e8 a7 ce ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
80105eb9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105ebd:	75 79                	jne    80105f38 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105ebf:	83 ec 0c             	sub    $0xc,%esp
80105ec2:	ff 75 e0             	push   -0x20(%ebp)
80105ec5:	e8 d6 c1 ff ff       	call   801020a0 <namei>
80105eca:	83 c4 10             	add    $0x10,%esp
80105ecd:	89 c6                	mov    %eax,%esi
80105ecf:	85 c0                	test   %eax,%eax
80105ed1:	0f 84 7e 00 00 00    	je     80105f55 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105ed7:	83 ec 0c             	sub    $0xc,%esp
80105eda:	50                   	push   %eax
80105edb:	e8 a0 b8 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ee0:	83 c4 10             	add    $0x10,%esp
80105ee3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105ee8:	0f 84 c2 00 00 00    	je     80105fb0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105eee:	e8 3d af ff ff       	call   80100e30 <filealloc>
80105ef3:	89 c7                	mov    %eax,%edi
80105ef5:	85 c0                	test   %eax,%eax
80105ef7:	74 23                	je     80105f1c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105ef9:	e8 92 dd ff ff       	call   80103c90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105efe:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105f00:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105f04:	85 d2                	test   %edx,%edx
80105f06:	74 60                	je     80105f68 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105f08:	83 c3 01             	add    $0x1,%ebx
80105f0b:	83 fb 10             	cmp    $0x10,%ebx
80105f0e:	75 f0                	jne    80105f00 <sys_open+0x80>
    if(f)
      fileclose(f);
80105f10:	83 ec 0c             	sub    $0xc,%esp
80105f13:	57                   	push   %edi
80105f14:	e8 d7 af ff ff       	call   80100ef0 <fileclose>
80105f19:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105f1c:	83 ec 0c             	sub    $0xc,%esp
80105f1f:	56                   	push   %esi
80105f20:	e8 eb ba ff ff       	call   80101a10 <iunlockput>
    end_op();
80105f25:	e8 a6 ce ff ff       	call   80102dd0 <end_op>
    return -1;
80105f2a:	83 c4 10             	add    $0x10,%esp
80105f2d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f32:	eb 6d                	jmp    80105fa1 <sys_open+0x121>
80105f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105f38:	83 ec 0c             	sub    $0xc,%esp
80105f3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105f3e:	31 c9                	xor    %ecx,%ecx
80105f40:	ba 02 00 00 00       	mov    $0x2,%edx
80105f45:	6a 00                	push   $0x0
80105f47:	e8 14 f8 ff ff       	call   80105760 <create>
    if(ip == 0){
80105f4c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105f4f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105f51:	85 c0                	test   %eax,%eax
80105f53:	75 99                	jne    80105eee <sys_open+0x6e>
      end_op();
80105f55:	e8 76 ce ff ff       	call   80102dd0 <end_op>
      return -1;
80105f5a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f5f:	eb 40                	jmp    80105fa1 <sys_open+0x121>
80105f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105f68:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105f6b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105f6f:	56                   	push   %esi
80105f70:	e8 eb b8 ff ff       	call   80101860 <iunlock>
  end_op();
80105f75:	e8 56 ce ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
80105f7a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f83:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105f86:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105f89:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105f8b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105f92:	f7 d0                	not    %eax
80105f94:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f97:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105f9a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f9d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105fa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fa4:	89 d8                	mov    %ebx,%eax
80105fa6:	5b                   	pop    %ebx
80105fa7:	5e                   	pop    %esi
80105fa8:	5f                   	pop    %edi
80105fa9:	5d                   	pop    %ebp
80105faa:	c3                   	ret    
80105fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105faf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105fb0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105fb3:	85 c9                	test   %ecx,%ecx
80105fb5:	0f 84 33 ff ff ff    	je     80105eee <sys_open+0x6e>
80105fbb:	e9 5c ff ff ff       	jmp    80105f1c <sys_open+0x9c>

80105fc0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105fc6:	e8 95 cd ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105fcb:	83 ec 08             	sub    $0x8,%esp
80105fce:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fd1:	50                   	push   %eax
80105fd2:	6a 00                	push   $0x0
80105fd4:	e8 97 f6 ff ff       	call   80105670 <argstr>
80105fd9:	83 c4 10             	add    $0x10,%esp
80105fdc:	85 c0                	test   %eax,%eax
80105fde:	78 30                	js     80106010 <sys_mkdir+0x50>
80105fe0:	83 ec 0c             	sub    $0xc,%esp
80105fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe6:	31 c9                	xor    %ecx,%ecx
80105fe8:	ba 01 00 00 00       	mov    $0x1,%edx
80105fed:	6a 00                	push   $0x0
80105fef:	e8 6c f7 ff ff       	call   80105760 <create>
80105ff4:	83 c4 10             	add    $0x10,%esp
80105ff7:	85 c0                	test   %eax,%eax
80105ff9:	74 15                	je     80106010 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105ffb:	83 ec 0c             	sub    $0xc,%esp
80105ffe:	50                   	push   %eax
80105fff:	e8 0c ba ff ff       	call   80101a10 <iunlockput>
  end_op();
80106004:	e8 c7 cd ff ff       	call   80102dd0 <end_op>
  return 0;
80106009:	83 c4 10             	add    $0x10,%esp
8010600c:	31 c0                	xor    %eax,%eax
}
8010600e:	c9                   	leave  
8010600f:	c3                   	ret    
    end_op();
80106010:	e8 bb cd ff ff       	call   80102dd0 <end_op>
    return -1;
80106015:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010601a:	c9                   	leave  
8010601b:	c3                   	ret    
8010601c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106020 <sys_mknod>:

int
sys_mknod(void)
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106026:	e8 35 cd ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010602b:	83 ec 08             	sub    $0x8,%esp
8010602e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106031:	50                   	push   %eax
80106032:	6a 00                	push   $0x0
80106034:	e8 37 f6 ff ff       	call   80105670 <argstr>
80106039:	83 c4 10             	add    $0x10,%esp
8010603c:	85 c0                	test   %eax,%eax
8010603e:	78 60                	js     801060a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106040:	83 ec 08             	sub    $0x8,%esp
80106043:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106046:	50                   	push   %eax
80106047:	6a 01                	push   $0x1
80106049:	e8 62 f5 ff ff       	call   801055b0 <argint>
  if((argstr(0, &path)) < 0 ||
8010604e:	83 c4 10             	add    $0x10,%esp
80106051:	85 c0                	test   %eax,%eax
80106053:	78 4b                	js     801060a0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106055:	83 ec 08             	sub    $0x8,%esp
80106058:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010605b:	50                   	push   %eax
8010605c:	6a 02                	push   $0x2
8010605e:	e8 4d f5 ff ff       	call   801055b0 <argint>
     argint(1, &major) < 0 ||
80106063:	83 c4 10             	add    $0x10,%esp
80106066:	85 c0                	test   %eax,%eax
80106068:	78 36                	js     801060a0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010606a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010606e:	83 ec 0c             	sub    $0xc,%esp
80106071:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106075:	ba 03 00 00 00       	mov    $0x3,%edx
8010607a:	50                   	push   %eax
8010607b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010607e:	e8 dd f6 ff ff       	call   80105760 <create>
     argint(2, &minor) < 0 ||
80106083:	83 c4 10             	add    $0x10,%esp
80106086:	85 c0                	test   %eax,%eax
80106088:	74 16                	je     801060a0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010608a:	83 ec 0c             	sub    $0xc,%esp
8010608d:	50                   	push   %eax
8010608e:	e8 7d b9 ff ff       	call   80101a10 <iunlockput>
  end_op();
80106093:	e8 38 cd ff ff       	call   80102dd0 <end_op>
  return 0;
80106098:	83 c4 10             	add    $0x10,%esp
8010609b:	31 c0                	xor    %eax,%eax
}
8010609d:	c9                   	leave  
8010609e:	c3                   	ret    
8010609f:	90                   	nop
    end_op();
801060a0:	e8 2b cd ff ff       	call   80102dd0 <end_op>
    return -1;
801060a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060aa:	c9                   	leave  
801060ab:	c3                   	ret    
801060ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060b0 <sys_chdir>:

int
sys_chdir(void)
{
801060b0:	55                   	push   %ebp
801060b1:	89 e5                	mov    %esp,%ebp
801060b3:	56                   	push   %esi
801060b4:	53                   	push   %ebx
801060b5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801060b8:	e8 d3 db ff ff       	call   80103c90 <myproc>
801060bd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801060bf:	e8 9c cc ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801060c4:	83 ec 08             	sub    $0x8,%esp
801060c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060ca:	50                   	push   %eax
801060cb:	6a 00                	push   $0x0
801060cd:	e8 9e f5 ff ff       	call   80105670 <argstr>
801060d2:	83 c4 10             	add    $0x10,%esp
801060d5:	85 c0                	test   %eax,%eax
801060d7:	78 77                	js     80106150 <sys_chdir+0xa0>
801060d9:	83 ec 0c             	sub    $0xc,%esp
801060dc:	ff 75 f4             	push   -0xc(%ebp)
801060df:	e8 bc bf ff ff       	call   801020a0 <namei>
801060e4:	83 c4 10             	add    $0x10,%esp
801060e7:	89 c3                	mov    %eax,%ebx
801060e9:	85 c0                	test   %eax,%eax
801060eb:	74 63                	je     80106150 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801060ed:	83 ec 0c             	sub    $0xc,%esp
801060f0:	50                   	push   %eax
801060f1:	e8 8a b6 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
801060f6:	83 c4 10             	add    $0x10,%esp
801060f9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801060fe:	75 30                	jne    80106130 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106100:	83 ec 0c             	sub    $0xc,%esp
80106103:	53                   	push   %ebx
80106104:	e8 57 b7 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80106109:	58                   	pop    %eax
8010610a:	ff 76 68             	push   0x68(%esi)
8010610d:	e8 9e b7 ff ff       	call   801018b0 <iput>
  end_op();
80106112:	e8 b9 cc ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80106117:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010611a:	83 c4 10             	add    $0x10,%esp
8010611d:	31 c0                	xor    %eax,%eax
}
8010611f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106122:	5b                   	pop    %ebx
80106123:	5e                   	pop    %esi
80106124:	5d                   	pop    %ebp
80106125:	c3                   	ret    
80106126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010612d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80106130:	83 ec 0c             	sub    $0xc,%esp
80106133:	53                   	push   %ebx
80106134:	e8 d7 b8 ff ff       	call   80101a10 <iunlockput>
    end_op();
80106139:	e8 92 cc ff ff       	call   80102dd0 <end_op>
    return -1;
8010613e:	83 c4 10             	add    $0x10,%esp
80106141:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106146:	eb d7                	jmp    8010611f <sys_chdir+0x6f>
80106148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614f:	90                   	nop
    end_op();
80106150:	e8 7b cc ff ff       	call   80102dd0 <end_op>
    return -1;
80106155:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010615a:	eb c3                	jmp    8010611f <sys_chdir+0x6f>
8010615c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106160 <sys_exec>:

int
sys_exec(void)
{
80106160:	55                   	push   %ebp
80106161:	89 e5                	mov    %esp,%ebp
80106163:	57                   	push   %edi
80106164:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106165:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010616b:	53                   	push   %ebx
8010616c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106172:	50                   	push   %eax
80106173:	6a 00                	push   $0x0
80106175:	e8 f6 f4 ff ff       	call   80105670 <argstr>
8010617a:	83 c4 10             	add    $0x10,%esp
8010617d:	85 c0                	test   %eax,%eax
8010617f:	0f 88 87 00 00 00    	js     8010620c <sys_exec+0xac>
80106185:	83 ec 08             	sub    $0x8,%esp
80106188:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010618e:	50                   	push   %eax
8010618f:	6a 01                	push   $0x1
80106191:	e8 1a f4 ff ff       	call   801055b0 <argint>
80106196:	83 c4 10             	add    $0x10,%esp
80106199:	85 c0                	test   %eax,%eax
8010619b:	78 6f                	js     8010620c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010619d:	83 ec 04             	sub    $0x4,%esp
801061a0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801061a6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801061a8:	68 80 00 00 00       	push   $0x80
801061ad:	6a 00                	push   $0x0
801061af:	56                   	push   %esi
801061b0:	e8 3b f1 ff ff       	call   801052f0 <memset>
801061b5:	83 c4 10             	add    $0x10,%esp
801061b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061bf:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801061c0:	83 ec 08             	sub    $0x8,%esp
801061c3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801061c9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801061d0:	50                   	push   %eax
801061d1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801061d7:	01 f8                	add    %edi,%eax
801061d9:	50                   	push   %eax
801061da:	e8 41 f3 ff ff       	call   80105520 <fetchint>
801061df:	83 c4 10             	add    $0x10,%esp
801061e2:	85 c0                	test   %eax,%eax
801061e4:	78 26                	js     8010620c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801061e6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801061ec:	85 c0                	test   %eax,%eax
801061ee:	74 30                	je     80106220 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801061f0:	83 ec 08             	sub    $0x8,%esp
801061f3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801061f6:	52                   	push   %edx
801061f7:	50                   	push   %eax
801061f8:	e8 63 f3 ff ff       	call   80105560 <fetchstr>
801061fd:	83 c4 10             	add    $0x10,%esp
80106200:	85 c0                	test   %eax,%eax
80106202:	78 08                	js     8010620c <sys_exec+0xac>
  for(i=0;; i++){
80106204:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106207:	83 fb 20             	cmp    $0x20,%ebx
8010620a:	75 b4                	jne    801061c0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010620c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010620f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106214:	5b                   	pop    %ebx
80106215:	5e                   	pop    %esi
80106216:	5f                   	pop    %edi
80106217:	5d                   	pop    %ebp
80106218:	c3                   	ret    
80106219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106220:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106227:	00 00 00 00 
  return exec(path, argv);
8010622b:	83 ec 08             	sub    $0x8,%esp
8010622e:	56                   	push   %esi
8010622f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80106235:	e8 76 a8 ff ff       	call   80100ab0 <exec>
8010623a:	83 c4 10             	add    $0x10,%esp
}
8010623d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106240:	5b                   	pop    %ebx
80106241:	5e                   	pop    %esi
80106242:	5f                   	pop    %edi
80106243:	5d                   	pop    %ebp
80106244:	c3                   	ret    
80106245:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010624c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106250 <sys_pipe>:

int
sys_pipe(void)
{
80106250:	55                   	push   %ebp
80106251:	89 e5                	mov    %esp,%ebp
80106253:	57                   	push   %edi
80106254:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106255:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106258:	53                   	push   %ebx
80106259:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010625c:	6a 08                	push   $0x8
8010625e:	50                   	push   %eax
8010625f:	6a 00                	push   $0x0
80106261:	e8 9a f3 ff ff       	call   80105600 <argptr>
80106266:	83 c4 10             	add    $0x10,%esp
80106269:	85 c0                	test   %eax,%eax
8010626b:	78 4a                	js     801062b7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010626d:	83 ec 08             	sub    $0x8,%esp
80106270:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106273:	50                   	push   %eax
80106274:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106277:	50                   	push   %eax
80106278:	e8 b3 d1 ff ff       	call   80103430 <pipealloc>
8010627d:	83 c4 10             	add    $0x10,%esp
80106280:	85 c0                	test   %eax,%eax
80106282:	78 33                	js     801062b7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106284:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106287:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106289:	e8 02 da ff ff       	call   80103c90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010628e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106290:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106294:	85 f6                	test   %esi,%esi
80106296:	74 28                	je     801062c0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80106298:	83 c3 01             	add    $0x1,%ebx
8010629b:	83 fb 10             	cmp    $0x10,%ebx
8010629e:	75 f0                	jne    80106290 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801062a0:	83 ec 0c             	sub    $0xc,%esp
801062a3:	ff 75 e0             	push   -0x20(%ebp)
801062a6:	e8 45 ac ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
801062ab:	58                   	pop    %eax
801062ac:	ff 75 e4             	push   -0x1c(%ebp)
801062af:	e8 3c ac ff ff       	call   80100ef0 <fileclose>
    return -1;
801062b4:	83 c4 10             	add    $0x10,%esp
801062b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062bc:	eb 53                	jmp    80106311 <sys_pipe+0xc1>
801062be:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801062c0:	8d 73 08             	lea    0x8(%ebx),%esi
801062c3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801062c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801062ca:	e8 c1 d9 ff ff       	call   80103c90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801062cf:	31 d2                	xor    %edx,%edx
801062d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801062d8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801062dc:	85 c9                	test   %ecx,%ecx
801062de:	74 20                	je     80106300 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801062e0:	83 c2 01             	add    $0x1,%edx
801062e3:	83 fa 10             	cmp    $0x10,%edx
801062e6:	75 f0                	jne    801062d8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801062e8:	e8 a3 d9 ff ff       	call   80103c90 <myproc>
801062ed:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801062f4:	00 
801062f5:	eb a9                	jmp    801062a0 <sys_pipe+0x50>
801062f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062fe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106300:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106304:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106307:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106309:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010630c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010630f:	31 c0                	xor    %eax,%eax
}
80106311:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106314:	5b                   	pop    %ebx
80106315:	5e                   	pop    %esi
80106316:	5f                   	pop    %edi
80106317:	5d                   	pop    %ebp
80106318:	c3                   	ret    
80106319:	66 90                	xchg   %ax,%ax
8010631b:	66 90                	xchg   %ax,%ax
8010631d:	66 90                	xchg   %ax,%ax
8010631f:	90                   	nop

80106320 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80106320:	e9 8b db ff ff       	jmp    80103eb0 <fork>
80106325:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010632c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106330 <sys_exit>:
}

int
sys_exit(void)
{
80106330:	55                   	push   %ebp
80106331:	89 e5                	mov    %esp,%ebp
80106333:	83 ec 08             	sub    $0x8,%esp
  exit();
80106336:	e8 95 e0 ff ff       	call   801043d0 <exit>
  return 0;  // not reached
}
8010633b:	31 c0                	xor    %eax,%eax
8010633d:	c9                   	leave  
8010633e:	c3                   	ret    
8010633f:	90                   	nop

80106340 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80106340:	e9 0b e3 ff ff       	jmp    80104650 <wait>
80106345:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010634c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106350 <sys_kill>:
}

int
sys_kill(void)
{
80106350:	55                   	push   %ebp
80106351:	89 e5                	mov    %esp,%ebp
80106353:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106356:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106359:	50                   	push   %eax
8010635a:	6a 00                	push   $0x0
8010635c:	e8 4f f2 ff ff       	call   801055b0 <argint>
80106361:	83 c4 10             	add    $0x10,%esp
80106364:	85 c0                	test   %eax,%eax
80106366:	78 18                	js     80106380 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106368:	83 ec 0c             	sub    $0xc,%esp
8010636b:	ff 75 f4             	push   -0xc(%ebp)
8010636e:	e8 8d e5 ff ff       	call   80104900 <kill>
80106373:	83 c4 10             	add    $0x10,%esp
}
80106376:	c9                   	leave  
80106377:	c3                   	ret    
80106378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010637f:	90                   	nop
80106380:	c9                   	leave  
    return -1;
80106381:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106386:	c3                   	ret    
80106387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010638e:	66 90                	xchg   %ax,%ax

80106390 <sys_getpid>:

int
sys_getpid(void)
{
80106390:	55                   	push   %ebp
80106391:	89 e5                	mov    %esp,%ebp
80106393:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106396:	e8 f5 d8 ff ff       	call   80103c90 <myproc>
8010639b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010639e:	c9                   	leave  
8010639f:	c3                   	ret    

801063a0 <sys_sbrk>:

int
sys_sbrk(void)
{
801063a0:	55                   	push   %ebp
801063a1:	89 e5                	mov    %esp,%ebp
801063a3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801063a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801063a7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801063aa:	50                   	push   %eax
801063ab:	6a 00                	push   $0x0
801063ad:	e8 fe f1 ff ff       	call   801055b0 <argint>
801063b2:	83 c4 10             	add    $0x10,%esp
801063b5:	85 c0                	test   %eax,%eax
801063b7:	78 27                	js     801063e0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801063b9:	e8 d2 d8 ff ff       	call   80103c90 <myproc>
  if(growproc(n) < 0)
801063be:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801063c1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801063c3:	ff 75 f4             	push   -0xc(%ebp)
801063c6:	e8 65 da ff ff       	call   80103e30 <growproc>
801063cb:	83 c4 10             	add    $0x10,%esp
801063ce:	85 c0                	test   %eax,%eax
801063d0:	78 0e                	js     801063e0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801063d2:	89 d8                	mov    %ebx,%eax
801063d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801063d7:	c9                   	leave  
801063d8:	c3                   	ret    
801063d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801063e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801063e5:	eb eb                	jmp    801063d2 <sys_sbrk+0x32>
801063e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063ee:	66 90                	xchg   %ax,%ax

801063f0 <sys_sleep>:

int
sys_sleep(void)
{
801063f0:	55                   	push   %ebp
801063f1:	89 e5                	mov    %esp,%ebp
801063f3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801063f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801063f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801063fa:	50                   	push   %eax
801063fb:	6a 00                	push   $0x0
801063fd:	e8 ae f1 ff ff       	call   801055b0 <argint>
80106402:	83 c4 10             	add    $0x10,%esp
80106405:	85 c0                	test   %eax,%eax
80106407:	0f 88 8a 00 00 00    	js     80106497 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010640d:	83 ec 0c             	sub    $0xc,%esp
80106410:	68 20 56 11 80       	push   $0x80115620
80106415:	e8 16 ee ff ff       	call   80105230 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010641a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010641d:	8b 1d 00 56 11 80    	mov    0x80115600,%ebx
  while(ticks - ticks0 < n){
80106423:	83 c4 10             	add    $0x10,%esp
80106426:	85 d2                	test   %edx,%edx
80106428:	75 27                	jne    80106451 <sys_sleep+0x61>
8010642a:	eb 54                	jmp    80106480 <sys_sleep+0x90>
8010642c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106430:	83 ec 08             	sub    $0x8,%esp
80106433:	68 20 56 11 80       	push   $0x80115620
80106438:	68 00 56 11 80       	push   $0x80115600
8010643d:	e8 9e e3 ff ff       	call   801047e0 <sleep>
  while(ticks - ticks0 < n){
80106442:	a1 00 56 11 80       	mov    0x80115600,%eax
80106447:	83 c4 10             	add    $0x10,%esp
8010644a:	29 d8                	sub    %ebx,%eax
8010644c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010644f:	73 2f                	jae    80106480 <sys_sleep+0x90>
    if(myproc()->killed){
80106451:	e8 3a d8 ff ff       	call   80103c90 <myproc>
80106456:	8b 40 24             	mov    0x24(%eax),%eax
80106459:	85 c0                	test   %eax,%eax
8010645b:	74 d3                	je     80106430 <sys_sleep+0x40>
      release(&tickslock);
8010645d:	83 ec 0c             	sub    $0xc,%esp
80106460:	68 20 56 11 80       	push   $0x80115620
80106465:	e8 66 ed ff ff       	call   801051d0 <release>
  }
  release(&tickslock);
  return 0;
}
8010646a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010646d:	83 c4 10             	add    $0x10,%esp
80106470:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106475:	c9                   	leave  
80106476:	c3                   	ret    
80106477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010647e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106480:	83 ec 0c             	sub    $0xc,%esp
80106483:	68 20 56 11 80       	push   $0x80115620
80106488:	e8 43 ed ff ff       	call   801051d0 <release>
  return 0;
8010648d:	83 c4 10             	add    $0x10,%esp
80106490:	31 c0                	xor    %eax,%eax
}
80106492:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106495:	c9                   	leave  
80106496:	c3                   	ret    
    return -1;
80106497:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010649c:	eb f4                	jmp    80106492 <sys_sleep+0xa2>
8010649e:	66 90                	xchg   %ax,%ax

801064a0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	53                   	push   %ebx
801064a4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801064a7:	68 20 56 11 80       	push   $0x80115620
801064ac:	e8 7f ed ff ff       	call   80105230 <acquire>
  xticks = ticks;
801064b1:	8b 1d 00 56 11 80    	mov    0x80115600,%ebx
  release(&tickslock);
801064b7:	c7 04 24 20 56 11 80 	movl   $0x80115620,(%esp)
801064be:	e8 0d ed ff ff       	call   801051d0 <release>
  return xticks;
}
801064c3:	89 d8                	mov    %ebx,%eax
801064c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064c8:	c9                   	leave  
801064c9:	c3                   	ret    
801064ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801064d0 <sys_getgpid>:

int 
sys_getgpid(void)
{
801064d0:	55                   	push   %ebp
801064d1:	89 e5                	mov    %esp,%ebp
801064d3:	83 ec 08             	sub    $0x8,%esp
  struct proc* culproc = myproc();
801064d6:	e8 b5 d7 ff ff       	call   80103c90 <myproc>

  struct proc* pproc = culproc -> parent;
801064db:	8b 40 14             	mov    0x14(%eax),%eax
  if (pproc == 0) return -1;
801064de:	85 c0                	test   %eax,%eax
801064e0:	74 0c                	je     801064ee <sys_getgpid+0x1e>
  struct proc* gpproc = pproc -> parent;
801064e2:	8b 40 14             	mov    0x14(%eax),%eax
  if (gpproc == 0) return -1;
801064e5:	85 c0                	test   %eax,%eax
801064e7:	74 05                	je     801064ee <sys_getgpid+0x1e>

  return gpproc -> pid;
801064e9:	8b 40 10             	mov    0x10(%eax),%eax
}
801064ec:	c9                   	leave  
801064ed:	c3                   	ret    
801064ee:	c9                   	leave  
  if (pproc == 0) return -1;
801064ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064f4:	c3                   	ret    
801064f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106500 <sys_printpinfo>:

int
sys_printpinfo(void)
{   
80106500:	55                   	push   %ebp
80106501:	89 e5                	mov    %esp,%ebp
80106503:	56                   	push   %esi
80106504:	53                   	push   %ebx
  struct proc* p = myproc();
80106505:	e8 86 d7 ff ff       	call   80103c90 <myproc>
  uint xticks;

  acquire(&tickslock);
8010650a:	83 ec 0c             	sub    $0xc,%esp
8010650d:	68 20 56 11 80       	push   $0x80115620
  struct proc* p = myproc();
80106512:	89 c3                	mov    %eax,%ebx
  acquire(&tickslock);
80106514:	e8 17 ed ff ff       	call   80105230 <acquire>
  xticks = ticks;
80106519:	8b 35 00 56 11 80    	mov    0x80115600,%esi
  release(&tickslock);
8010651f:	c7 04 24 20 56 11 80 	movl   $0x80115620,(%esp)
80106526:	e8 a5 ec ff ff       	call   801051d0 <release>

  cprintf("ticks = %d, pid = %d, name = %s\n", xticks, p->pid, p->name);
8010652b:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010652e:	50                   	push   %eax
8010652f:	ff 73 10             	push   0x10(%ebx)
80106532:	56                   	push   %esi
80106533:	68 80 88 10 80       	push   $0x80108880
80106538:	e8 63 a1 ff ff       	call   801006a0 <cprintf>
  return 0;
}
8010653d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106540:	31 c0                	xor    %eax,%eax
80106542:	5b                   	pop    %ebx
80106543:	5e                   	pop    %esi
80106544:	5d                   	pop    %ebp
80106545:	c3                   	ret    
80106546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010654d:	8d 76 00             	lea    0x0(%esi),%esi

80106550 <sys_yield>:


int 
sys_yield(void)
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	83 ec 08             	sub    $0x8,%esp
  yield();
80106556:	e8 25 e2 ff ff       	call   80104780 <yield>
  return 0;
}
8010655b:	31 c0                	xor    %eax,%eax
8010655d:	c9                   	leave  
8010655e:	c3                   	ret    
8010655f:	90                   	nop

80106560 <sys_getlev>:

int
sys_getlev(void)
{
  return getlev();
80106560:	e9 0b e6 ff ff       	jmp    80104b70 <getlev>
80106565:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010656c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106570 <sys_setpriority>:
}

int 
sys_setpriority(void)
{  
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
80106573:	83 ec 20             	sub    $0x20,%esp
  int pid, priority;

  if(argint(0, &pid) < 0)
80106576:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106579:	50                   	push   %eax
8010657a:	6a 00                	push   $0x0
8010657c:	e8 2f f0 ff ff       	call   801055b0 <argint>
80106581:	83 c4 10             	add    $0x10,%esp
80106584:	85 c0                	test   %eax,%eax
80106586:	78 28                	js     801065b0 <sys_setpriority+0x40>
    return -1;
  if(argint(1, &priority) < 0)
80106588:	83 ec 08             	sub    $0x8,%esp
8010658b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010658e:	50                   	push   %eax
8010658f:	6a 01                	push   $0x1
80106591:	e8 1a f0 ff ff       	call   801055b0 <argint>
80106596:	83 c4 10             	add    $0x10,%esp
80106599:	85 c0                	test   %eax,%eax
8010659b:	78 23                	js     801065c0 <sys_setpriority+0x50>
    return -2;

  return setpriority(pid, priority);
8010659d:	83 ec 08             	sub    $0x8,%esp
801065a0:	ff 75 f4             	push   -0xc(%ebp)
801065a3:	ff 75 f0             	push   -0x10(%ebp)
801065a6:	e8 05 e6 ff ff       	call   80104bb0 <setpriority>
801065ab:	83 c4 10             	add    $0x10,%esp
}
801065ae:	c9                   	leave  
801065af:	c3                   	ret    
801065b0:	c9                   	leave  
    return -1;
801065b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065b6:	c3                   	ret    
801065b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065be:	66 90                	xchg   %ax,%ax
801065c0:	c9                   	leave  
    return -2;
801065c1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
801065c6:	c3                   	ret    
801065c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ce:	66 90                	xchg   %ax,%ax

801065d0 <sys_setmonopoly>:

int
sys_setmonopoly(void)
{
801065d0:	55                   	push   %ebp
801065d1:	89 e5                	mov    %esp,%ebp
801065d3:	83 ec 20             	sub    $0x20,%esp
  int pid, password;

  if(argint(0, &pid) < 0)
801065d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065d9:	50                   	push   %eax
801065da:	6a 00                	push   $0x0
801065dc:	e8 cf ef ff ff       	call   801055b0 <argint>
801065e1:	83 c4 10             	add    $0x10,%esp
801065e4:	85 c0                	test   %eax,%eax
801065e6:	78 28                	js     80106610 <sys_setmonopoly+0x40>
    return -1;
  if(argint(1, &password) < 0)
801065e8:	83 ec 08             	sub    $0x8,%esp
801065eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065ee:	50                   	push   %eax
801065ef:	6a 01                	push   $0x1
801065f1:	e8 ba ef ff ff       	call   801055b0 <argint>
801065f6:	83 c4 10             	add    $0x10,%esp
801065f9:	85 c0                	test   %eax,%eax
801065fb:	78 23                	js     80106620 <sys_setmonopoly+0x50>
    return -2;

  return setmonopoly(pid, password);
801065fd:	83 ec 08             	sub    $0x8,%esp
80106600:	ff 75 f4             	push   -0xc(%ebp)
80106603:	ff 75 f0             	push   -0x10(%ebp)
80106606:	e8 35 e7 ff ff       	call   80104d40 <setmonopoly>
8010660b:	83 c4 10             	add    $0x10,%esp
}
8010660e:	c9                   	leave  
8010660f:	c3                   	ret    
80106610:	c9                   	leave  
    return -1;
80106611:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106616:	c3                   	ret    
80106617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010661e:	66 90                	xchg   %ax,%ax
80106620:	c9                   	leave  
    return -2;
80106621:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
80106626:	c3                   	ret    
80106627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010662e:	66 90                	xchg   %ax,%ax

80106630 <sys_monopolize>:

int 
sys_monopolize(void)
{ 
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	83 ec 08             	sub    $0x8,%esp
  monopolize();
80106636:	e8 f5 e7 ff ff       	call   80104e30 <monopolize>
  return 0;
}
8010663b:	31 c0                	xor    %eax,%eax
8010663d:	c9                   	leave  
8010663e:	c3                   	ret    
8010663f:	90                   	nop

80106640 <sys_unmonopolize>:

int
sys_unmonopolize(void)
{
80106640:	55                   	push   %ebp
80106641:	89 e5                	mov    %esp,%ebp
80106643:	83 ec 08             	sub    $0x8,%esp
  unmonopolize();
80106646:	e8 55 e8 ff ff       	call   80104ea0 <unmonopolize>
  return 0;
8010664b:	31 c0                	xor    %eax,%eax
8010664d:	c9                   	leave  
8010664e:	c3                   	ret    

8010664f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010664f:	1e                   	push   %ds
  pushl %es
80106650:	06                   	push   %es
  pushl %fs
80106651:	0f a0                	push   %fs
  pushl %gs
80106653:	0f a8                	push   %gs
  pushal
80106655:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106656:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010665a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010665c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010665e:	54                   	push   %esp
  call trap
8010665f:	e8 ec 00 00 00       	call   80106750 <trap>
  addl $4, %esp
80106664:	83 c4 04             	add    $0x4,%esp

80106667 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106667:	61                   	popa   
  popl %gs
80106668:	0f a9                	pop    %gs
  popl %fs
8010666a:	0f a1                	pop    %fs
  popl %es
8010666c:	07                   	pop    %es
  popl %ds
8010666d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010666e:	83 c4 08             	add    $0x8,%esp
  iret
80106671:	cf                   	iret   
80106672:	66 90                	xchg   %ax,%ax
80106674:	66 90                	xchg   %ax,%ax
80106676:	66 90                	xchg   %ax,%ax
80106678:	66 90                	xchg   %ax,%ax
8010667a:	66 90                	xchg   %ax,%ax
8010667c:	66 90                	xchg   %ax,%ax
8010667e:	66 90                	xchg   %ax,%ax

80106680 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106680:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106681:	31 c0                	xor    %eax,%eax
{
80106683:	89 e5                	mov    %esp,%ebp
80106685:	83 ec 08             	sub    $0x8,%esp
80106688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010668f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106690:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106697:	c7 04 c5 62 56 11 80 	movl   $0x8e000008,-0x7feea99e(,%eax,8)
8010669e:	08 00 00 8e 
801066a2:	66 89 14 c5 60 56 11 	mov    %dx,-0x7feea9a0(,%eax,8)
801066a9:	80 
801066aa:	c1 ea 10             	shr    $0x10,%edx
801066ad:	66 89 14 c5 66 56 11 	mov    %dx,-0x7feea99a(,%eax,8)
801066b4:	80 
  for(i = 0; i < 256; i++)
801066b5:	83 c0 01             	add    $0x1,%eax
801066b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801066bd:	75 d1                	jne    80106690 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801066bf:	a1 08 b1 10 80       	mov    0x8010b108,%eax
  SETGATE(idt[128], 1, SEG_KCODE<<3, vectors[128], DPL_USER);

  initlock(&tickslock, "time");
801066c4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801066c7:	c7 05 62 58 11 80 08 	movl   $0xef000008,0x80115862
801066ce:	00 00 ef 
  initlock(&tickslock, "time");
801066d1:	68 a1 88 10 80       	push   $0x801088a1
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801066d6:	66 a3 60 58 11 80    	mov    %ax,0x80115860
801066dc:	c1 e8 10             	shr    $0x10,%eax
801066df:	66 a3 66 58 11 80    	mov    %ax,0x80115866
  SETGATE(idt[128], 1, SEG_KCODE<<3, vectors[128], DPL_USER);
801066e5:	a1 08 b2 10 80       	mov    0x8010b208,%eax
  initlock(&tickslock, "time");
801066ea:	68 20 56 11 80       	push   $0x80115620
  SETGATE(idt[128], 1, SEG_KCODE<<3, vectors[128], DPL_USER);
801066ef:	66 a3 60 5a 11 80    	mov    %ax,0x80115a60
801066f5:	c1 e8 10             	shr    $0x10,%eax
801066f8:	c7 05 62 5a 11 80 08 	movl   $0xef000008,0x80115a62
801066ff:	00 00 ef 
80106702:	66 a3 66 5a 11 80    	mov    %ax,0x80115a66
  initlock(&tickslock, "time");
80106708:	e8 53 e9 ff ff       	call   80105060 <initlock>
}
8010670d:	83 c4 10             	add    $0x10,%esp
80106710:	c9                   	leave  
80106711:	c3                   	ret    
80106712:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106720 <idtinit>:

void
idtinit(void)
{
80106720:	55                   	push   %ebp
  pd[0] = size-1;
80106721:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106726:	89 e5                	mov    %esp,%ebp
80106728:	83 ec 10             	sub    $0x10,%esp
8010672b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010672f:	b8 60 56 11 80       	mov    $0x80115660,%eax
80106734:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106738:	c1 e8 10             	shr    $0x10,%eax
8010673b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010673f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106742:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106745:	c9                   	leave  
80106746:	c3                   	ret    
80106747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010674e:	66 90                	xchg   %ax,%ax

80106750 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	57                   	push   %edi
80106754:	56                   	push   %esi
80106755:	53                   	push   %ebx
80106756:	83 ec 1c             	sub    $0x1c,%esp
80106759:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010675c:	8b 43 30             	mov    0x30(%ebx),%eax
8010675f:	83 f8 40             	cmp    $0x40,%eax
80106762:	0f 84 a8 01 00 00    	je     80106910 <trap+0x1c0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106768:	83 f8 3f             	cmp    $0x3f,%eax
8010676b:	0f 87 9f 00 00 00    	ja     80106810 <trap+0xc0>
80106771:	83 f8 1f             	cmp    $0x1f,%eax
80106774:	0f 86 c6 00 00 00    	jbe    80106840 <trap+0xf0>
8010677a:	83 e8 20             	sub    $0x20,%eax
8010677d:	83 f8 1f             	cmp    $0x1f,%eax
80106780:	0f 87 ba 00 00 00    	ja     80106840 <trap+0xf0>
80106786:	ff 24 85 64 89 10 80 	jmp    *-0x7fef769c(,%eax,4)
8010678d:	8d 76 00             	lea    0x0(%esi),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106790:	e8 ab ba ff ff       	call   80102240 <ideintr>
    lapiceoi();
80106795:	e8 76 c1 ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010679a:	e8 f1 d4 ff ff       	call   80103c90 <myproc>
8010679f:	85 c0                	test   %eax,%eax
801067a1:	74 1d                	je     801067c0 <trap+0x70>
801067a3:	e8 e8 d4 ff ff       	call   80103c90 <myproc>
801067a8:	8b 50 24             	mov    0x24(%eax),%edx
801067ab:	85 d2                	test   %edx,%edx
801067ad:	74 11                	je     801067c0 <trap+0x70>
801067af:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801067b3:	83 e0 03             	and    $0x3,%eax
801067b6:	66 83 f8 03          	cmp    $0x3,%ax
801067ba:	0f 84 30 02 00 00    	je     801069f0 <trap+0x2a0>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801067c0:	e8 cb d4 ff ff       	call   80103c90 <myproc>
801067c5:	85 c0                	test   %eax,%eax
801067c7:	74 0f                	je     801067d8 <trap+0x88>
801067c9:	e8 c2 d4 ff ff       	call   80103c90 <myproc>
801067ce:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801067d2:	0f 84 e8 00 00 00    	je     801068c0 <trap+0x170>
    proctimer();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067d8:	e8 b3 d4 ff ff       	call   80103c90 <myproc>
801067dd:	85 c0                	test   %eax,%eax
801067df:	74 1d                	je     801067fe <trap+0xae>
801067e1:	e8 aa d4 ff ff       	call   80103c90 <myproc>
801067e6:	8b 40 24             	mov    0x24(%eax),%eax
801067e9:	85 c0                	test   %eax,%eax
801067eb:	74 11                	je     801067fe <trap+0xae>
801067ed:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801067f1:	83 e0 03             	and    $0x3,%eax
801067f4:	66 83 f8 03          	cmp    $0x3,%ax
801067f8:	0f 84 3f 01 00 00    	je     8010693d <trap+0x1ed>
    exit();
}
801067fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106801:	5b                   	pop    %ebx
80106802:	5e                   	pop    %esi
80106803:	5f                   	pop    %edi
80106804:	5d                   	pop    %ebp
80106805:	c3                   	ret    
80106806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010680d:	8d 76 00             	lea    0x0(%esi),%esi
  switch(tf->trapno){
80106810:	3d 80 00 00 00       	cmp    $0x80,%eax
80106815:	75 29                	jne    80106840 <trap+0xf0>
    cprintf("user interrupt 128 called!\n");
80106817:	83 ec 0c             	sub    $0xc,%esp
8010681a:	68 a6 88 10 80       	push   $0x801088a6
8010681f:	e8 7c 9e ff ff       	call   801006a0 <cprintf>
    exit();
80106824:	e8 a7 db ff ff       	call   801043d0 <exit>
    break;
80106829:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010682c:	e8 5f d4 ff ff       	call   80103c90 <myproc>
80106831:	85 c0                	test   %eax,%eax
80106833:	0f 85 6a ff ff ff    	jne    801067a3 <trap+0x53>
80106839:	eb 85                	jmp    801067c0 <trap+0x70>
8010683b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010683f:	90                   	nop
    if(myproc() == 0 || (tf->cs&3) == 0){
80106840:	e8 4b d4 ff ff       	call   80103c90 <myproc>
80106845:	8b 7b 38             	mov    0x38(%ebx),%edi
80106848:	85 c0                	test   %eax,%eax
8010684a:	0f 84 c7 01 00 00    	je     80106a17 <trap+0x2c7>
80106850:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106854:	0f 84 bd 01 00 00    	je     80106a17 <trap+0x2c7>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010685a:	0f 20 d1             	mov    %cr2,%ecx
8010685d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106860:	e8 0b d4 ff ff       	call   80103c70 <cpuid>
80106865:	8b 73 30             	mov    0x30(%ebx),%esi
80106868:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010686b:	8b 43 34             	mov    0x34(%ebx),%eax
8010686e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106871:	e8 1a d4 ff ff       	call   80103c90 <myproc>
80106876:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106879:	e8 12 d4 ff ff       	call   80103c90 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010687e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106881:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106884:	51                   	push   %ecx
80106885:	57                   	push   %edi
80106886:	52                   	push   %edx
80106887:	ff 75 e4             	push   -0x1c(%ebp)
8010688a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010688b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010688e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106891:	56                   	push   %esi
80106892:	ff 70 10             	push   0x10(%eax)
80106895:	68 20 89 10 80       	push   $0x80108920
8010689a:	e8 01 9e ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
8010689f:	83 c4 20             	add    $0x20,%esp
801068a2:	e8 e9 d3 ff ff       	call   80103c90 <myproc>
801068a7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801068ae:	e8 dd d3 ff ff       	call   80103c90 <myproc>
801068b3:	85 c0                	test   %eax,%eax
801068b5:	0f 85 e8 fe ff ff    	jne    801067a3 <trap+0x53>
801068bb:	e9 00 ff ff ff       	jmp    801067c0 <trap+0x70>
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801068c0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801068c4:	0f 85 0e ff ff ff    	jne    801067d8 <trap+0x88>
    proctimer();
801068ca:	e8 71 e1 ff ff       	call   80104a40 <proctimer>
801068cf:	e9 04 ff ff ff       	jmp    801067d8 <trap+0x88>
801068d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801068d8:	8b 7b 38             	mov    0x38(%ebx),%edi
801068db:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801068df:	e8 8c d3 ff ff       	call   80103c70 <cpuid>
801068e4:	57                   	push   %edi
801068e5:	56                   	push   %esi
801068e6:	50                   	push   %eax
801068e7:	68 c8 88 10 80       	push   $0x801088c8
801068ec:	e8 af 9d ff ff       	call   801006a0 <cprintf>
    lapiceoi();
801068f1:	e8 1a c0 ff ff       	call   80102910 <lapiceoi>
    break;
801068f6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801068f9:	e8 92 d3 ff ff       	call   80103c90 <myproc>
801068fe:	85 c0                	test   %eax,%eax
80106900:	0f 85 9d fe ff ff    	jne    801067a3 <trap+0x53>
80106906:	e9 b5 fe ff ff       	jmp    801067c0 <trap+0x70>
8010690b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010690f:	90                   	nop
    if(myproc()->killed)
80106910:	e8 7b d3 ff ff       	call   80103c90 <myproc>
80106915:	8b 70 24             	mov    0x24(%eax),%esi
80106918:	85 f6                	test   %esi,%esi
8010691a:	0f 85 e0 00 00 00    	jne    80106a00 <trap+0x2b0>
    myproc()->tf = tf;
80106920:	e8 6b d3 ff ff       	call   80103c90 <myproc>
80106925:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106928:	e8 c3 ed ff ff       	call   801056f0 <syscall>
    if(myproc()->killed)
8010692d:	e8 5e d3 ff ff       	call   80103c90 <myproc>
80106932:	8b 48 24             	mov    0x24(%eax),%ecx
80106935:	85 c9                	test   %ecx,%ecx
80106937:	0f 84 c1 fe ff ff    	je     801067fe <trap+0xae>
}
8010693d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106940:	5b                   	pop    %ebx
80106941:	5e                   	pop    %esi
80106942:	5f                   	pop    %edi
80106943:	5d                   	pop    %ebp
      exit();
80106944:	e9 87 da ff ff       	jmp    801043d0 <exit>
80106949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106950:	e8 5b 02 00 00       	call   80106bb0 <uartintr>
    lapiceoi();
80106955:	e8 b6 bf ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010695a:	e8 31 d3 ff ff       	call   80103c90 <myproc>
8010695f:	85 c0                	test   %eax,%eax
80106961:	0f 85 3c fe ff ff    	jne    801067a3 <trap+0x53>
80106967:	e9 54 fe ff ff       	jmp    801067c0 <trap+0x70>
8010696c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106970:	e8 5b be ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80106975:	e8 96 bf ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010697a:	e8 11 d3 ff ff       	call   80103c90 <myproc>
8010697f:	85 c0                	test   %eax,%eax
80106981:	0f 85 1c fe ff ff    	jne    801067a3 <trap+0x53>
80106987:	e9 34 fe ff ff       	jmp    801067c0 <trap+0x70>
8010698c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106990:	e8 db d2 ff ff       	call   80103c70 <cpuid>
80106995:	85 c0                	test   %eax,%eax
80106997:	0f 85 f8 fd ff ff    	jne    80106795 <trap+0x45>
      acquire(&tickslock);
8010699d:	83 ec 0c             	sub    $0xc,%esp
801069a0:	68 20 56 11 80       	push   $0x80115620
801069a5:	e8 86 e8 ff ff       	call   80105230 <acquire>
      wakeup(&ticks);
801069aa:	c7 04 24 00 56 11 80 	movl   $0x80115600,(%esp)
      ticks++;
801069b1:	83 05 00 56 11 80 01 	addl   $0x1,0x80115600
      wakeup(&ticks);
801069b8:	e8 e3 de ff ff       	call   801048a0 <wakeup>
801069bd:	83 c4 10             	add    $0x10,%esp
801069c0:	69 05 00 56 11 80 29 	imul   $0xc28f5c29,0x80115600,%eax
801069c7:	5c 8f c2 
801069ca:	c1 c8 02             	ror    $0x2,%eax
      if (ticks % 100 == 0){
801069cd:	3d 28 5c 8f 02       	cmp    $0x28f5c28,%eax
801069d2:	76 3c                	jbe    80106a10 <trap+0x2c0>
      release(&tickslock);
801069d4:	83 ec 0c             	sub    $0xc,%esp
801069d7:	68 20 56 11 80       	push   $0x80115620
801069dc:	e8 ef e7 ff ff       	call   801051d0 <release>
801069e1:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801069e4:	e9 ac fd ff ff       	jmp    80106795 <trap+0x45>
801069e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
801069f0:	e8 db d9 ff ff       	call   801043d0 <exit>
801069f5:	e9 c6 fd ff ff       	jmp    801067c0 <trap+0x70>
801069fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106a00:	e8 cb d9 ff ff       	call   801043d0 <exit>
80106a05:	e9 16 ff ff ff       	jmp    80106920 <trap+0x1d0>
80106a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prboost();
80106a10:	e8 8b e0 ff ff       	call   80104aa0 <prboost>
80106a15:	eb bd                	jmp    801069d4 <trap+0x284>
80106a17:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106a1a:	e8 51 d2 ff ff       	call   80103c70 <cpuid>
80106a1f:	83 ec 0c             	sub    $0xc,%esp
80106a22:	56                   	push   %esi
80106a23:	57                   	push   %edi
80106a24:	50                   	push   %eax
80106a25:	ff 73 30             	push   0x30(%ebx)
80106a28:	68 ec 88 10 80       	push   $0x801088ec
80106a2d:	e8 6e 9c ff ff       	call   801006a0 <cprintf>
      panic("trap");
80106a32:	83 c4 14             	add    $0x14,%esp
80106a35:	68 c2 88 10 80       	push   $0x801088c2
80106a3a:	e8 41 99 ff ff       	call   80100380 <panic>
80106a3f:	90                   	nop

80106a40 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106a40:	a1 60 5e 11 80       	mov    0x80115e60,%eax
80106a45:	85 c0                	test   %eax,%eax
80106a47:	74 17                	je     80106a60 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106a49:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106a4e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106a4f:	a8 01                	test   $0x1,%al
80106a51:	74 0d                	je     80106a60 <uartgetc+0x20>
80106a53:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a58:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106a59:	0f b6 c0             	movzbl %al,%eax
80106a5c:	c3                   	ret    
80106a5d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a65:	c3                   	ret    
80106a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a6d:	8d 76 00             	lea    0x0(%esi),%esi

80106a70 <uartinit>:
{
80106a70:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106a71:	31 c9                	xor    %ecx,%ecx
80106a73:	89 c8                	mov    %ecx,%eax
80106a75:	89 e5                	mov    %esp,%ebp
80106a77:	57                   	push   %edi
80106a78:	bf fa 03 00 00       	mov    $0x3fa,%edi
80106a7d:	56                   	push   %esi
80106a7e:	89 fa                	mov    %edi,%edx
80106a80:	53                   	push   %ebx
80106a81:	83 ec 1c             	sub    $0x1c,%esp
80106a84:	ee                   	out    %al,(%dx)
80106a85:	be fb 03 00 00       	mov    $0x3fb,%esi
80106a8a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106a8f:	89 f2                	mov    %esi,%edx
80106a91:	ee                   	out    %al,(%dx)
80106a92:	b8 0c 00 00 00       	mov    $0xc,%eax
80106a97:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a9c:	ee                   	out    %al,(%dx)
80106a9d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106aa2:	89 c8                	mov    %ecx,%eax
80106aa4:	89 da                	mov    %ebx,%edx
80106aa6:	ee                   	out    %al,(%dx)
80106aa7:	b8 03 00 00 00       	mov    $0x3,%eax
80106aac:	89 f2                	mov    %esi,%edx
80106aae:	ee                   	out    %al,(%dx)
80106aaf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106ab4:	89 c8                	mov    %ecx,%eax
80106ab6:	ee                   	out    %al,(%dx)
80106ab7:	b8 01 00 00 00       	mov    $0x1,%eax
80106abc:	89 da                	mov    %ebx,%edx
80106abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106abf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106ac4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106ac5:	3c ff                	cmp    $0xff,%al
80106ac7:	74 78                	je     80106b41 <uartinit+0xd1>
  uart = 1;
80106ac9:	c7 05 60 5e 11 80 01 	movl   $0x1,0x80115e60
80106ad0:	00 00 00 
80106ad3:	89 fa                	mov    %edi,%edx
80106ad5:	ec                   	in     (%dx),%al
80106ad6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106adb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106adc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106adf:	bf e4 89 10 80       	mov    $0x801089e4,%edi
80106ae4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106ae9:	6a 00                	push   $0x0
80106aeb:	6a 04                	push   $0x4
80106aed:	e8 8e b9 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106af2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106af6:	83 c4 10             	add    $0x10,%esp
80106af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106b00:	a1 60 5e 11 80       	mov    0x80115e60,%eax
80106b05:	bb 80 00 00 00       	mov    $0x80,%ebx
80106b0a:	85 c0                	test   %eax,%eax
80106b0c:	75 14                	jne    80106b22 <uartinit+0xb2>
80106b0e:	eb 23                	jmp    80106b33 <uartinit+0xc3>
    microdelay(10);
80106b10:	83 ec 0c             	sub    $0xc,%esp
80106b13:	6a 0a                	push   $0xa
80106b15:	e8 16 be ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b1a:	83 c4 10             	add    $0x10,%esp
80106b1d:	83 eb 01             	sub    $0x1,%ebx
80106b20:	74 07                	je     80106b29 <uartinit+0xb9>
80106b22:	89 f2                	mov    %esi,%edx
80106b24:	ec                   	in     (%dx),%al
80106b25:	a8 20                	test   $0x20,%al
80106b27:	74 e7                	je     80106b10 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b29:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106b2d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b32:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106b33:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106b37:	83 c7 01             	add    $0x1,%edi
80106b3a:	88 45 e7             	mov    %al,-0x19(%ebp)
80106b3d:	84 c0                	test   %al,%al
80106b3f:	75 bf                	jne    80106b00 <uartinit+0x90>
}
80106b41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b44:	5b                   	pop    %ebx
80106b45:	5e                   	pop    %esi
80106b46:	5f                   	pop    %edi
80106b47:	5d                   	pop    %ebp
80106b48:	c3                   	ret    
80106b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b50 <uartputc>:
  if(!uart)
80106b50:	a1 60 5e 11 80       	mov    0x80115e60,%eax
80106b55:	85 c0                	test   %eax,%eax
80106b57:	74 47                	je     80106ba0 <uartputc+0x50>
{
80106b59:	55                   	push   %ebp
80106b5a:	89 e5                	mov    %esp,%ebp
80106b5c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b5d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106b62:	53                   	push   %ebx
80106b63:	bb 80 00 00 00       	mov    $0x80,%ebx
80106b68:	eb 18                	jmp    80106b82 <uartputc+0x32>
80106b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106b70:	83 ec 0c             	sub    $0xc,%esp
80106b73:	6a 0a                	push   $0xa
80106b75:	e8 b6 bd ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b7a:	83 c4 10             	add    $0x10,%esp
80106b7d:	83 eb 01             	sub    $0x1,%ebx
80106b80:	74 07                	je     80106b89 <uartputc+0x39>
80106b82:	89 f2                	mov    %esi,%edx
80106b84:	ec                   	in     (%dx),%al
80106b85:	a8 20                	test   $0x20,%al
80106b87:	74 e7                	je     80106b70 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b89:	8b 45 08             	mov    0x8(%ebp),%eax
80106b8c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b91:	ee                   	out    %al,(%dx)
}
80106b92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106b95:	5b                   	pop    %ebx
80106b96:	5e                   	pop    %esi
80106b97:	5d                   	pop    %ebp
80106b98:	c3                   	ret    
80106b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ba0:	c3                   	ret    
80106ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106baf:	90                   	nop

80106bb0 <uartintr>:

void
uartintr(void)
{
80106bb0:	55                   	push   %ebp
80106bb1:	89 e5                	mov    %esp,%ebp
80106bb3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106bb6:	68 40 6a 10 80       	push   $0x80106a40
80106bbb:	e8 c0 9c ff ff       	call   80100880 <consoleintr>
}
80106bc0:	83 c4 10             	add    $0x10,%esp
80106bc3:	c9                   	leave  
80106bc4:	c3                   	ret    

80106bc5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106bc5:	6a 00                	push   $0x0
  pushl $0
80106bc7:	6a 00                	push   $0x0
  jmp alltraps
80106bc9:	e9 81 fa ff ff       	jmp    8010664f <alltraps>

80106bce <vector1>:
.globl vector1
vector1:
  pushl $0
80106bce:	6a 00                	push   $0x0
  pushl $1
80106bd0:	6a 01                	push   $0x1
  jmp alltraps
80106bd2:	e9 78 fa ff ff       	jmp    8010664f <alltraps>

80106bd7 <vector2>:
.globl vector2
vector2:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $2
80106bd9:	6a 02                	push   $0x2
  jmp alltraps
80106bdb:	e9 6f fa ff ff       	jmp    8010664f <alltraps>

80106be0 <vector3>:
.globl vector3
vector3:
  pushl $0
80106be0:	6a 00                	push   $0x0
  pushl $3
80106be2:	6a 03                	push   $0x3
  jmp alltraps
80106be4:	e9 66 fa ff ff       	jmp    8010664f <alltraps>

80106be9 <vector4>:
.globl vector4
vector4:
  pushl $0
80106be9:	6a 00                	push   $0x0
  pushl $4
80106beb:	6a 04                	push   $0x4
  jmp alltraps
80106bed:	e9 5d fa ff ff       	jmp    8010664f <alltraps>

80106bf2 <vector5>:
.globl vector5
vector5:
  pushl $0
80106bf2:	6a 00                	push   $0x0
  pushl $5
80106bf4:	6a 05                	push   $0x5
  jmp alltraps
80106bf6:	e9 54 fa ff ff       	jmp    8010664f <alltraps>

80106bfb <vector6>:
.globl vector6
vector6:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $6
80106bfd:	6a 06                	push   $0x6
  jmp alltraps
80106bff:	e9 4b fa ff ff       	jmp    8010664f <alltraps>

80106c04 <vector7>:
.globl vector7
vector7:
  pushl $0
80106c04:	6a 00                	push   $0x0
  pushl $7
80106c06:	6a 07                	push   $0x7
  jmp alltraps
80106c08:	e9 42 fa ff ff       	jmp    8010664f <alltraps>

80106c0d <vector8>:
.globl vector8
vector8:
  pushl $8
80106c0d:	6a 08                	push   $0x8
  jmp alltraps
80106c0f:	e9 3b fa ff ff       	jmp    8010664f <alltraps>

80106c14 <vector9>:
.globl vector9
vector9:
  pushl $0
80106c14:	6a 00                	push   $0x0
  pushl $9
80106c16:	6a 09                	push   $0x9
  jmp alltraps
80106c18:	e9 32 fa ff ff       	jmp    8010664f <alltraps>

80106c1d <vector10>:
.globl vector10
vector10:
  pushl $10
80106c1d:	6a 0a                	push   $0xa
  jmp alltraps
80106c1f:	e9 2b fa ff ff       	jmp    8010664f <alltraps>

80106c24 <vector11>:
.globl vector11
vector11:
  pushl $11
80106c24:	6a 0b                	push   $0xb
  jmp alltraps
80106c26:	e9 24 fa ff ff       	jmp    8010664f <alltraps>

80106c2b <vector12>:
.globl vector12
vector12:
  pushl $12
80106c2b:	6a 0c                	push   $0xc
  jmp alltraps
80106c2d:	e9 1d fa ff ff       	jmp    8010664f <alltraps>

80106c32 <vector13>:
.globl vector13
vector13:
  pushl $13
80106c32:	6a 0d                	push   $0xd
  jmp alltraps
80106c34:	e9 16 fa ff ff       	jmp    8010664f <alltraps>

80106c39 <vector14>:
.globl vector14
vector14:
  pushl $14
80106c39:	6a 0e                	push   $0xe
  jmp alltraps
80106c3b:	e9 0f fa ff ff       	jmp    8010664f <alltraps>

80106c40 <vector15>:
.globl vector15
vector15:
  pushl $0
80106c40:	6a 00                	push   $0x0
  pushl $15
80106c42:	6a 0f                	push   $0xf
  jmp alltraps
80106c44:	e9 06 fa ff ff       	jmp    8010664f <alltraps>

80106c49 <vector16>:
.globl vector16
vector16:
  pushl $0
80106c49:	6a 00                	push   $0x0
  pushl $16
80106c4b:	6a 10                	push   $0x10
  jmp alltraps
80106c4d:	e9 fd f9 ff ff       	jmp    8010664f <alltraps>

80106c52 <vector17>:
.globl vector17
vector17:
  pushl $17
80106c52:	6a 11                	push   $0x11
  jmp alltraps
80106c54:	e9 f6 f9 ff ff       	jmp    8010664f <alltraps>

80106c59 <vector18>:
.globl vector18
vector18:
  pushl $0
80106c59:	6a 00                	push   $0x0
  pushl $18
80106c5b:	6a 12                	push   $0x12
  jmp alltraps
80106c5d:	e9 ed f9 ff ff       	jmp    8010664f <alltraps>

80106c62 <vector19>:
.globl vector19
vector19:
  pushl $0
80106c62:	6a 00                	push   $0x0
  pushl $19
80106c64:	6a 13                	push   $0x13
  jmp alltraps
80106c66:	e9 e4 f9 ff ff       	jmp    8010664f <alltraps>

80106c6b <vector20>:
.globl vector20
vector20:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $20
80106c6d:	6a 14                	push   $0x14
  jmp alltraps
80106c6f:	e9 db f9 ff ff       	jmp    8010664f <alltraps>

80106c74 <vector21>:
.globl vector21
vector21:
  pushl $0
80106c74:	6a 00                	push   $0x0
  pushl $21
80106c76:	6a 15                	push   $0x15
  jmp alltraps
80106c78:	e9 d2 f9 ff ff       	jmp    8010664f <alltraps>

80106c7d <vector22>:
.globl vector22
vector22:
  pushl $0
80106c7d:	6a 00                	push   $0x0
  pushl $22
80106c7f:	6a 16                	push   $0x16
  jmp alltraps
80106c81:	e9 c9 f9 ff ff       	jmp    8010664f <alltraps>

80106c86 <vector23>:
.globl vector23
vector23:
  pushl $0
80106c86:	6a 00                	push   $0x0
  pushl $23
80106c88:	6a 17                	push   $0x17
  jmp alltraps
80106c8a:	e9 c0 f9 ff ff       	jmp    8010664f <alltraps>

80106c8f <vector24>:
.globl vector24
vector24:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $24
80106c91:	6a 18                	push   $0x18
  jmp alltraps
80106c93:	e9 b7 f9 ff ff       	jmp    8010664f <alltraps>

80106c98 <vector25>:
.globl vector25
vector25:
  pushl $0
80106c98:	6a 00                	push   $0x0
  pushl $25
80106c9a:	6a 19                	push   $0x19
  jmp alltraps
80106c9c:	e9 ae f9 ff ff       	jmp    8010664f <alltraps>

80106ca1 <vector26>:
.globl vector26
vector26:
  pushl $0
80106ca1:	6a 00                	push   $0x0
  pushl $26
80106ca3:	6a 1a                	push   $0x1a
  jmp alltraps
80106ca5:	e9 a5 f9 ff ff       	jmp    8010664f <alltraps>

80106caa <vector27>:
.globl vector27
vector27:
  pushl $0
80106caa:	6a 00                	push   $0x0
  pushl $27
80106cac:	6a 1b                	push   $0x1b
  jmp alltraps
80106cae:	e9 9c f9 ff ff       	jmp    8010664f <alltraps>

80106cb3 <vector28>:
.globl vector28
vector28:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $28
80106cb5:	6a 1c                	push   $0x1c
  jmp alltraps
80106cb7:	e9 93 f9 ff ff       	jmp    8010664f <alltraps>

80106cbc <vector29>:
.globl vector29
vector29:
  pushl $0
80106cbc:	6a 00                	push   $0x0
  pushl $29
80106cbe:	6a 1d                	push   $0x1d
  jmp alltraps
80106cc0:	e9 8a f9 ff ff       	jmp    8010664f <alltraps>

80106cc5 <vector30>:
.globl vector30
vector30:
  pushl $0
80106cc5:	6a 00                	push   $0x0
  pushl $30
80106cc7:	6a 1e                	push   $0x1e
  jmp alltraps
80106cc9:	e9 81 f9 ff ff       	jmp    8010664f <alltraps>

80106cce <vector31>:
.globl vector31
vector31:
  pushl $0
80106cce:	6a 00                	push   $0x0
  pushl $31
80106cd0:	6a 1f                	push   $0x1f
  jmp alltraps
80106cd2:	e9 78 f9 ff ff       	jmp    8010664f <alltraps>

80106cd7 <vector32>:
.globl vector32
vector32:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $32
80106cd9:	6a 20                	push   $0x20
  jmp alltraps
80106cdb:	e9 6f f9 ff ff       	jmp    8010664f <alltraps>

80106ce0 <vector33>:
.globl vector33
vector33:
  pushl $0
80106ce0:	6a 00                	push   $0x0
  pushl $33
80106ce2:	6a 21                	push   $0x21
  jmp alltraps
80106ce4:	e9 66 f9 ff ff       	jmp    8010664f <alltraps>

80106ce9 <vector34>:
.globl vector34
vector34:
  pushl $0
80106ce9:	6a 00                	push   $0x0
  pushl $34
80106ceb:	6a 22                	push   $0x22
  jmp alltraps
80106ced:	e9 5d f9 ff ff       	jmp    8010664f <alltraps>

80106cf2 <vector35>:
.globl vector35
vector35:
  pushl $0
80106cf2:	6a 00                	push   $0x0
  pushl $35
80106cf4:	6a 23                	push   $0x23
  jmp alltraps
80106cf6:	e9 54 f9 ff ff       	jmp    8010664f <alltraps>

80106cfb <vector36>:
.globl vector36
vector36:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $36
80106cfd:	6a 24                	push   $0x24
  jmp alltraps
80106cff:	e9 4b f9 ff ff       	jmp    8010664f <alltraps>

80106d04 <vector37>:
.globl vector37
vector37:
  pushl $0
80106d04:	6a 00                	push   $0x0
  pushl $37
80106d06:	6a 25                	push   $0x25
  jmp alltraps
80106d08:	e9 42 f9 ff ff       	jmp    8010664f <alltraps>

80106d0d <vector38>:
.globl vector38
vector38:
  pushl $0
80106d0d:	6a 00                	push   $0x0
  pushl $38
80106d0f:	6a 26                	push   $0x26
  jmp alltraps
80106d11:	e9 39 f9 ff ff       	jmp    8010664f <alltraps>

80106d16 <vector39>:
.globl vector39
vector39:
  pushl $0
80106d16:	6a 00                	push   $0x0
  pushl $39
80106d18:	6a 27                	push   $0x27
  jmp alltraps
80106d1a:	e9 30 f9 ff ff       	jmp    8010664f <alltraps>

80106d1f <vector40>:
.globl vector40
vector40:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $40
80106d21:	6a 28                	push   $0x28
  jmp alltraps
80106d23:	e9 27 f9 ff ff       	jmp    8010664f <alltraps>

80106d28 <vector41>:
.globl vector41
vector41:
  pushl $0
80106d28:	6a 00                	push   $0x0
  pushl $41
80106d2a:	6a 29                	push   $0x29
  jmp alltraps
80106d2c:	e9 1e f9 ff ff       	jmp    8010664f <alltraps>

80106d31 <vector42>:
.globl vector42
vector42:
  pushl $0
80106d31:	6a 00                	push   $0x0
  pushl $42
80106d33:	6a 2a                	push   $0x2a
  jmp alltraps
80106d35:	e9 15 f9 ff ff       	jmp    8010664f <alltraps>

80106d3a <vector43>:
.globl vector43
vector43:
  pushl $0
80106d3a:	6a 00                	push   $0x0
  pushl $43
80106d3c:	6a 2b                	push   $0x2b
  jmp alltraps
80106d3e:	e9 0c f9 ff ff       	jmp    8010664f <alltraps>

80106d43 <vector44>:
.globl vector44
vector44:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $44
80106d45:	6a 2c                	push   $0x2c
  jmp alltraps
80106d47:	e9 03 f9 ff ff       	jmp    8010664f <alltraps>

80106d4c <vector45>:
.globl vector45
vector45:
  pushl $0
80106d4c:	6a 00                	push   $0x0
  pushl $45
80106d4e:	6a 2d                	push   $0x2d
  jmp alltraps
80106d50:	e9 fa f8 ff ff       	jmp    8010664f <alltraps>

80106d55 <vector46>:
.globl vector46
vector46:
  pushl $0
80106d55:	6a 00                	push   $0x0
  pushl $46
80106d57:	6a 2e                	push   $0x2e
  jmp alltraps
80106d59:	e9 f1 f8 ff ff       	jmp    8010664f <alltraps>

80106d5e <vector47>:
.globl vector47
vector47:
  pushl $0
80106d5e:	6a 00                	push   $0x0
  pushl $47
80106d60:	6a 2f                	push   $0x2f
  jmp alltraps
80106d62:	e9 e8 f8 ff ff       	jmp    8010664f <alltraps>

80106d67 <vector48>:
.globl vector48
vector48:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $48
80106d69:	6a 30                	push   $0x30
  jmp alltraps
80106d6b:	e9 df f8 ff ff       	jmp    8010664f <alltraps>

80106d70 <vector49>:
.globl vector49
vector49:
  pushl $0
80106d70:	6a 00                	push   $0x0
  pushl $49
80106d72:	6a 31                	push   $0x31
  jmp alltraps
80106d74:	e9 d6 f8 ff ff       	jmp    8010664f <alltraps>

80106d79 <vector50>:
.globl vector50
vector50:
  pushl $0
80106d79:	6a 00                	push   $0x0
  pushl $50
80106d7b:	6a 32                	push   $0x32
  jmp alltraps
80106d7d:	e9 cd f8 ff ff       	jmp    8010664f <alltraps>

80106d82 <vector51>:
.globl vector51
vector51:
  pushl $0
80106d82:	6a 00                	push   $0x0
  pushl $51
80106d84:	6a 33                	push   $0x33
  jmp alltraps
80106d86:	e9 c4 f8 ff ff       	jmp    8010664f <alltraps>

80106d8b <vector52>:
.globl vector52
vector52:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $52
80106d8d:	6a 34                	push   $0x34
  jmp alltraps
80106d8f:	e9 bb f8 ff ff       	jmp    8010664f <alltraps>

80106d94 <vector53>:
.globl vector53
vector53:
  pushl $0
80106d94:	6a 00                	push   $0x0
  pushl $53
80106d96:	6a 35                	push   $0x35
  jmp alltraps
80106d98:	e9 b2 f8 ff ff       	jmp    8010664f <alltraps>

80106d9d <vector54>:
.globl vector54
vector54:
  pushl $0
80106d9d:	6a 00                	push   $0x0
  pushl $54
80106d9f:	6a 36                	push   $0x36
  jmp alltraps
80106da1:	e9 a9 f8 ff ff       	jmp    8010664f <alltraps>

80106da6 <vector55>:
.globl vector55
vector55:
  pushl $0
80106da6:	6a 00                	push   $0x0
  pushl $55
80106da8:	6a 37                	push   $0x37
  jmp alltraps
80106daa:	e9 a0 f8 ff ff       	jmp    8010664f <alltraps>

80106daf <vector56>:
.globl vector56
vector56:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $56
80106db1:	6a 38                	push   $0x38
  jmp alltraps
80106db3:	e9 97 f8 ff ff       	jmp    8010664f <alltraps>

80106db8 <vector57>:
.globl vector57
vector57:
  pushl $0
80106db8:	6a 00                	push   $0x0
  pushl $57
80106dba:	6a 39                	push   $0x39
  jmp alltraps
80106dbc:	e9 8e f8 ff ff       	jmp    8010664f <alltraps>

80106dc1 <vector58>:
.globl vector58
vector58:
  pushl $0
80106dc1:	6a 00                	push   $0x0
  pushl $58
80106dc3:	6a 3a                	push   $0x3a
  jmp alltraps
80106dc5:	e9 85 f8 ff ff       	jmp    8010664f <alltraps>

80106dca <vector59>:
.globl vector59
vector59:
  pushl $0
80106dca:	6a 00                	push   $0x0
  pushl $59
80106dcc:	6a 3b                	push   $0x3b
  jmp alltraps
80106dce:	e9 7c f8 ff ff       	jmp    8010664f <alltraps>

80106dd3 <vector60>:
.globl vector60
vector60:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $60
80106dd5:	6a 3c                	push   $0x3c
  jmp alltraps
80106dd7:	e9 73 f8 ff ff       	jmp    8010664f <alltraps>

80106ddc <vector61>:
.globl vector61
vector61:
  pushl $0
80106ddc:	6a 00                	push   $0x0
  pushl $61
80106dde:	6a 3d                	push   $0x3d
  jmp alltraps
80106de0:	e9 6a f8 ff ff       	jmp    8010664f <alltraps>

80106de5 <vector62>:
.globl vector62
vector62:
  pushl $0
80106de5:	6a 00                	push   $0x0
  pushl $62
80106de7:	6a 3e                	push   $0x3e
  jmp alltraps
80106de9:	e9 61 f8 ff ff       	jmp    8010664f <alltraps>

80106dee <vector63>:
.globl vector63
vector63:
  pushl $0
80106dee:	6a 00                	push   $0x0
  pushl $63
80106df0:	6a 3f                	push   $0x3f
  jmp alltraps
80106df2:	e9 58 f8 ff ff       	jmp    8010664f <alltraps>

80106df7 <vector64>:
.globl vector64
vector64:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $64
80106df9:	6a 40                	push   $0x40
  jmp alltraps
80106dfb:	e9 4f f8 ff ff       	jmp    8010664f <alltraps>

80106e00 <vector65>:
.globl vector65
vector65:
  pushl $0
80106e00:	6a 00                	push   $0x0
  pushl $65
80106e02:	6a 41                	push   $0x41
  jmp alltraps
80106e04:	e9 46 f8 ff ff       	jmp    8010664f <alltraps>

80106e09 <vector66>:
.globl vector66
vector66:
  pushl $0
80106e09:	6a 00                	push   $0x0
  pushl $66
80106e0b:	6a 42                	push   $0x42
  jmp alltraps
80106e0d:	e9 3d f8 ff ff       	jmp    8010664f <alltraps>

80106e12 <vector67>:
.globl vector67
vector67:
  pushl $0
80106e12:	6a 00                	push   $0x0
  pushl $67
80106e14:	6a 43                	push   $0x43
  jmp alltraps
80106e16:	e9 34 f8 ff ff       	jmp    8010664f <alltraps>

80106e1b <vector68>:
.globl vector68
vector68:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $68
80106e1d:	6a 44                	push   $0x44
  jmp alltraps
80106e1f:	e9 2b f8 ff ff       	jmp    8010664f <alltraps>

80106e24 <vector69>:
.globl vector69
vector69:
  pushl $0
80106e24:	6a 00                	push   $0x0
  pushl $69
80106e26:	6a 45                	push   $0x45
  jmp alltraps
80106e28:	e9 22 f8 ff ff       	jmp    8010664f <alltraps>

80106e2d <vector70>:
.globl vector70
vector70:
  pushl $0
80106e2d:	6a 00                	push   $0x0
  pushl $70
80106e2f:	6a 46                	push   $0x46
  jmp alltraps
80106e31:	e9 19 f8 ff ff       	jmp    8010664f <alltraps>

80106e36 <vector71>:
.globl vector71
vector71:
  pushl $0
80106e36:	6a 00                	push   $0x0
  pushl $71
80106e38:	6a 47                	push   $0x47
  jmp alltraps
80106e3a:	e9 10 f8 ff ff       	jmp    8010664f <alltraps>

80106e3f <vector72>:
.globl vector72
vector72:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $72
80106e41:	6a 48                	push   $0x48
  jmp alltraps
80106e43:	e9 07 f8 ff ff       	jmp    8010664f <alltraps>

80106e48 <vector73>:
.globl vector73
vector73:
  pushl $0
80106e48:	6a 00                	push   $0x0
  pushl $73
80106e4a:	6a 49                	push   $0x49
  jmp alltraps
80106e4c:	e9 fe f7 ff ff       	jmp    8010664f <alltraps>

80106e51 <vector74>:
.globl vector74
vector74:
  pushl $0
80106e51:	6a 00                	push   $0x0
  pushl $74
80106e53:	6a 4a                	push   $0x4a
  jmp alltraps
80106e55:	e9 f5 f7 ff ff       	jmp    8010664f <alltraps>

80106e5a <vector75>:
.globl vector75
vector75:
  pushl $0
80106e5a:	6a 00                	push   $0x0
  pushl $75
80106e5c:	6a 4b                	push   $0x4b
  jmp alltraps
80106e5e:	e9 ec f7 ff ff       	jmp    8010664f <alltraps>

80106e63 <vector76>:
.globl vector76
vector76:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $76
80106e65:	6a 4c                	push   $0x4c
  jmp alltraps
80106e67:	e9 e3 f7 ff ff       	jmp    8010664f <alltraps>

80106e6c <vector77>:
.globl vector77
vector77:
  pushl $0
80106e6c:	6a 00                	push   $0x0
  pushl $77
80106e6e:	6a 4d                	push   $0x4d
  jmp alltraps
80106e70:	e9 da f7 ff ff       	jmp    8010664f <alltraps>

80106e75 <vector78>:
.globl vector78
vector78:
  pushl $0
80106e75:	6a 00                	push   $0x0
  pushl $78
80106e77:	6a 4e                	push   $0x4e
  jmp alltraps
80106e79:	e9 d1 f7 ff ff       	jmp    8010664f <alltraps>

80106e7e <vector79>:
.globl vector79
vector79:
  pushl $0
80106e7e:	6a 00                	push   $0x0
  pushl $79
80106e80:	6a 4f                	push   $0x4f
  jmp alltraps
80106e82:	e9 c8 f7 ff ff       	jmp    8010664f <alltraps>

80106e87 <vector80>:
.globl vector80
vector80:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $80
80106e89:	6a 50                	push   $0x50
  jmp alltraps
80106e8b:	e9 bf f7 ff ff       	jmp    8010664f <alltraps>

80106e90 <vector81>:
.globl vector81
vector81:
  pushl $0
80106e90:	6a 00                	push   $0x0
  pushl $81
80106e92:	6a 51                	push   $0x51
  jmp alltraps
80106e94:	e9 b6 f7 ff ff       	jmp    8010664f <alltraps>

80106e99 <vector82>:
.globl vector82
vector82:
  pushl $0
80106e99:	6a 00                	push   $0x0
  pushl $82
80106e9b:	6a 52                	push   $0x52
  jmp alltraps
80106e9d:	e9 ad f7 ff ff       	jmp    8010664f <alltraps>

80106ea2 <vector83>:
.globl vector83
vector83:
  pushl $0
80106ea2:	6a 00                	push   $0x0
  pushl $83
80106ea4:	6a 53                	push   $0x53
  jmp alltraps
80106ea6:	e9 a4 f7 ff ff       	jmp    8010664f <alltraps>

80106eab <vector84>:
.globl vector84
vector84:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $84
80106ead:	6a 54                	push   $0x54
  jmp alltraps
80106eaf:	e9 9b f7 ff ff       	jmp    8010664f <alltraps>

80106eb4 <vector85>:
.globl vector85
vector85:
  pushl $0
80106eb4:	6a 00                	push   $0x0
  pushl $85
80106eb6:	6a 55                	push   $0x55
  jmp alltraps
80106eb8:	e9 92 f7 ff ff       	jmp    8010664f <alltraps>

80106ebd <vector86>:
.globl vector86
vector86:
  pushl $0
80106ebd:	6a 00                	push   $0x0
  pushl $86
80106ebf:	6a 56                	push   $0x56
  jmp alltraps
80106ec1:	e9 89 f7 ff ff       	jmp    8010664f <alltraps>

80106ec6 <vector87>:
.globl vector87
vector87:
  pushl $0
80106ec6:	6a 00                	push   $0x0
  pushl $87
80106ec8:	6a 57                	push   $0x57
  jmp alltraps
80106eca:	e9 80 f7 ff ff       	jmp    8010664f <alltraps>

80106ecf <vector88>:
.globl vector88
vector88:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $88
80106ed1:	6a 58                	push   $0x58
  jmp alltraps
80106ed3:	e9 77 f7 ff ff       	jmp    8010664f <alltraps>

80106ed8 <vector89>:
.globl vector89
vector89:
  pushl $0
80106ed8:	6a 00                	push   $0x0
  pushl $89
80106eda:	6a 59                	push   $0x59
  jmp alltraps
80106edc:	e9 6e f7 ff ff       	jmp    8010664f <alltraps>

80106ee1 <vector90>:
.globl vector90
vector90:
  pushl $0
80106ee1:	6a 00                	push   $0x0
  pushl $90
80106ee3:	6a 5a                	push   $0x5a
  jmp alltraps
80106ee5:	e9 65 f7 ff ff       	jmp    8010664f <alltraps>

80106eea <vector91>:
.globl vector91
vector91:
  pushl $0
80106eea:	6a 00                	push   $0x0
  pushl $91
80106eec:	6a 5b                	push   $0x5b
  jmp alltraps
80106eee:	e9 5c f7 ff ff       	jmp    8010664f <alltraps>

80106ef3 <vector92>:
.globl vector92
vector92:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $92
80106ef5:	6a 5c                	push   $0x5c
  jmp alltraps
80106ef7:	e9 53 f7 ff ff       	jmp    8010664f <alltraps>

80106efc <vector93>:
.globl vector93
vector93:
  pushl $0
80106efc:	6a 00                	push   $0x0
  pushl $93
80106efe:	6a 5d                	push   $0x5d
  jmp alltraps
80106f00:	e9 4a f7 ff ff       	jmp    8010664f <alltraps>

80106f05 <vector94>:
.globl vector94
vector94:
  pushl $0
80106f05:	6a 00                	push   $0x0
  pushl $94
80106f07:	6a 5e                	push   $0x5e
  jmp alltraps
80106f09:	e9 41 f7 ff ff       	jmp    8010664f <alltraps>

80106f0e <vector95>:
.globl vector95
vector95:
  pushl $0
80106f0e:	6a 00                	push   $0x0
  pushl $95
80106f10:	6a 5f                	push   $0x5f
  jmp alltraps
80106f12:	e9 38 f7 ff ff       	jmp    8010664f <alltraps>

80106f17 <vector96>:
.globl vector96
vector96:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $96
80106f19:	6a 60                	push   $0x60
  jmp alltraps
80106f1b:	e9 2f f7 ff ff       	jmp    8010664f <alltraps>

80106f20 <vector97>:
.globl vector97
vector97:
  pushl $0
80106f20:	6a 00                	push   $0x0
  pushl $97
80106f22:	6a 61                	push   $0x61
  jmp alltraps
80106f24:	e9 26 f7 ff ff       	jmp    8010664f <alltraps>

80106f29 <vector98>:
.globl vector98
vector98:
  pushl $0
80106f29:	6a 00                	push   $0x0
  pushl $98
80106f2b:	6a 62                	push   $0x62
  jmp alltraps
80106f2d:	e9 1d f7 ff ff       	jmp    8010664f <alltraps>

80106f32 <vector99>:
.globl vector99
vector99:
  pushl $0
80106f32:	6a 00                	push   $0x0
  pushl $99
80106f34:	6a 63                	push   $0x63
  jmp alltraps
80106f36:	e9 14 f7 ff ff       	jmp    8010664f <alltraps>

80106f3b <vector100>:
.globl vector100
vector100:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $100
80106f3d:	6a 64                	push   $0x64
  jmp alltraps
80106f3f:	e9 0b f7 ff ff       	jmp    8010664f <alltraps>

80106f44 <vector101>:
.globl vector101
vector101:
  pushl $0
80106f44:	6a 00                	push   $0x0
  pushl $101
80106f46:	6a 65                	push   $0x65
  jmp alltraps
80106f48:	e9 02 f7 ff ff       	jmp    8010664f <alltraps>

80106f4d <vector102>:
.globl vector102
vector102:
  pushl $0
80106f4d:	6a 00                	push   $0x0
  pushl $102
80106f4f:	6a 66                	push   $0x66
  jmp alltraps
80106f51:	e9 f9 f6 ff ff       	jmp    8010664f <alltraps>

80106f56 <vector103>:
.globl vector103
vector103:
  pushl $0
80106f56:	6a 00                	push   $0x0
  pushl $103
80106f58:	6a 67                	push   $0x67
  jmp alltraps
80106f5a:	e9 f0 f6 ff ff       	jmp    8010664f <alltraps>

80106f5f <vector104>:
.globl vector104
vector104:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $104
80106f61:	6a 68                	push   $0x68
  jmp alltraps
80106f63:	e9 e7 f6 ff ff       	jmp    8010664f <alltraps>

80106f68 <vector105>:
.globl vector105
vector105:
  pushl $0
80106f68:	6a 00                	push   $0x0
  pushl $105
80106f6a:	6a 69                	push   $0x69
  jmp alltraps
80106f6c:	e9 de f6 ff ff       	jmp    8010664f <alltraps>

80106f71 <vector106>:
.globl vector106
vector106:
  pushl $0
80106f71:	6a 00                	push   $0x0
  pushl $106
80106f73:	6a 6a                	push   $0x6a
  jmp alltraps
80106f75:	e9 d5 f6 ff ff       	jmp    8010664f <alltraps>

80106f7a <vector107>:
.globl vector107
vector107:
  pushl $0
80106f7a:	6a 00                	push   $0x0
  pushl $107
80106f7c:	6a 6b                	push   $0x6b
  jmp alltraps
80106f7e:	e9 cc f6 ff ff       	jmp    8010664f <alltraps>

80106f83 <vector108>:
.globl vector108
vector108:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $108
80106f85:	6a 6c                	push   $0x6c
  jmp alltraps
80106f87:	e9 c3 f6 ff ff       	jmp    8010664f <alltraps>

80106f8c <vector109>:
.globl vector109
vector109:
  pushl $0
80106f8c:	6a 00                	push   $0x0
  pushl $109
80106f8e:	6a 6d                	push   $0x6d
  jmp alltraps
80106f90:	e9 ba f6 ff ff       	jmp    8010664f <alltraps>

80106f95 <vector110>:
.globl vector110
vector110:
  pushl $0
80106f95:	6a 00                	push   $0x0
  pushl $110
80106f97:	6a 6e                	push   $0x6e
  jmp alltraps
80106f99:	e9 b1 f6 ff ff       	jmp    8010664f <alltraps>

80106f9e <vector111>:
.globl vector111
vector111:
  pushl $0
80106f9e:	6a 00                	push   $0x0
  pushl $111
80106fa0:	6a 6f                	push   $0x6f
  jmp alltraps
80106fa2:	e9 a8 f6 ff ff       	jmp    8010664f <alltraps>

80106fa7 <vector112>:
.globl vector112
vector112:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $112
80106fa9:	6a 70                	push   $0x70
  jmp alltraps
80106fab:	e9 9f f6 ff ff       	jmp    8010664f <alltraps>

80106fb0 <vector113>:
.globl vector113
vector113:
  pushl $0
80106fb0:	6a 00                	push   $0x0
  pushl $113
80106fb2:	6a 71                	push   $0x71
  jmp alltraps
80106fb4:	e9 96 f6 ff ff       	jmp    8010664f <alltraps>

80106fb9 <vector114>:
.globl vector114
vector114:
  pushl $0
80106fb9:	6a 00                	push   $0x0
  pushl $114
80106fbb:	6a 72                	push   $0x72
  jmp alltraps
80106fbd:	e9 8d f6 ff ff       	jmp    8010664f <alltraps>

80106fc2 <vector115>:
.globl vector115
vector115:
  pushl $0
80106fc2:	6a 00                	push   $0x0
  pushl $115
80106fc4:	6a 73                	push   $0x73
  jmp alltraps
80106fc6:	e9 84 f6 ff ff       	jmp    8010664f <alltraps>

80106fcb <vector116>:
.globl vector116
vector116:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $116
80106fcd:	6a 74                	push   $0x74
  jmp alltraps
80106fcf:	e9 7b f6 ff ff       	jmp    8010664f <alltraps>

80106fd4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106fd4:	6a 00                	push   $0x0
  pushl $117
80106fd6:	6a 75                	push   $0x75
  jmp alltraps
80106fd8:	e9 72 f6 ff ff       	jmp    8010664f <alltraps>

80106fdd <vector118>:
.globl vector118
vector118:
  pushl $0
80106fdd:	6a 00                	push   $0x0
  pushl $118
80106fdf:	6a 76                	push   $0x76
  jmp alltraps
80106fe1:	e9 69 f6 ff ff       	jmp    8010664f <alltraps>

80106fe6 <vector119>:
.globl vector119
vector119:
  pushl $0
80106fe6:	6a 00                	push   $0x0
  pushl $119
80106fe8:	6a 77                	push   $0x77
  jmp alltraps
80106fea:	e9 60 f6 ff ff       	jmp    8010664f <alltraps>

80106fef <vector120>:
.globl vector120
vector120:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $120
80106ff1:	6a 78                	push   $0x78
  jmp alltraps
80106ff3:	e9 57 f6 ff ff       	jmp    8010664f <alltraps>

80106ff8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106ff8:	6a 00                	push   $0x0
  pushl $121
80106ffa:	6a 79                	push   $0x79
  jmp alltraps
80106ffc:	e9 4e f6 ff ff       	jmp    8010664f <alltraps>

80107001 <vector122>:
.globl vector122
vector122:
  pushl $0
80107001:	6a 00                	push   $0x0
  pushl $122
80107003:	6a 7a                	push   $0x7a
  jmp alltraps
80107005:	e9 45 f6 ff ff       	jmp    8010664f <alltraps>

8010700a <vector123>:
.globl vector123
vector123:
  pushl $0
8010700a:	6a 00                	push   $0x0
  pushl $123
8010700c:	6a 7b                	push   $0x7b
  jmp alltraps
8010700e:	e9 3c f6 ff ff       	jmp    8010664f <alltraps>

80107013 <vector124>:
.globl vector124
vector124:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $124
80107015:	6a 7c                	push   $0x7c
  jmp alltraps
80107017:	e9 33 f6 ff ff       	jmp    8010664f <alltraps>

8010701c <vector125>:
.globl vector125
vector125:
  pushl $0
8010701c:	6a 00                	push   $0x0
  pushl $125
8010701e:	6a 7d                	push   $0x7d
  jmp alltraps
80107020:	e9 2a f6 ff ff       	jmp    8010664f <alltraps>

80107025 <vector126>:
.globl vector126
vector126:
  pushl $0
80107025:	6a 00                	push   $0x0
  pushl $126
80107027:	6a 7e                	push   $0x7e
  jmp alltraps
80107029:	e9 21 f6 ff ff       	jmp    8010664f <alltraps>

8010702e <vector127>:
.globl vector127
vector127:
  pushl $0
8010702e:	6a 00                	push   $0x0
  pushl $127
80107030:	6a 7f                	push   $0x7f
  jmp alltraps
80107032:	e9 18 f6 ff ff       	jmp    8010664f <alltraps>

80107037 <vector128>:
.globl vector128
vector128:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $128
80107039:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010703e:	e9 0c f6 ff ff       	jmp    8010664f <alltraps>

80107043 <vector129>:
.globl vector129
vector129:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $129
80107045:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010704a:	e9 00 f6 ff ff       	jmp    8010664f <alltraps>

8010704f <vector130>:
.globl vector130
vector130:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $130
80107051:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107056:	e9 f4 f5 ff ff       	jmp    8010664f <alltraps>

8010705b <vector131>:
.globl vector131
vector131:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $131
8010705d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107062:	e9 e8 f5 ff ff       	jmp    8010664f <alltraps>

80107067 <vector132>:
.globl vector132
vector132:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $132
80107069:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010706e:	e9 dc f5 ff ff       	jmp    8010664f <alltraps>

80107073 <vector133>:
.globl vector133
vector133:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $133
80107075:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010707a:	e9 d0 f5 ff ff       	jmp    8010664f <alltraps>

8010707f <vector134>:
.globl vector134
vector134:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $134
80107081:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107086:	e9 c4 f5 ff ff       	jmp    8010664f <alltraps>

8010708b <vector135>:
.globl vector135
vector135:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $135
8010708d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107092:	e9 b8 f5 ff ff       	jmp    8010664f <alltraps>

80107097 <vector136>:
.globl vector136
vector136:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $136
80107099:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010709e:	e9 ac f5 ff ff       	jmp    8010664f <alltraps>

801070a3 <vector137>:
.globl vector137
vector137:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $137
801070a5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801070aa:	e9 a0 f5 ff ff       	jmp    8010664f <alltraps>

801070af <vector138>:
.globl vector138
vector138:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $138
801070b1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801070b6:	e9 94 f5 ff ff       	jmp    8010664f <alltraps>

801070bb <vector139>:
.globl vector139
vector139:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $139
801070bd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801070c2:	e9 88 f5 ff ff       	jmp    8010664f <alltraps>

801070c7 <vector140>:
.globl vector140
vector140:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $140
801070c9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801070ce:	e9 7c f5 ff ff       	jmp    8010664f <alltraps>

801070d3 <vector141>:
.globl vector141
vector141:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $141
801070d5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801070da:	e9 70 f5 ff ff       	jmp    8010664f <alltraps>

801070df <vector142>:
.globl vector142
vector142:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $142
801070e1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801070e6:	e9 64 f5 ff ff       	jmp    8010664f <alltraps>

801070eb <vector143>:
.globl vector143
vector143:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $143
801070ed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801070f2:	e9 58 f5 ff ff       	jmp    8010664f <alltraps>

801070f7 <vector144>:
.globl vector144
vector144:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $144
801070f9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801070fe:	e9 4c f5 ff ff       	jmp    8010664f <alltraps>

80107103 <vector145>:
.globl vector145
vector145:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $145
80107105:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010710a:	e9 40 f5 ff ff       	jmp    8010664f <alltraps>

8010710f <vector146>:
.globl vector146
vector146:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $146
80107111:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107116:	e9 34 f5 ff ff       	jmp    8010664f <alltraps>

8010711b <vector147>:
.globl vector147
vector147:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $147
8010711d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107122:	e9 28 f5 ff ff       	jmp    8010664f <alltraps>

80107127 <vector148>:
.globl vector148
vector148:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $148
80107129:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010712e:	e9 1c f5 ff ff       	jmp    8010664f <alltraps>

80107133 <vector149>:
.globl vector149
vector149:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $149
80107135:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010713a:	e9 10 f5 ff ff       	jmp    8010664f <alltraps>

8010713f <vector150>:
.globl vector150
vector150:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $150
80107141:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107146:	e9 04 f5 ff ff       	jmp    8010664f <alltraps>

8010714b <vector151>:
.globl vector151
vector151:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $151
8010714d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107152:	e9 f8 f4 ff ff       	jmp    8010664f <alltraps>

80107157 <vector152>:
.globl vector152
vector152:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $152
80107159:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010715e:	e9 ec f4 ff ff       	jmp    8010664f <alltraps>

80107163 <vector153>:
.globl vector153
vector153:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $153
80107165:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010716a:	e9 e0 f4 ff ff       	jmp    8010664f <alltraps>

8010716f <vector154>:
.globl vector154
vector154:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $154
80107171:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107176:	e9 d4 f4 ff ff       	jmp    8010664f <alltraps>

8010717b <vector155>:
.globl vector155
vector155:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $155
8010717d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107182:	e9 c8 f4 ff ff       	jmp    8010664f <alltraps>

80107187 <vector156>:
.globl vector156
vector156:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $156
80107189:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010718e:	e9 bc f4 ff ff       	jmp    8010664f <alltraps>

80107193 <vector157>:
.globl vector157
vector157:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $157
80107195:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010719a:	e9 b0 f4 ff ff       	jmp    8010664f <alltraps>

8010719f <vector158>:
.globl vector158
vector158:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $158
801071a1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801071a6:	e9 a4 f4 ff ff       	jmp    8010664f <alltraps>

801071ab <vector159>:
.globl vector159
vector159:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $159
801071ad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801071b2:	e9 98 f4 ff ff       	jmp    8010664f <alltraps>

801071b7 <vector160>:
.globl vector160
vector160:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $160
801071b9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801071be:	e9 8c f4 ff ff       	jmp    8010664f <alltraps>

801071c3 <vector161>:
.globl vector161
vector161:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $161
801071c5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801071ca:	e9 80 f4 ff ff       	jmp    8010664f <alltraps>

801071cf <vector162>:
.globl vector162
vector162:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $162
801071d1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801071d6:	e9 74 f4 ff ff       	jmp    8010664f <alltraps>

801071db <vector163>:
.globl vector163
vector163:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $163
801071dd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801071e2:	e9 68 f4 ff ff       	jmp    8010664f <alltraps>

801071e7 <vector164>:
.globl vector164
vector164:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $164
801071e9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801071ee:	e9 5c f4 ff ff       	jmp    8010664f <alltraps>

801071f3 <vector165>:
.globl vector165
vector165:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $165
801071f5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801071fa:	e9 50 f4 ff ff       	jmp    8010664f <alltraps>

801071ff <vector166>:
.globl vector166
vector166:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $166
80107201:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107206:	e9 44 f4 ff ff       	jmp    8010664f <alltraps>

8010720b <vector167>:
.globl vector167
vector167:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $167
8010720d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107212:	e9 38 f4 ff ff       	jmp    8010664f <alltraps>

80107217 <vector168>:
.globl vector168
vector168:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $168
80107219:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010721e:	e9 2c f4 ff ff       	jmp    8010664f <alltraps>

80107223 <vector169>:
.globl vector169
vector169:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $169
80107225:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010722a:	e9 20 f4 ff ff       	jmp    8010664f <alltraps>

8010722f <vector170>:
.globl vector170
vector170:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $170
80107231:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107236:	e9 14 f4 ff ff       	jmp    8010664f <alltraps>

8010723b <vector171>:
.globl vector171
vector171:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $171
8010723d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107242:	e9 08 f4 ff ff       	jmp    8010664f <alltraps>

80107247 <vector172>:
.globl vector172
vector172:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $172
80107249:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010724e:	e9 fc f3 ff ff       	jmp    8010664f <alltraps>

80107253 <vector173>:
.globl vector173
vector173:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $173
80107255:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010725a:	e9 f0 f3 ff ff       	jmp    8010664f <alltraps>

8010725f <vector174>:
.globl vector174
vector174:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $174
80107261:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107266:	e9 e4 f3 ff ff       	jmp    8010664f <alltraps>

8010726b <vector175>:
.globl vector175
vector175:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $175
8010726d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107272:	e9 d8 f3 ff ff       	jmp    8010664f <alltraps>

80107277 <vector176>:
.globl vector176
vector176:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $176
80107279:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010727e:	e9 cc f3 ff ff       	jmp    8010664f <alltraps>

80107283 <vector177>:
.globl vector177
vector177:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $177
80107285:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010728a:	e9 c0 f3 ff ff       	jmp    8010664f <alltraps>

8010728f <vector178>:
.globl vector178
vector178:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $178
80107291:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107296:	e9 b4 f3 ff ff       	jmp    8010664f <alltraps>

8010729b <vector179>:
.globl vector179
vector179:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $179
8010729d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801072a2:	e9 a8 f3 ff ff       	jmp    8010664f <alltraps>

801072a7 <vector180>:
.globl vector180
vector180:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $180
801072a9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801072ae:	e9 9c f3 ff ff       	jmp    8010664f <alltraps>

801072b3 <vector181>:
.globl vector181
vector181:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $181
801072b5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801072ba:	e9 90 f3 ff ff       	jmp    8010664f <alltraps>

801072bf <vector182>:
.globl vector182
vector182:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $182
801072c1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801072c6:	e9 84 f3 ff ff       	jmp    8010664f <alltraps>

801072cb <vector183>:
.globl vector183
vector183:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $183
801072cd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801072d2:	e9 78 f3 ff ff       	jmp    8010664f <alltraps>

801072d7 <vector184>:
.globl vector184
vector184:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $184
801072d9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801072de:	e9 6c f3 ff ff       	jmp    8010664f <alltraps>

801072e3 <vector185>:
.globl vector185
vector185:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $185
801072e5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801072ea:	e9 60 f3 ff ff       	jmp    8010664f <alltraps>

801072ef <vector186>:
.globl vector186
vector186:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $186
801072f1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801072f6:	e9 54 f3 ff ff       	jmp    8010664f <alltraps>

801072fb <vector187>:
.globl vector187
vector187:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $187
801072fd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107302:	e9 48 f3 ff ff       	jmp    8010664f <alltraps>

80107307 <vector188>:
.globl vector188
vector188:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $188
80107309:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010730e:	e9 3c f3 ff ff       	jmp    8010664f <alltraps>

80107313 <vector189>:
.globl vector189
vector189:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $189
80107315:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010731a:	e9 30 f3 ff ff       	jmp    8010664f <alltraps>

8010731f <vector190>:
.globl vector190
vector190:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $190
80107321:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107326:	e9 24 f3 ff ff       	jmp    8010664f <alltraps>

8010732b <vector191>:
.globl vector191
vector191:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $191
8010732d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107332:	e9 18 f3 ff ff       	jmp    8010664f <alltraps>

80107337 <vector192>:
.globl vector192
vector192:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $192
80107339:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010733e:	e9 0c f3 ff ff       	jmp    8010664f <alltraps>

80107343 <vector193>:
.globl vector193
vector193:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $193
80107345:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010734a:	e9 00 f3 ff ff       	jmp    8010664f <alltraps>

8010734f <vector194>:
.globl vector194
vector194:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $194
80107351:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107356:	e9 f4 f2 ff ff       	jmp    8010664f <alltraps>

8010735b <vector195>:
.globl vector195
vector195:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $195
8010735d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107362:	e9 e8 f2 ff ff       	jmp    8010664f <alltraps>

80107367 <vector196>:
.globl vector196
vector196:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $196
80107369:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010736e:	e9 dc f2 ff ff       	jmp    8010664f <alltraps>

80107373 <vector197>:
.globl vector197
vector197:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $197
80107375:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010737a:	e9 d0 f2 ff ff       	jmp    8010664f <alltraps>

8010737f <vector198>:
.globl vector198
vector198:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $198
80107381:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107386:	e9 c4 f2 ff ff       	jmp    8010664f <alltraps>

8010738b <vector199>:
.globl vector199
vector199:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $199
8010738d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107392:	e9 b8 f2 ff ff       	jmp    8010664f <alltraps>

80107397 <vector200>:
.globl vector200
vector200:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $200
80107399:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010739e:	e9 ac f2 ff ff       	jmp    8010664f <alltraps>

801073a3 <vector201>:
.globl vector201
vector201:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $201
801073a5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801073aa:	e9 a0 f2 ff ff       	jmp    8010664f <alltraps>

801073af <vector202>:
.globl vector202
vector202:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $202
801073b1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801073b6:	e9 94 f2 ff ff       	jmp    8010664f <alltraps>

801073bb <vector203>:
.globl vector203
vector203:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $203
801073bd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801073c2:	e9 88 f2 ff ff       	jmp    8010664f <alltraps>

801073c7 <vector204>:
.globl vector204
vector204:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $204
801073c9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801073ce:	e9 7c f2 ff ff       	jmp    8010664f <alltraps>

801073d3 <vector205>:
.globl vector205
vector205:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $205
801073d5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801073da:	e9 70 f2 ff ff       	jmp    8010664f <alltraps>

801073df <vector206>:
.globl vector206
vector206:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $206
801073e1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801073e6:	e9 64 f2 ff ff       	jmp    8010664f <alltraps>

801073eb <vector207>:
.globl vector207
vector207:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $207
801073ed:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801073f2:	e9 58 f2 ff ff       	jmp    8010664f <alltraps>

801073f7 <vector208>:
.globl vector208
vector208:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $208
801073f9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801073fe:	e9 4c f2 ff ff       	jmp    8010664f <alltraps>

80107403 <vector209>:
.globl vector209
vector209:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $209
80107405:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010740a:	e9 40 f2 ff ff       	jmp    8010664f <alltraps>

8010740f <vector210>:
.globl vector210
vector210:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $210
80107411:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107416:	e9 34 f2 ff ff       	jmp    8010664f <alltraps>

8010741b <vector211>:
.globl vector211
vector211:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $211
8010741d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107422:	e9 28 f2 ff ff       	jmp    8010664f <alltraps>

80107427 <vector212>:
.globl vector212
vector212:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $212
80107429:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010742e:	e9 1c f2 ff ff       	jmp    8010664f <alltraps>

80107433 <vector213>:
.globl vector213
vector213:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $213
80107435:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010743a:	e9 10 f2 ff ff       	jmp    8010664f <alltraps>

8010743f <vector214>:
.globl vector214
vector214:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $214
80107441:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107446:	e9 04 f2 ff ff       	jmp    8010664f <alltraps>

8010744b <vector215>:
.globl vector215
vector215:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $215
8010744d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107452:	e9 f8 f1 ff ff       	jmp    8010664f <alltraps>

80107457 <vector216>:
.globl vector216
vector216:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $216
80107459:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010745e:	e9 ec f1 ff ff       	jmp    8010664f <alltraps>

80107463 <vector217>:
.globl vector217
vector217:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $217
80107465:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010746a:	e9 e0 f1 ff ff       	jmp    8010664f <alltraps>

8010746f <vector218>:
.globl vector218
vector218:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $218
80107471:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107476:	e9 d4 f1 ff ff       	jmp    8010664f <alltraps>

8010747b <vector219>:
.globl vector219
vector219:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $219
8010747d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107482:	e9 c8 f1 ff ff       	jmp    8010664f <alltraps>

80107487 <vector220>:
.globl vector220
vector220:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $220
80107489:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010748e:	e9 bc f1 ff ff       	jmp    8010664f <alltraps>

80107493 <vector221>:
.globl vector221
vector221:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $221
80107495:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010749a:	e9 b0 f1 ff ff       	jmp    8010664f <alltraps>

8010749f <vector222>:
.globl vector222
vector222:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $222
801074a1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801074a6:	e9 a4 f1 ff ff       	jmp    8010664f <alltraps>

801074ab <vector223>:
.globl vector223
vector223:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $223
801074ad:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801074b2:	e9 98 f1 ff ff       	jmp    8010664f <alltraps>

801074b7 <vector224>:
.globl vector224
vector224:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $224
801074b9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801074be:	e9 8c f1 ff ff       	jmp    8010664f <alltraps>

801074c3 <vector225>:
.globl vector225
vector225:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $225
801074c5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801074ca:	e9 80 f1 ff ff       	jmp    8010664f <alltraps>

801074cf <vector226>:
.globl vector226
vector226:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $226
801074d1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801074d6:	e9 74 f1 ff ff       	jmp    8010664f <alltraps>

801074db <vector227>:
.globl vector227
vector227:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $227
801074dd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801074e2:	e9 68 f1 ff ff       	jmp    8010664f <alltraps>

801074e7 <vector228>:
.globl vector228
vector228:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $228
801074e9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801074ee:	e9 5c f1 ff ff       	jmp    8010664f <alltraps>

801074f3 <vector229>:
.globl vector229
vector229:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $229
801074f5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801074fa:	e9 50 f1 ff ff       	jmp    8010664f <alltraps>

801074ff <vector230>:
.globl vector230
vector230:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $230
80107501:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107506:	e9 44 f1 ff ff       	jmp    8010664f <alltraps>

8010750b <vector231>:
.globl vector231
vector231:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $231
8010750d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107512:	e9 38 f1 ff ff       	jmp    8010664f <alltraps>

80107517 <vector232>:
.globl vector232
vector232:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $232
80107519:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010751e:	e9 2c f1 ff ff       	jmp    8010664f <alltraps>

80107523 <vector233>:
.globl vector233
vector233:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $233
80107525:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010752a:	e9 20 f1 ff ff       	jmp    8010664f <alltraps>

8010752f <vector234>:
.globl vector234
vector234:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $234
80107531:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107536:	e9 14 f1 ff ff       	jmp    8010664f <alltraps>

8010753b <vector235>:
.globl vector235
vector235:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $235
8010753d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107542:	e9 08 f1 ff ff       	jmp    8010664f <alltraps>

80107547 <vector236>:
.globl vector236
vector236:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $236
80107549:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010754e:	e9 fc f0 ff ff       	jmp    8010664f <alltraps>

80107553 <vector237>:
.globl vector237
vector237:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $237
80107555:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010755a:	e9 f0 f0 ff ff       	jmp    8010664f <alltraps>

8010755f <vector238>:
.globl vector238
vector238:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $238
80107561:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107566:	e9 e4 f0 ff ff       	jmp    8010664f <alltraps>

8010756b <vector239>:
.globl vector239
vector239:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $239
8010756d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107572:	e9 d8 f0 ff ff       	jmp    8010664f <alltraps>

80107577 <vector240>:
.globl vector240
vector240:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $240
80107579:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010757e:	e9 cc f0 ff ff       	jmp    8010664f <alltraps>

80107583 <vector241>:
.globl vector241
vector241:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $241
80107585:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010758a:	e9 c0 f0 ff ff       	jmp    8010664f <alltraps>

8010758f <vector242>:
.globl vector242
vector242:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $242
80107591:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107596:	e9 b4 f0 ff ff       	jmp    8010664f <alltraps>

8010759b <vector243>:
.globl vector243
vector243:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $243
8010759d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801075a2:	e9 a8 f0 ff ff       	jmp    8010664f <alltraps>

801075a7 <vector244>:
.globl vector244
vector244:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $244
801075a9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801075ae:	e9 9c f0 ff ff       	jmp    8010664f <alltraps>

801075b3 <vector245>:
.globl vector245
vector245:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $245
801075b5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801075ba:	e9 90 f0 ff ff       	jmp    8010664f <alltraps>

801075bf <vector246>:
.globl vector246
vector246:
  pushl $0
801075bf:	6a 00                	push   $0x0
  pushl $246
801075c1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801075c6:	e9 84 f0 ff ff       	jmp    8010664f <alltraps>

801075cb <vector247>:
.globl vector247
vector247:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $247
801075cd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801075d2:	e9 78 f0 ff ff       	jmp    8010664f <alltraps>

801075d7 <vector248>:
.globl vector248
vector248:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $248
801075d9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801075de:	e9 6c f0 ff ff       	jmp    8010664f <alltraps>

801075e3 <vector249>:
.globl vector249
vector249:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $249
801075e5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801075ea:	e9 60 f0 ff ff       	jmp    8010664f <alltraps>

801075ef <vector250>:
.globl vector250
vector250:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $250
801075f1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801075f6:	e9 54 f0 ff ff       	jmp    8010664f <alltraps>

801075fb <vector251>:
.globl vector251
vector251:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $251
801075fd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107602:	e9 48 f0 ff ff       	jmp    8010664f <alltraps>

80107607 <vector252>:
.globl vector252
vector252:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $252
80107609:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010760e:	e9 3c f0 ff ff       	jmp    8010664f <alltraps>

80107613 <vector253>:
.globl vector253
vector253:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $253
80107615:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010761a:	e9 30 f0 ff ff       	jmp    8010664f <alltraps>

8010761f <vector254>:
.globl vector254
vector254:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $254
80107621:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107626:	e9 24 f0 ff ff       	jmp    8010664f <alltraps>

8010762b <vector255>:
.globl vector255
vector255:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $255
8010762d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107632:	e9 18 f0 ff ff       	jmp    8010664f <alltraps>
80107637:	66 90                	xchg   %ax,%ax
80107639:	66 90                	xchg   %ax,%ax
8010763b:	66 90                	xchg   %ax,%ax
8010763d:	66 90                	xchg   %ax,%ax
8010763f:	90                   	nop

80107640 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107640:	55                   	push   %ebp
80107641:	89 e5                	mov    %esp,%ebp
80107643:	57                   	push   %edi
80107644:	56                   	push   %esi
80107645:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107646:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010764c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107652:	83 ec 1c             	sub    $0x1c,%esp
80107655:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107658:	39 d3                	cmp    %edx,%ebx
8010765a:	73 49                	jae    801076a5 <deallocuvm.part.0+0x65>
8010765c:	89 c7                	mov    %eax,%edi
8010765e:	eb 0c                	jmp    8010766c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107660:	83 c0 01             	add    $0x1,%eax
80107663:	c1 e0 16             	shl    $0x16,%eax
80107666:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107668:	39 da                	cmp    %ebx,%edx
8010766a:	76 39                	jbe    801076a5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010766c:	89 d8                	mov    %ebx,%eax
8010766e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107671:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107674:	f6 c1 01             	test   $0x1,%cl
80107677:	74 e7                	je     80107660 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107679:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010767b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107681:	c1 ee 0a             	shr    $0xa,%esi
80107684:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010768a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107691:	85 f6                	test   %esi,%esi
80107693:	74 cb                	je     80107660 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107695:	8b 06                	mov    (%esi),%eax
80107697:	a8 01                	test   $0x1,%al
80107699:	75 15                	jne    801076b0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010769b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076a1:	39 da                	cmp    %ebx,%edx
801076a3:	77 c7                	ja     8010766c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801076a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076ab:	5b                   	pop    %ebx
801076ac:	5e                   	pop    %esi
801076ad:	5f                   	pop    %edi
801076ae:	5d                   	pop    %ebp
801076af:	c3                   	ret    
      if(pa == 0)
801076b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801076b5:	74 25                	je     801076dc <deallocuvm.part.0+0x9c>
      kfree(v);
801076b7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801076ba:	05 00 00 00 80       	add    $0x80000000,%eax
801076bf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801076c2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801076c8:	50                   	push   %eax
801076c9:	e8 f2 ad ff ff       	call   801024c0 <kfree>
      *pte = 0;
801076ce:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
801076d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801076d7:	83 c4 10             	add    $0x10,%esp
801076da:	eb 8c                	jmp    80107668 <deallocuvm.part.0+0x28>
        panic("kfree");
801076dc:	83 ec 0c             	sub    $0xc,%esp
801076df:	68 06 83 10 80       	push   $0x80108306
801076e4:	e8 97 8c ff ff       	call   80100380 <panic>
801076e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801076f0 <mappages>:
{
801076f0:	55                   	push   %ebp
801076f1:	89 e5                	mov    %esp,%ebp
801076f3:	57                   	push   %edi
801076f4:	56                   	push   %esi
801076f5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801076f6:	89 d3                	mov    %edx,%ebx
801076f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801076fe:	83 ec 1c             	sub    $0x1c,%esp
80107701:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107704:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107708:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010770d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107710:	8b 45 08             	mov    0x8(%ebp),%eax
80107713:	29 d8                	sub    %ebx,%eax
80107715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107718:	eb 3d                	jmp    80107757 <mappages+0x67>
8010771a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107720:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107722:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107727:	c1 ea 0a             	shr    $0xa,%edx
8010772a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107730:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107737:	85 c0                	test   %eax,%eax
80107739:	74 75                	je     801077b0 <mappages+0xc0>
    if(*pte & PTE_P)
8010773b:	f6 00 01             	testb  $0x1,(%eax)
8010773e:	0f 85 86 00 00 00    	jne    801077ca <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107744:	0b 75 0c             	or     0xc(%ebp),%esi
80107747:	83 ce 01             	or     $0x1,%esi
8010774a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010774c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010774f:	74 6f                	je     801077c0 <mappages+0xd0>
    a += PGSIZE;
80107751:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107757:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010775a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010775d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107760:	89 d8                	mov    %ebx,%eax
80107762:	c1 e8 16             	shr    $0x16,%eax
80107765:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107768:	8b 07                	mov    (%edi),%eax
8010776a:	a8 01                	test   $0x1,%al
8010776c:	75 b2                	jne    80107720 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010776e:	e8 0d af ff ff       	call   80102680 <kalloc>
80107773:	85 c0                	test   %eax,%eax
80107775:	74 39                	je     801077b0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107777:	83 ec 04             	sub    $0x4,%esp
8010777a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010777d:	68 00 10 00 00       	push   $0x1000
80107782:	6a 00                	push   $0x0
80107784:	50                   	push   %eax
80107785:	e8 66 db ff ff       	call   801052f0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010778a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010778d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107790:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107796:	83 c8 07             	or     $0x7,%eax
80107799:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010779b:	89 d8                	mov    %ebx,%eax
8010779d:	c1 e8 0a             	shr    $0xa,%eax
801077a0:	25 fc 0f 00 00       	and    $0xffc,%eax
801077a5:	01 d0                	add    %edx,%eax
801077a7:	eb 92                	jmp    8010773b <mappages+0x4b>
801077a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801077b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801077b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801077b8:	5b                   	pop    %ebx
801077b9:	5e                   	pop    %esi
801077ba:	5f                   	pop    %edi
801077bb:	5d                   	pop    %ebp
801077bc:	c3                   	ret    
801077bd:	8d 76 00             	lea    0x0(%esi),%esi
801077c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801077c3:	31 c0                	xor    %eax,%eax
}
801077c5:	5b                   	pop    %ebx
801077c6:	5e                   	pop    %esi
801077c7:	5f                   	pop    %edi
801077c8:	5d                   	pop    %ebp
801077c9:	c3                   	ret    
      panic("remap");
801077ca:	83 ec 0c             	sub    $0xc,%esp
801077cd:	68 ec 89 10 80       	push   $0x801089ec
801077d2:	e8 a9 8b ff ff       	call   80100380 <panic>
801077d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077de:	66 90                	xchg   %ax,%ax

801077e0 <seginit>:
{
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801077e6:	e8 85 c4 ff ff       	call   80103c70 <cpuid>
  pd[0] = size-1;
801077eb:	ba 2f 00 00 00       	mov    $0x2f,%edx
801077f0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801077f6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801077fa:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107801:	ff 00 00 
80107804:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
8010780b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010780e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107815:	ff 00 00 
80107818:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
8010781f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107822:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107829:	ff 00 00 
8010782c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80107833:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107836:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
8010783d:	ff 00 00 
80107840:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80107847:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010784a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
8010784f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107853:	c1 e8 10             	shr    $0x10,%eax
80107856:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010785a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010785d:	0f 01 10             	lgdtl  (%eax)
}
80107860:	c9                   	leave  
80107861:	c3                   	ret    
80107862:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107870 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107870:	a1 64 5e 11 80       	mov    0x80115e64,%eax
80107875:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010787a:	0f 22 d8             	mov    %eax,%cr3
}
8010787d:	c3                   	ret    
8010787e:	66 90                	xchg   %ax,%ax

80107880 <switchuvm>:
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	57                   	push   %edi
80107884:	56                   	push   %esi
80107885:	53                   	push   %ebx
80107886:	83 ec 1c             	sub    $0x1c,%esp
80107889:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010788c:	85 f6                	test   %esi,%esi
8010788e:	0f 84 cb 00 00 00    	je     8010795f <switchuvm+0xdf>
  if(p->kstack == 0)
80107894:	8b 46 08             	mov    0x8(%esi),%eax
80107897:	85 c0                	test   %eax,%eax
80107899:	0f 84 da 00 00 00    	je     80107979 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010789f:	8b 46 04             	mov    0x4(%esi),%eax
801078a2:	85 c0                	test   %eax,%eax
801078a4:	0f 84 c2 00 00 00    	je     8010796c <switchuvm+0xec>
  pushcli();
801078aa:	e8 31 d8 ff ff       	call   801050e0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801078af:	e8 5c c3 ff ff       	call   80103c10 <mycpu>
801078b4:	89 c3                	mov    %eax,%ebx
801078b6:	e8 55 c3 ff ff       	call   80103c10 <mycpu>
801078bb:	89 c7                	mov    %eax,%edi
801078bd:	e8 4e c3 ff ff       	call   80103c10 <mycpu>
801078c2:	83 c7 08             	add    $0x8,%edi
801078c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801078c8:	e8 43 c3 ff ff       	call   80103c10 <mycpu>
801078cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801078d0:	ba 67 00 00 00       	mov    $0x67,%edx
801078d5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801078dc:	83 c0 08             	add    $0x8,%eax
801078df:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801078e6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801078eb:	83 c1 08             	add    $0x8,%ecx
801078ee:	c1 e8 18             	shr    $0x18,%eax
801078f1:	c1 e9 10             	shr    $0x10,%ecx
801078f4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801078fa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107900:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107905:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010790c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107911:	e8 fa c2 ff ff       	call   80103c10 <mycpu>
80107916:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010791d:	e8 ee c2 ff ff       	call   80103c10 <mycpu>
80107922:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107926:	8b 5e 08             	mov    0x8(%esi),%ebx
80107929:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010792f:	e8 dc c2 ff ff       	call   80103c10 <mycpu>
80107934:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107937:	e8 d4 c2 ff ff       	call   80103c10 <mycpu>
8010793c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107940:	b8 28 00 00 00       	mov    $0x28,%eax
80107945:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107948:	8b 46 04             	mov    0x4(%esi),%eax
8010794b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107950:	0f 22 d8             	mov    %eax,%cr3
}
80107953:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107956:	5b                   	pop    %ebx
80107957:	5e                   	pop    %esi
80107958:	5f                   	pop    %edi
80107959:	5d                   	pop    %ebp
  popcli();
8010795a:	e9 d1 d7 ff ff       	jmp    80105130 <popcli>
    panic("switchuvm: no process");
8010795f:	83 ec 0c             	sub    $0xc,%esp
80107962:	68 f2 89 10 80       	push   $0x801089f2
80107967:	e8 14 8a ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010796c:	83 ec 0c             	sub    $0xc,%esp
8010796f:	68 1d 8a 10 80       	push   $0x80108a1d
80107974:	e8 07 8a ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107979:	83 ec 0c             	sub    $0xc,%esp
8010797c:	68 08 8a 10 80       	push   $0x80108a08
80107981:	e8 fa 89 ff ff       	call   80100380 <panic>
80107986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010798d:	8d 76 00             	lea    0x0(%esi),%esi

80107990 <inituvm>:
{
80107990:	55                   	push   %ebp
80107991:	89 e5                	mov    %esp,%ebp
80107993:	57                   	push   %edi
80107994:	56                   	push   %esi
80107995:	53                   	push   %ebx
80107996:	83 ec 1c             	sub    $0x1c,%esp
80107999:	8b 45 0c             	mov    0xc(%ebp),%eax
8010799c:	8b 75 10             	mov    0x10(%ebp),%esi
8010799f:	8b 7d 08             	mov    0x8(%ebp),%edi
801079a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801079a5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801079ab:	77 4b                	ja     801079f8 <inituvm+0x68>
  mem = kalloc();
801079ad:	e8 ce ac ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
801079b2:	83 ec 04             	sub    $0x4,%esp
801079b5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801079ba:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801079bc:	6a 00                	push   $0x0
801079be:	50                   	push   %eax
801079bf:	e8 2c d9 ff ff       	call   801052f0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801079c4:	58                   	pop    %eax
801079c5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801079cb:	5a                   	pop    %edx
801079cc:	6a 06                	push   $0x6
801079ce:	b9 00 10 00 00       	mov    $0x1000,%ecx
801079d3:	31 d2                	xor    %edx,%edx
801079d5:	50                   	push   %eax
801079d6:	89 f8                	mov    %edi,%eax
801079d8:	e8 13 fd ff ff       	call   801076f0 <mappages>
  memmove(mem, init, sz);
801079dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079e0:	89 75 10             	mov    %esi,0x10(%ebp)
801079e3:	83 c4 10             	add    $0x10,%esp
801079e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801079e9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801079ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079ef:	5b                   	pop    %ebx
801079f0:	5e                   	pop    %esi
801079f1:	5f                   	pop    %edi
801079f2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801079f3:	e9 98 d9 ff ff       	jmp    80105390 <memmove>
    panic("inituvm: more than a page");
801079f8:	83 ec 0c             	sub    $0xc,%esp
801079fb:	68 31 8a 10 80       	push   $0x80108a31
80107a00:	e8 7b 89 ff ff       	call   80100380 <panic>
80107a05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107a10 <loaduvm>:
{
80107a10:	55                   	push   %ebp
80107a11:	89 e5                	mov    %esp,%ebp
80107a13:	57                   	push   %edi
80107a14:	56                   	push   %esi
80107a15:	53                   	push   %ebx
80107a16:	83 ec 1c             	sub    $0x1c,%esp
80107a19:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a1c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107a1f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107a24:	0f 85 bb 00 00 00    	jne    80107ae5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80107a2a:	01 f0                	add    %esi,%eax
80107a2c:	89 f3                	mov    %esi,%ebx
80107a2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a31:	8b 45 14             	mov    0x14(%ebp),%eax
80107a34:	01 f0                	add    %esi,%eax
80107a36:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107a39:	85 f6                	test   %esi,%esi
80107a3b:	0f 84 87 00 00 00    	je     80107ac8 <loaduvm+0xb8>
80107a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107a48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80107a4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107a4e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107a50:	89 c2                	mov    %eax,%edx
80107a52:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107a55:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107a58:	f6 c2 01             	test   $0x1,%dl
80107a5b:	75 13                	jne    80107a70 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80107a5d:	83 ec 0c             	sub    $0xc,%esp
80107a60:	68 4b 8a 10 80       	push   $0x80108a4b
80107a65:	e8 16 89 ff ff       	call   80100380 <panic>
80107a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107a70:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a73:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107a79:	25 fc 0f 00 00       	and    $0xffc,%eax
80107a7e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107a85:	85 c0                	test   %eax,%eax
80107a87:	74 d4                	je     80107a5d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107a89:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a8b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107a8e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107a93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107a98:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107a9e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107aa1:	29 d9                	sub    %ebx,%ecx
80107aa3:	05 00 00 00 80       	add    $0x80000000,%eax
80107aa8:	57                   	push   %edi
80107aa9:	51                   	push   %ecx
80107aaa:	50                   	push   %eax
80107aab:	ff 75 10             	push   0x10(%ebp)
80107aae:	e8 dd 9f ff ff       	call   80101a90 <readi>
80107ab3:	83 c4 10             	add    $0x10,%esp
80107ab6:	39 f8                	cmp    %edi,%eax
80107ab8:	75 1e                	jne    80107ad8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107aba:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107ac0:	89 f0                	mov    %esi,%eax
80107ac2:	29 d8                	sub    %ebx,%eax
80107ac4:	39 c6                	cmp    %eax,%esi
80107ac6:	77 80                	ja     80107a48 <loaduvm+0x38>
}
80107ac8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107acb:	31 c0                	xor    %eax,%eax
}
80107acd:	5b                   	pop    %ebx
80107ace:	5e                   	pop    %esi
80107acf:	5f                   	pop    %edi
80107ad0:	5d                   	pop    %ebp
80107ad1:	c3                   	ret    
80107ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107ad8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107adb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ae0:	5b                   	pop    %ebx
80107ae1:	5e                   	pop    %esi
80107ae2:	5f                   	pop    %edi
80107ae3:	5d                   	pop    %ebp
80107ae4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107ae5:	83 ec 0c             	sub    $0xc,%esp
80107ae8:	68 ec 8a 10 80       	push   $0x80108aec
80107aed:	e8 8e 88 ff ff       	call   80100380 <panic>
80107af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b00 <allocuvm>:
{
80107b00:	55                   	push   %ebp
80107b01:	89 e5                	mov    %esp,%ebp
80107b03:	57                   	push   %edi
80107b04:	56                   	push   %esi
80107b05:	53                   	push   %ebx
80107b06:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107b09:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107b0c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107b0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107b12:	85 c0                	test   %eax,%eax
80107b14:	0f 88 b6 00 00 00    	js     80107bd0 <allocuvm+0xd0>
  if(newsz < oldsz)
80107b1a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107b20:	0f 82 9a 00 00 00    	jb     80107bc0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107b26:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107b2c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107b32:	39 75 10             	cmp    %esi,0x10(%ebp)
80107b35:	77 44                	ja     80107b7b <allocuvm+0x7b>
80107b37:	e9 87 00 00 00       	jmp    80107bc3 <allocuvm+0xc3>
80107b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107b40:	83 ec 04             	sub    $0x4,%esp
80107b43:	68 00 10 00 00       	push   $0x1000
80107b48:	6a 00                	push   $0x0
80107b4a:	50                   	push   %eax
80107b4b:	e8 a0 d7 ff ff       	call   801052f0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107b50:	58                   	pop    %eax
80107b51:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107b57:	5a                   	pop    %edx
80107b58:	6a 06                	push   $0x6
80107b5a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b5f:	89 f2                	mov    %esi,%edx
80107b61:	50                   	push   %eax
80107b62:	89 f8                	mov    %edi,%eax
80107b64:	e8 87 fb ff ff       	call   801076f0 <mappages>
80107b69:	83 c4 10             	add    $0x10,%esp
80107b6c:	85 c0                	test   %eax,%eax
80107b6e:	78 78                	js     80107be8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107b70:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107b76:	39 75 10             	cmp    %esi,0x10(%ebp)
80107b79:	76 48                	jbe    80107bc3 <allocuvm+0xc3>
    mem = kalloc();
80107b7b:	e8 00 ab ff ff       	call   80102680 <kalloc>
80107b80:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107b82:	85 c0                	test   %eax,%eax
80107b84:	75 ba                	jne    80107b40 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107b86:	83 ec 0c             	sub    $0xc,%esp
80107b89:	68 69 8a 10 80       	push   $0x80108a69
80107b8e:	e8 0d 8b ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107b93:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b96:	83 c4 10             	add    $0x10,%esp
80107b99:	39 45 10             	cmp    %eax,0x10(%ebp)
80107b9c:	74 32                	je     80107bd0 <allocuvm+0xd0>
80107b9e:	8b 55 10             	mov    0x10(%ebp),%edx
80107ba1:	89 c1                	mov    %eax,%ecx
80107ba3:	89 f8                	mov    %edi,%eax
80107ba5:	e8 96 fa ff ff       	call   80107640 <deallocuvm.part.0>
      return 0;
80107baa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107bb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107bb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bb7:	5b                   	pop    %ebx
80107bb8:	5e                   	pop    %esi
80107bb9:	5f                   	pop    %edi
80107bba:	5d                   	pop    %ebp
80107bbb:	c3                   	ret    
80107bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107bc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107bc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107bc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bc9:	5b                   	pop    %ebx
80107bca:	5e                   	pop    %esi
80107bcb:	5f                   	pop    %edi
80107bcc:	5d                   	pop    %ebp
80107bcd:	c3                   	ret    
80107bce:	66 90                	xchg   %ax,%ax
    return 0;
80107bd0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107bda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bdd:	5b                   	pop    %ebx
80107bde:	5e                   	pop    %esi
80107bdf:	5f                   	pop    %edi
80107be0:	5d                   	pop    %ebp
80107be1:	c3                   	ret    
80107be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107be8:	83 ec 0c             	sub    $0xc,%esp
80107beb:	68 81 8a 10 80       	push   $0x80108a81
80107bf0:	e8 ab 8a ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bf8:	83 c4 10             	add    $0x10,%esp
80107bfb:	39 45 10             	cmp    %eax,0x10(%ebp)
80107bfe:	74 0c                	je     80107c0c <allocuvm+0x10c>
80107c00:	8b 55 10             	mov    0x10(%ebp),%edx
80107c03:	89 c1                	mov    %eax,%ecx
80107c05:	89 f8                	mov    %edi,%eax
80107c07:	e8 34 fa ff ff       	call   80107640 <deallocuvm.part.0>
      kfree(mem);
80107c0c:	83 ec 0c             	sub    $0xc,%esp
80107c0f:	53                   	push   %ebx
80107c10:	e8 ab a8 ff ff       	call   801024c0 <kfree>
      return 0;
80107c15:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107c1c:	83 c4 10             	add    $0x10,%esp
}
80107c1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c25:	5b                   	pop    %ebx
80107c26:	5e                   	pop    %esi
80107c27:	5f                   	pop    %edi
80107c28:	5d                   	pop    %ebp
80107c29:	c3                   	ret    
80107c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107c30 <deallocuvm>:
{
80107c30:	55                   	push   %ebp
80107c31:	89 e5                	mov    %esp,%ebp
80107c33:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c36:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107c39:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107c3c:	39 d1                	cmp    %edx,%ecx
80107c3e:	73 10                	jae    80107c50 <deallocuvm+0x20>
}
80107c40:	5d                   	pop    %ebp
80107c41:	e9 fa f9 ff ff       	jmp    80107640 <deallocuvm.part.0>
80107c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c4d:	8d 76 00             	lea    0x0(%esi),%esi
80107c50:	89 d0                	mov    %edx,%eax
80107c52:	5d                   	pop    %ebp
80107c53:	c3                   	ret    
80107c54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c5f:	90                   	nop

80107c60 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107c60:	55                   	push   %ebp
80107c61:	89 e5                	mov    %esp,%ebp
80107c63:	57                   	push   %edi
80107c64:	56                   	push   %esi
80107c65:	53                   	push   %ebx
80107c66:	83 ec 0c             	sub    $0xc,%esp
80107c69:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107c6c:	85 f6                	test   %esi,%esi
80107c6e:	74 59                	je     80107cc9 <freevm+0x69>
  if(newsz >= oldsz)
80107c70:	31 c9                	xor    %ecx,%ecx
80107c72:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107c77:	89 f0                	mov    %esi,%eax
80107c79:	89 f3                	mov    %esi,%ebx
80107c7b:	e8 c0 f9 ff ff       	call   80107640 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107c80:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107c86:	eb 0f                	jmp    80107c97 <freevm+0x37>
80107c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c8f:	90                   	nop
80107c90:	83 c3 04             	add    $0x4,%ebx
80107c93:	39 df                	cmp    %ebx,%edi
80107c95:	74 23                	je     80107cba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107c97:	8b 03                	mov    (%ebx),%eax
80107c99:	a8 01                	test   $0x1,%al
80107c9b:	74 f3                	je     80107c90 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107c9d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107ca2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107ca5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107ca8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107cad:	50                   	push   %eax
80107cae:	e8 0d a8 ff ff       	call   801024c0 <kfree>
80107cb3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107cb6:	39 df                	cmp    %ebx,%edi
80107cb8:	75 dd                	jne    80107c97 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107cba:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107cbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cc0:	5b                   	pop    %ebx
80107cc1:	5e                   	pop    %esi
80107cc2:	5f                   	pop    %edi
80107cc3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107cc4:	e9 f7 a7 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107cc9:	83 ec 0c             	sub    $0xc,%esp
80107ccc:	68 9d 8a 10 80       	push   $0x80108a9d
80107cd1:	e8 aa 86 ff ff       	call   80100380 <panic>
80107cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cdd:	8d 76 00             	lea    0x0(%esi),%esi

80107ce0 <setupkvm>:
{
80107ce0:	55                   	push   %ebp
80107ce1:	89 e5                	mov    %esp,%ebp
80107ce3:	56                   	push   %esi
80107ce4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107ce5:	e8 96 a9 ff ff       	call   80102680 <kalloc>
80107cea:	89 c6                	mov    %eax,%esi
80107cec:	85 c0                	test   %eax,%eax
80107cee:	74 42                	je     80107d32 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107cf0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107cf3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107cf8:	68 00 10 00 00       	push   $0x1000
80107cfd:	6a 00                	push   $0x0
80107cff:	50                   	push   %eax
80107d00:	e8 eb d5 ff ff       	call   801052f0 <memset>
80107d05:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107d08:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107d0b:	83 ec 08             	sub    $0x8,%esp
80107d0e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107d11:	ff 73 0c             	push   0xc(%ebx)
80107d14:	8b 13                	mov    (%ebx),%edx
80107d16:	50                   	push   %eax
80107d17:	29 c1                	sub    %eax,%ecx
80107d19:	89 f0                	mov    %esi,%eax
80107d1b:	e8 d0 f9 ff ff       	call   801076f0 <mappages>
80107d20:	83 c4 10             	add    $0x10,%esp
80107d23:	85 c0                	test   %eax,%eax
80107d25:	78 19                	js     80107d40 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d27:	83 c3 10             	add    $0x10,%ebx
80107d2a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107d30:	75 d6                	jne    80107d08 <setupkvm+0x28>
}
80107d32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d35:	89 f0                	mov    %esi,%eax
80107d37:	5b                   	pop    %ebx
80107d38:	5e                   	pop    %esi
80107d39:	5d                   	pop    %ebp
80107d3a:	c3                   	ret    
80107d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d3f:	90                   	nop
      freevm(pgdir);
80107d40:	83 ec 0c             	sub    $0xc,%esp
80107d43:	56                   	push   %esi
      return 0;
80107d44:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107d46:	e8 15 ff ff ff       	call   80107c60 <freevm>
      return 0;
80107d4b:	83 c4 10             	add    $0x10,%esp
}
80107d4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d51:	89 f0                	mov    %esi,%eax
80107d53:	5b                   	pop    %ebx
80107d54:	5e                   	pop    %esi
80107d55:	5d                   	pop    %ebp
80107d56:	c3                   	ret    
80107d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d5e:	66 90                	xchg   %ax,%ax

80107d60 <kvmalloc>:
{
80107d60:	55                   	push   %ebp
80107d61:	89 e5                	mov    %esp,%ebp
80107d63:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107d66:	e8 75 ff ff ff       	call   80107ce0 <setupkvm>
80107d6b:	a3 64 5e 11 80       	mov    %eax,0x80115e64
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107d70:	05 00 00 00 80       	add    $0x80000000,%eax
80107d75:	0f 22 d8             	mov    %eax,%cr3
}
80107d78:	c9                   	leave  
80107d79:	c3                   	ret    
80107d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107d80 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107d80:	55                   	push   %ebp
80107d81:	89 e5                	mov    %esp,%ebp
80107d83:	83 ec 08             	sub    $0x8,%esp
80107d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107d89:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107d8c:	89 c1                	mov    %eax,%ecx
80107d8e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107d91:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107d94:	f6 c2 01             	test   $0x1,%dl
80107d97:	75 17                	jne    80107db0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107d99:	83 ec 0c             	sub    $0xc,%esp
80107d9c:	68 ae 8a 10 80       	push   $0x80108aae
80107da1:	e8 da 85 ff ff       	call   80100380 <panic>
80107da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dad:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107db0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107db3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107db9:	25 fc 0f 00 00       	and    $0xffc,%eax
80107dbe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107dc5:	85 c0                	test   %eax,%eax
80107dc7:	74 d0                	je     80107d99 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107dc9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107dcc:	c9                   	leave  
80107dcd:	c3                   	ret    
80107dce:	66 90                	xchg   %ax,%ax

80107dd0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107dd0:	55                   	push   %ebp
80107dd1:	89 e5                	mov    %esp,%ebp
80107dd3:	57                   	push   %edi
80107dd4:	56                   	push   %esi
80107dd5:	53                   	push   %ebx
80107dd6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107dd9:	e8 02 ff ff ff       	call   80107ce0 <setupkvm>
80107dde:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107de1:	85 c0                	test   %eax,%eax
80107de3:	0f 84 bd 00 00 00    	je     80107ea6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107dec:	85 c9                	test   %ecx,%ecx
80107dee:	0f 84 b2 00 00 00    	je     80107ea6 <copyuvm+0xd6>
80107df4:	31 f6                	xor    %esi,%esi
80107df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dfd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107e00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107e03:	89 f0                	mov    %esi,%eax
80107e05:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107e08:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80107e0b:	a8 01                	test   $0x1,%al
80107e0d:	75 11                	jne    80107e20 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107e0f:	83 ec 0c             	sub    $0xc,%esp
80107e12:	68 b8 8a 10 80       	push   $0x80108ab8
80107e17:	e8 64 85 ff ff       	call   80100380 <panic>
80107e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107e20:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107e22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107e27:	c1 ea 0a             	shr    $0xa,%edx
80107e2a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107e30:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107e37:	85 c0                	test   %eax,%eax
80107e39:	74 d4                	je     80107e0f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
80107e3b:	8b 00                	mov    (%eax),%eax
80107e3d:	a8 01                	test   $0x1,%al
80107e3f:	0f 84 9f 00 00 00    	je     80107ee4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107e45:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107e47:	25 ff 0f 00 00       	and    $0xfff,%eax
80107e4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107e4f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107e55:	e8 26 a8 ff ff       	call   80102680 <kalloc>
80107e5a:	89 c3                	mov    %eax,%ebx
80107e5c:	85 c0                	test   %eax,%eax
80107e5e:	74 64                	je     80107ec4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107e60:	83 ec 04             	sub    $0x4,%esp
80107e63:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107e69:	68 00 10 00 00       	push   $0x1000
80107e6e:	57                   	push   %edi
80107e6f:	50                   	push   %eax
80107e70:	e8 1b d5 ff ff       	call   80105390 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107e75:	58                   	pop    %eax
80107e76:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107e7c:	5a                   	pop    %edx
80107e7d:	ff 75 e4             	push   -0x1c(%ebp)
80107e80:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107e85:	89 f2                	mov    %esi,%edx
80107e87:	50                   	push   %eax
80107e88:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e8b:	e8 60 f8 ff ff       	call   801076f0 <mappages>
80107e90:	83 c4 10             	add    $0x10,%esp
80107e93:	85 c0                	test   %eax,%eax
80107e95:	78 21                	js     80107eb8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107e97:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107e9d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107ea0:	0f 87 5a ff ff ff    	ja     80107e00 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107ea6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107eac:	5b                   	pop    %ebx
80107ead:	5e                   	pop    %esi
80107eae:	5f                   	pop    %edi
80107eaf:	5d                   	pop    %ebp
80107eb0:	c3                   	ret    
80107eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107eb8:	83 ec 0c             	sub    $0xc,%esp
80107ebb:	53                   	push   %ebx
80107ebc:	e8 ff a5 ff ff       	call   801024c0 <kfree>
      goto bad;
80107ec1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107ec4:	83 ec 0c             	sub    $0xc,%esp
80107ec7:	ff 75 e0             	push   -0x20(%ebp)
80107eca:	e8 91 fd ff ff       	call   80107c60 <freevm>
  return 0;
80107ecf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107ed6:	83 c4 10             	add    $0x10,%esp
}
80107ed9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107edc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107edf:	5b                   	pop    %ebx
80107ee0:	5e                   	pop    %esi
80107ee1:	5f                   	pop    %edi
80107ee2:	5d                   	pop    %ebp
80107ee3:	c3                   	ret    
      panic("copyuvm: page not present");
80107ee4:	83 ec 0c             	sub    $0xc,%esp
80107ee7:	68 d2 8a 10 80       	push   $0x80108ad2
80107eec:	e8 8f 84 ff ff       	call   80100380 <panic>
80107ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107eff:	90                   	nop

80107f00 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107f00:	55                   	push   %ebp
80107f01:	89 e5                	mov    %esp,%ebp
80107f03:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107f06:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107f09:	89 c1                	mov    %eax,%ecx
80107f0b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107f0e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107f11:	f6 c2 01             	test   $0x1,%dl
80107f14:	0f 84 00 01 00 00    	je     8010801a <uva2ka.cold>
  return &pgtab[PTX(va)];
80107f1a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107f1d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107f23:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107f24:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107f29:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107f30:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107f32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107f37:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107f3a:	05 00 00 00 80       	add    $0x80000000,%eax
80107f3f:	83 fa 05             	cmp    $0x5,%edx
80107f42:	ba 00 00 00 00       	mov    $0x0,%edx
80107f47:	0f 45 c2             	cmovne %edx,%eax
}
80107f4a:	c3                   	ret    
80107f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107f4f:	90                   	nop

80107f50 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107f50:	55                   	push   %ebp
80107f51:	89 e5                	mov    %esp,%ebp
80107f53:	57                   	push   %edi
80107f54:	56                   	push   %esi
80107f55:	53                   	push   %ebx
80107f56:	83 ec 0c             	sub    $0xc,%esp
80107f59:	8b 75 14             	mov    0x14(%ebp),%esi
80107f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f5f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107f62:	85 f6                	test   %esi,%esi
80107f64:	75 51                	jne    80107fb7 <copyout+0x67>
80107f66:	e9 a5 00 00 00       	jmp    80108010 <copyout+0xc0>
80107f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107f6f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107f70:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107f76:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107f7c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107f82:	74 75                	je     80107ff9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107f84:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107f86:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107f89:	29 c3                	sub    %eax,%ebx
80107f8b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107f91:	39 f3                	cmp    %esi,%ebx
80107f93:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107f96:	29 f8                	sub    %edi,%eax
80107f98:	83 ec 04             	sub    $0x4,%esp
80107f9b:	01 c1                	add    %eax,%ecx
80107f9d:	53                   	push   %ebx
80107f9e:	52                   	push   %edx
80107f9f:	51                   	push   %ecx
80107fa0:	e8 eb d3 ff ff       	call   80105390 <memmove>
    len -= n;
    buf += n;
80107fa5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107fa8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107fae:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107fb1:	01 da                	add    %ebx,%edx
  while(len > 0){
80107fb3:	29 de                	sub    %ebx,%esi
80107fb5:	74 59                	je     80108010 <copyout+0xc0>
  if(*pde & PTE_P){
80107fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107fba:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107fbc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107fbe:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107fc1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107fc7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107fca:	f6 c1 01             	test   $0x1,%cl
80107fcd:	0f 84 4e 00 00 00    	je     80108021 <copyout.cold>
  return &pgtab[PTX(va)];
80107fd3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107fd5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107fdb:	c1 eb 0c             	shr    $0xc,%ebx
80107fde:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107fe4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107feb:	89 d9                	mov    %ebx,%ecx
80107fed:	83 e1 05             	and    $0x5,%ecx
80107ff0:	83 f9 05             	cmp    $0x5,%ecx
80107ff3:	0f 84 77 ff ff ff    	je     80107f70 <copyout+0x20>
  }
  return 0;
}
80107ff9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107ffc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108001:	5b                   	pop    %ebx
80108002:	5e                   	pop    %esi
80108003:	5f                   	pop    %edi
80108004:	5d                   	pop    %ebp
80108005:	c3                   	ret    
80108006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010800d:	8d 76 00             	lea    0x0(%esi),%esi
80108010:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108013:	31 c0                	xor    %eax,%eax
}
80108015:	5b                   	pop    %ebx
80108016:	5e                   	pop    %esi
80108017:	5f                   	pop    %edi
80108018:	5d                   	pop    %ebp
80108019:	c3                   	ret    

8010801a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010801a:	a1 00 00 00 00       	mov    0x0,%eax
8010801f:	0f 0b                	ud2    

80108021 <copyout.cold>:
80108021:	a1 00 00 00 00       	mov    0x0,%eax
80108026:	0f 0b                	ud2    
80108028:	66 90                	xchg   %ax,%ax
8010802a:	66 90                	xchg   %ax,%ax
8010802c:	66 90                	xchg   %ax,%ax
8010802e:	66 90                	xchg   %ax,%ax

80108030 <myfunction>:
#include "defs.h"

// Simple system call
int
myfunction(char *str)
{
80108030:	55                   	push   %ebp
80108031:	89 e5                	mov    %esp,%ebp
80108033:	83 ec 10             	sub    $0x10,%esp
    cprintf("%s\n", str);
80108036:	ff 75 08             	push   0x8(%ebp)
80108039:	68 0f 8b 10 80       	push   $0x80108b0f
8010803e:	e8 5d 86 ff ff       	call   801006a0 <cprintf>
    return 0xABCDABCD;
}
80108043:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
80108048:	c9                   	leave  
80108049:	c3                   	ret    
8010804a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108050 <sys_myfunction>:

// Wrapper for myfunction
int
sys_myfunction(void)
{
80108050:	55                   	push   %ebp
80108051:	89 e5                	mov    %esp,%ebp
80108053:	83 ec 20             	sub    $0x20,%esp
    char *str;
    // Decode argument using argstr
    if (argstr(0, &str) < 0)
80108056:	8d 45 f4             	lea    -0xc(%ebp),%eax
80108059:	50                   	push   %eax
8010805a:	6a 00                	push   $0x0
8010805c:	e8 0f d6 ff ff       	call   80105670 <argstr>
80108061:	83 c4 10             	add    $0x10,%esp
80108064:	89 c2                	mov    %eax,%edx
80108066:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010806b:	85 d2                	test   %edx,%edx
8010806d:	78 18                	js     80108087 <sys_myfunction+0x37>
    cprintf("%s\n", str);
8010806f:	83 ec 08             	sub    $0x8,%esp
80108072:	ff 75 f4             	push   -0xc(%ebp)
80108075:	68 0f 8b 10 80       	push   $0x80108b0f
8010807a:	e8 21 86 ff ff       	call   801006a0 <cprintf>
        return -1;
    return myfunction(str);
8010807f:	83 c4 10             	add    $0x10,%esp
80108082:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
}
80108087:	c9                   	leave  
80108088:	c3                   	ret    

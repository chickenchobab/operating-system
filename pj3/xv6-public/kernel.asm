
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
80100028:	bc d0 69 11 80       	mov    $0x801169d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 30 10 80       	mov    $0x80103080,%eax
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
8010004c:	68 00 7a 10 80       	push   $0x80107a00
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 e5 49 00 00       	call   80104a40 <initlock>
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
80100092:	68 07 7a 10 80       	push   $0x80107a07
80100097:	50                   	push   %eax
80100098:	e8 73 48 00 00       	call   80104910 <initsleeplock>
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
801000e4:	e8 27 4b 00 00       	call   80104c10 <acquire>
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
80100162:	e8 49 4a 00 00       	call   80104bb0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 47 00 00       	call   80104950 <acquiresleep>
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
8010018c:	e8 6f 21 00 00       	call   80102300 <iderw>
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
801001a1:	68 0e 7a 10 80       	push   $0x80107a0e
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
801001be:	e8 2d 48 00 00       	call   801049f0 <holdingsleep>
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
801001d4:	e9 27 21 00 00       	jmp    80102300 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 7a 10 80       	push   $0x80107a1f
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
801001ff:	e8 ec 47 00 00       	call   801049f0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 9c 47 00 00       	call   801049b0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 f0 49 00 00       	call   80104c10 <acquire>
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
8010026c:	e9 3f 49 00 00       	jmp    80104bb0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 26 7a 10 80       	push   $0x80107a26
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
80100294:	e8 e7 15 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 6b 49 00 00       	call   80104c10 <acquire>
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
801002cd:	e8 4e 3e 00 00       	call   80104120 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 49 37 00 00       	call   80103a30 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 b5 48 00 00       	call   80104bb0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 9c 14 00 00       	call   801017a0 <ilock>
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
8010034c:	e8 5f 48 00 00       	call   80104bb0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 46 14 00 00       	call   801017a0 <ilock>
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
80100399:	e8 72 25 00 00       	call   80102910 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 7a 10 80       	push   $0x80107a2d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 63 83 10 80 	movl   $0x80108363,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 93 46 00 00       	call   80104a60 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 7a 10 80       	push   $0x80107a41
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
8010041a:	e8 01 61 00 00       	call   80106520 <uartputc>
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
80100505:	e8 16 60 00 00       	call   80106520 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 0a 60 00 00       	call   80106520 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 fe 5f 00 00       	call   80106520 <uartputc>
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
80100551:	e8 1a 48 00 00       	call   80104d70 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 65 47 00 00       	call   80104cd0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 45 7a 10 80       	push   $0x80107a45
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
8010059f:	e8 dc 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 60 46 00 00       	call   80104c10 <acquire>
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
801005e4:	e8 c7 45 00 00       	call   80104bb0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 ae 11 00 00       	call   801017a0 <ilock>

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
80100636:	0f b6 92 70 7a 10 80 	movzbl -0x7fef8590(%edx),%edx
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
801007e8:	e8 23 44 00 00       	call   80104c10 <acquire>
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
80100838:	bf 58 7a 10 80       	mov    $0x80107a58,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 50 43 00 00       	call   80104bb0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 5f 7a 10 80       	push   $0x80107a5f
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
80100893:	e8 78 43 00 00       	call   80104c10 <acquire>
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
801009d0:	e8 db 41 00 00       	call   80104bb0 <release>
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
80100a0e:	e9 ad 38 00 00       	jmp    801042c0 <procdump>
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
80100a44:	e8 97 37 00 00       	call   801041e0 <wakeup>
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
80100a66:	68 68 7a 10 80       	push   $0x80107a68
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 cb 3f 00 00       	call   80104a40 <initlock>

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
80100a99:	e8 02 1a 00 00       	call   801024a0 <ioapicenable>
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
80100abc:	e8 6f 2f 00 00       	call   80103a30 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 b4 22 00 00       	call   80102d80 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 e9 15 00 00       	call   801020c0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 22 03 00 00    	je     80100e04 <exec+0x354>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 b3 0c 00 00       	call   801017a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 b2 0f 00 00       	call   80101ab0 <readi>
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
80100b0a:	e8 21 0f 00 00       	call   80101a30 <iunlockput>
    end_op();
80100b0f:	e8 dc 22 00 00       	call   80102df0 <end_op>
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
80100b34:	e8 77 6b 00 00       	call   801076b0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 cc 02 00 00    	je     80100e23 <exec+0x373>
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
80100ba3:	e8 28 69 00 00       	call   801074d0 <allocuvm>
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
80100bd9:	e8 02 68 00 00       	call   801073e0 <loaduvm>
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
80100c01:	e8 aa 0e 00 00       	call   80101ab0 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 10 6a 00 00       	call   80107630 <freevm>
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
80100c4c:	e8 df 0d 00 00       	call   80101a30 <iunlockput>
  end_op();
80100c51:	e8 9a 21 00 00       	call   80102df0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 69 68 00 00       	call   801074d0 <allocuvm>
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
80100c83:	e8 c8 6a 00 00       	call   80107750 <clearpteu>
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
80100cd3:	e8 f8 41 00 00       	call   80104ed0 <strlen>
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
80100ce7:	e8 e4 41 00 00       	call   80104ed0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 23 6c 00 00       	call   80107920 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 1a 69 00 00       	call   80107630 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[1] = argc;
80100d32:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[3+argc] = 0;
80100d38:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d3f:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d43:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d45:	89 df                	mov    %ebx,%edi
80100d47:	83 c0 0c             	add    $0xc,%eax
80100d4a:	29 c7                	sub    %eax,%edi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4c:	50                   	push   %eax
80100d4d:	52                   	push   %edx
80100d4e:	57                   	push   %edi
80100d4f:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d55:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5c:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5f:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d65:	e8 b6 6b 00 00       	call   80107920 <copyout>
80100d6a:	83 c4 10             	add    $0x10,%esp
80100d6d:	85 c0                	test   %eax,%eax
80100d6f:	78 97                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d71:	8b 45 08             	mov    0x8(%ebp),%eax
80100d74:	8b 55 08             	mov    0x8(%ebp),%edx
80100d77:	0f b6 00             	movzbl (%eax),%eax
80100d7a:	84 c0                	test   %al,%al
80100d7c:	74 11                	je     80100d8f <exec+0x2df>
80100d7e:	89 d1                	mov    %edx,%ecx
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
80100d8f:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 d8                	mov    %ebx,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 ea 40 00 00       	call   80104e90 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 d8                	mov    %ebx,%eax
80100dae:	8b 5b 04             	mov    0x4(%ebx),%ebx
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db3:	89 c6                	mov    %eax,%esi
  curproc->pgdir = pgdir;
80100db5:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db8:	8b 40 18             	mov    0x18(%eax),%eax
80100dbb:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 46 18             	mov    0x18(%esi),%eax
80100dc7:	89 78 44             	mov    %edi,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 34 24             	mov    %esi,(%esp)
80100dcd:	e8 7e 64 00 00       	call   80107250 <switchuvm>
  if (curproc->mthread->tno == 1)
80100dd2:	8b 96 88 00 00 00    	mov    0x88(%esi),%edx
80100dd8:	83 c4 10             	add    $0x10,%esp
  return 0;
80100ddb:	31 c0                	xor    %eax,%eax
  if (curproc->mthread->tno == 1)
80100ddd:	83 7a 7c 01          	cmpl   $0x1,0x7c(%edx)
80100de1:	0f 85 35 fd ff ff    	jne    80100b1c <exec+0x6c>
    freevm(oldpgdir);
80100de7:	83 ec 0c             	sub    $0xc,%esp
80100dea:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100df0:	53                   	push   %ebx
80100df1:	e8 3a 68 00 00       	call   80107630 <freevm>
80100df6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100dfc:	83 c4 10             	add    $0x10,%esp
80100dff:	e9 18 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100e04:	e8 e7 1f 00 00       	call   80102df0 <end_op>
    cprintf("exec: fail\n");
80100e09:	83 ec 0c             	sub    $0xc,%esp
80100e0c:	68 81 7a 10 80       	push   $0x80107a81
80100e11:	e8 8a f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100e16:	83 c4 10             	add    $0x10,%esp
80100e19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e1e:	e9 f9 fc ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e23:	be 00 20 00 00       	mov    $0x2000,%esi
80100e28:	31 ff                	xor    %edi,%edi
80100e2a:	e9 19 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e2f:	90                   	nop

80100e30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e36:	68 8d 7a 10 80       	push   $0x80107a8d
80100e3b:	68 60 ff 10 80       	push   $0x8010ff60
80100e40:	e8 fb 3b 00 00       	call   80104a40 <initlock>
}
80100e45:	83 c4 10             	add    $0x10,%esp
80100e48:	c9                   	leave  
80100e49:	c3                   	ret    
80100e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e54:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e5c:	68 60 ff 10 80       	push   $0x8010ff60
80100e61:	e8 aa 3d 00 00       	call   80104c10 <acquire>
80100e66:	83 c4 10             	add    $0x10,%esp
80100e69:	eb 10                	jmp    80100e7b <filealloc+0x2b>
80100e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e6f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e70:	83 c3 18             	add    $0x18,%ebx
80100e73:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e79:	74 25                	je     80100ea0 <filealloc+0x50>
    if(f->ref == 0){
80100e7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e7e:	85 c0                	test   %eax,%eax
80100e80:	75 ee                	jne    80100e70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e8c:	68 60 ff 10 80       	push   $0x8010ff60
80100e91:	e8 1a 3d 00 00       	call   80104bb0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e96:	89 d8                	mov    %ebx,%eax
      return f;
80100e98:	83 c4 10             	add    $0x10,%esp
}
80100e9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e9e:	c9                   	leave  
80100e9f:	c3                   	ret    
  release(&ftable.lock);
80100ea0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ea3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ea5:	68 60 ff 10 80       	push   $0x8010ff60
80100eaa:	e8 01 3d 00 00       	call   80104bb0 <release>
}
80100eaf:	89 d8                	mov    %ebx,%eax
  return 0;
80100eb1:	83 c4 10             	add    $0x10,%esp
}
80100eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb7:	c9                   	leave  
80100eb8:	c3                   	ret    
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 10             	sub    $0x10,%esp
80100ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eca:	68 60 ff 10 80       	push   $0x8010ff60
80100ecf:	e8 3c 3d 00 00       	call   80104c10 <acquire>
  if(f->ref < 1)
80100ed4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed7:	83 c4 10             	add    $0x10,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	7e 1a                	jle    80100ef8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ede:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ee1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ee4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ee7:	68 60 ff 10 80       	push   $0x8010ff60
80100eec:	e8 bf 3c 00 00       	call   80104bb0 <release>
  return f;
}
80100ef1:	89 d8                	mov    %ebx,%eax
80100ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef6:	c9                   	leave  
80100ef7:	c3                   	ret    
    panic("filedup");
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	68 94 7a 10 80       	push   $0x80107a94
80100f00:	e8 7b f4 ff ff       	call   80100380 <panic>
80100f05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	57                   	push   %edi
80100f14:	56                   	push   %esi
80100f15:	53                   	push   %ebx
80100f16:	83 ec 28             	sub    $0x28,%esp
80100f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f1c:	68 60 ff 10 80       	push   $0x8010ff60
80100f21:	e8 ea 3c 00 00       	call   80104c10 <acquire>
  if(f->ref < 1)
80100f26:	8b 53 04             	mov    0x4(%ebx),%edx
80100f29:	83 c4 10             	add    $0x10,%esp
80100f2c:	85 d2                	test   %edx,%edx
80100f2e:	0f 8e a5 00 00 00    	jle    80100fd9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f34:	83 ea 01             	sub    $0x1,%edx
80100f37:	89 53 04             	mov    %edx,0x4(%ebx)
80100f3a:	75 44                	jne    80100f80 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f3c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f40:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f43:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f45:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f4b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f4e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f51:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f54:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f59:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f5c:	e8 4f 3c 00 00       	call   80104bb0 <release>

  if(ff.type == FD_PIPE)
80100f61:	83 c4 10             	add    $0x10,%esp
80100f64:	83 ff 01             	cmp    $0x1,%edi
80100f67:	74 57                	je     80100fc0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f69:	83 ff 02             	cmp    $0x2,%edi
80100f6c:	74 2a                	je     80100f98 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f71:	5b                   	pop    %ebx
80100f72:	5e                   	pop    %esi
80100f73:	5f                   	pop    %edi
80100f74:	5d                   	pop    %ebp
80100f75:	c3                   	ret    
80100f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f7d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f80:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8a:	5b                   	pop    %ebx
80100f8b:	5e                   	pop    %esi
80100f8c:	5f                   	pop    %edi
80100f8d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f8e:	e9 1d 3c 00 00       	jmp    80104bb0 <release>
80100f93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f97:	90                   	nop
    begin_op();
80100f98:	e8 e3 1d 00 00       	call   80102d80 <begin_op>
    iput(ff.ip);
80100f9d:	83 ec 0c             	sub    $0xc,%esp
80100fa0:	ff 75 e0             	push   -0x20(%ebp)
80100fa3:	e8 28 09 00 00       	call   801018d0 <iput>
    end_op();
80100fa8:	83 c4 10             	add    $0x10,%esp
}
80100fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fae:	5b                   	pop    %ebx
80100faf:	5e                   	pop    %esi
80100fb0:	5f                   	pop    %edi
80100fb1:	5d                   	pop    %ebp
    end_op();
80100fb2:	e9 39 1e 00 00       	jmp    80102df0 <end_op>
80100fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fbe:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fc0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fc4:	83 ec 08             	sub    $0x8,%esp
80100fc7:	53                   	push   %ebx
80100fc8:	56                   	push   %esi
80100fc9:	e8 82 25 00 00       	call   80103550 <pipeclose>
80100fce:	83 c4 10             	add    $0x10,%esp
}
80100fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd4:	5b                   	pop    %ebx
80100fd5:	5e                   	pop    %esi
80100fd6:	5f                   	pop    %edi
80100fd7:	5d                   	pop    %ebp
80100fd8:	c3                   	ret    
    panic("fileclose");
80100fd9:	83 ec 0c             	sub    $0xc,%esp
80100fdc:	68 9c 7a 10 80       	push   $0x80107a9c
80100fe1:	e8 9a f3 ff ff       	call   80100380 <panic>
80100fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fed:	8d 76 00             	lea    0x0(%esi),%esi

80100ff0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	53                   	push   %ebx
80100ff4:	83 ec 04             	sub    $0x4,%esp
80100ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100ffa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ffd:	75 31                	jne    80101030 <filestat+0x40>
    ilock(f->ip);
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	ff 73 10             	push   0x10(%ebx)
80101005:	e8 96 07 00 00       	call   801017a0 <ilock>
    stati(f->ip, st);
8010100a:	58                   	pop    %eax
8010100b:	5a                   	pop    %edx
8010100c:	ff 75 0c             	push   0xc(%ebp)
8010100f:	ff 73 10             	push   0x10(%ebx)
80101012:	e8 69 0a 00 00       	call   80101a80 <stati>
    iunlock(f->ip);
80101017:	59                   	pop    %ecx
80101018:	ff 73 10             	push   0x10(%ebx)
8010101b:	e8 60 08 00 00       	call   80101880 <iunlock>
    return 0;
  }
  return -1;
}
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101023:	83 c4 10             	add    $0x10,%esp
80101026:	31 c0                	xor    %eax,%eax
}
80101028:	c9                   	leave  
80101029:	c3                   	ret    
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101030:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101038:	c9                   	leave  
80101039:	c3                   	ret    
8010103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101040 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	83 ec 0c             	sub    $0xc,%esp
80101049:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010104c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010104f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101052:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101056:	74 60                	je     801010b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101058:	8b 03                	mov    (%ebx),%eax
8010105a:	83 f8 01             	cmp    $0x1,%eax
8010105d:	74 41                	je     801010a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010105f:	83 f8 02             	cmp    $0x2,%eax
80101062:	75 5b                	jne    801010bf <fileread+0x7f>
    ilock(f->ip);
80101064:	83 ec 0c             	sub    $0xc,%esp
80101067:	ff 73 10             	push   0x10(%ebx)
8010106a:	e8 31 07 00 00       	call   801017a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010106f:	57                   	push   %edi
80101070:	ff 73 14             	push   0x14(%ebx)
80101073:	56                   	push   %esi
80101074:	ff 73 10             	push   0x10(%ebx)
80101077:	e8 34 0a 00 00       	call   80101ab0 <readi>
8010107c:	83 c4 20             	add    $0x20,%esp
8010107f:	89 c6                	mov    %eax,%esi
80101081:	85 c0                	test   %eax,%eax
80101083:	7e 03                	jle    80101088 <fileread+0x48>
      f->off += r;
80101085:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101088:	83 ec 0c             	sub    $0xc,%esp
8010108b:	ff 73 10             	push   0x10(%ebx)
8010108e:	e8 ed 07 00 00       	call   80101880 <iunlock>
    return r;
80101093:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	89 f0                	mov    %esi,%eax
8010109b:	5b                   	pop    %ebx
8010109c:	5e                   	pop    %esi
8010109d:	5f                   	pop    %edi
8010109e:	5d                   	pop    %ebp
8010109f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801010a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a9:	5b                   	pop    %ebx
801010aa:	5e                   	pop    %esi
801010ab:	5f                   	pop    %edi
801010ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010ad:	e9 3e 26 00 00       	jmp    801036f0 <piperead>
801010b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010bd:	eb d7                	jmp    80101096 <fileread+0x56>
  panic("fileread");
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	68 a6 7a 10 80       	push   $0x80107aa6
801010c7:	e8 b4 f2 ff ff       	call   80100380 <panic>
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	56                   	push   %esi
801010d5:	53                   	push   %ebx
801010d6:	83 ec 1c             	sub    $0x1c,%esp
801010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010e2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010e5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010ec:	0f 84 bd 00 00 00    	je     801011af <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010f2:	8b 03                	mov    (%ebx),%eax
801010f4:	83 f8 01             	cmp    $0x1,%eax
801010f7:	0f 84 bf 00 00 00    	je     801011bc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010fd:	83 f8 02             	cmp    $0x2,%eax
80101100:	0f 85 c8 00 00 00    	jne    801011ce <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101109:	31 f6                	xor    %esi,%esi
    while(i < n){
8010110b:	85 c0                	test   %eax,%eax
8010110d:	7f 30                	jg     8010113f <filewrite+0x6f>
8010110f:	e9 94 00 00 00       	jmp    801011a8 <filewrite+0xd8>
80101114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101118:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010111b:	83 ec 0c             	sub    $0xc,%esp
8010111e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101121:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101124:	e8 57 07 00 00       	call   80101880 <iunlock>
      end_op();
80101129:	e8 c2 1c 00 00       	call   80102df0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010112e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101131:	83 c4 10             	add    $0x10,%esp
80101134:	39 c7                	cmp    %eax,%edi
80101136:	75 5c                	jne    80101194 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101138:	01 fe                	add    %edi,%esi
    while(i < n){
8010113a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010113d:	7e 69                	jle    801011a8 <filewrite+0xd8>
      int n1 = n - i;
8010113f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101142:	b8 00 06 00 00       	mov    $0x600,%eax
80101147:	29 f7                	sub    %esi,%edi
80101149:	39 c7                	cmp    %eax,%edi
8010114b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010114e:	e8 2d 1c 00 00       	call   80102d80 <begin_op>
      ilock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 73 10             	push   0x10(%ebx)
80101159:	e8 42 06 00 00       	call   801017a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010115e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101161:	57                   	push   %edi
80101162:	ff 73 14             	push   0x14(%ebx)
80101165:	01 f0                	add    %esi,%eax
80101167:	50                   	push   %eax
80101168:	ff 73 10             	push   0x10(%ebx)
8010116b:	e8 40 0a 00 00       	call   80101bb0 <writei>
80101170:	83 c4 20             	add    $0x20,%esp
80101173:	85 c0                	test   %eax,%eax
80101175:	7f a1                	jg     80101118 <filewrite+0x48>
      iunlock(f->ip);
80101177:	83 ec 0c             	sub    $0xc,%esp
8010117a:	ff 73 10             	push   0x10(%ebx)
8010117d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101180:	e8 fb 06 00 00       	call   80101880 <iunlock>
      end_op();
80101185:	e8 66 1c 00 00       	call   80102df0 <end_op>
      if(r < 0)
8010118a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010118d:	83 c4 10             	add    $0x10,%esp
80101190:	85 c0                	test   %eax,%eax
80101192:	75 1b                	jne    801011af <filewrite+0xdf>
        panic("short filewrite");
80101194:	83 ec 0c             	sub    $0xc,%esp
80101197:	68 af 7a 10 80       	push   $0x80107aaf
8010119c:	e8 df f1 ff ff       	call   80100380 <panic>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011a8:	89 f0                	mov    %esi,%eax
801011aa:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801011ad:	74 05                	je     801011b4 <filewrite+0xe4>
801011af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b7:	5b                   	pop    %ebx
801011b8:	5e                   	pop    %esi
801011b9:	5f                   	pop    %edi
801011ba:	5d                   	pop    %ebp
801011bb:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011bc:	8b 43 0c             	mov    0xc(%ebx),%eax
801011bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011c5:	5b                   	pop    %ebx
801011c6:	5e                   	pop    %esi
801011c7:	5f                   	pop    %edi
801011c8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011c9:	e9 22 24 00 00       	jmp    801035f0 <pipewrite>
  panic("filewrite");
801011ce:	83 ec 0c             	sub    $0xc,%esp
801011d1:	68 b5 7a 10 80       	push   $0x80107ab5
801011d6:	e8 a5 f1 ff ff       	call   80100380 <panic>
801011db:	66 90                	xchg   %ax,%ax
801011dd:	66 90                	xchg   %ax,%ax
801011df:	90                   	nop

801011e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011e0:	55                   	push   %ebp
801011e1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011e3:	89 d0                	mov    %edx,%eax
801011e5:	c1 e8 0c             	shr    $0xc,%eax
801011e8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011ee:	89 e5                	mov    %esp,%ebp
801011f0:	56                   	push   %esi
801011f1:	53                   	push   %ebx
801011f2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011f4:	83 ec 08             	sub    $0x8,%esp
801011f7:	50                   	push   %eax
801011f8:	51                   	push   %ecx
801011f9:	e8 d2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011fe:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101200:	c1 fb 03             	sar    $0x3,%ebx
80101203:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101206:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101208:	83 e1 07             	and    $0x7,%ecx
8010120b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101210:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101216:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101218:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010121d:	85 c1                	test   %eax,%ecx
8010121f:	74 23                	je     80101244 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101221:	f7 d0                	not    %eax
  log_write(bp);
80101223:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101226:	21 c8                	and    %ecx,%eax
80101228:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010122c:	56                   	push   %esi
8010122d:	e8 2e 1d 00 00       	call   80102f60 <log_write>
  brelse(bp);
80101232:	89 34 24             	mov    %esi,(%esp)
80101235:	e8 b6 ef ff ff       	call   801001f0 <brelse>
}
8010123a:	83 c4 10             	add    $0x10,%esp
8010123d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101240:	5b                   	pop    %ebx
80101241:	5e                   	pop    %esi
80101242:	5d                   	pop    %ebp
80101243:	c3                   	ret    
    panic("freeing free block");
80101244:	83 ec 0c             	sub    $0xc,%esp
80101247:	68 bf 7a 10 80       	push   $0x80107abf
8010124c:	e8 2f f1 ff ff       	call   80100380 <panic>
80101251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010125f:	90                   	nop

80101260 <balloc>:
{
80101260:	55                   	push   %ebp
80101261:	89 e5                	mov    %esp,%ebp
80101263:	57                   	push   %edi
80101264:	56                   	push   %esi
80101265:	53                   	push   %ebx
80101266:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101269:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010126f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101272:	85 c9                	test   %ecx,%ecx
80101274:	0f 84 87 00 00 00    	je     80101301 <balloc+0xa1>
8010127a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101281:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101284:	83 ec 08             	sub    $0x8,%esp
80101287:	89 f0                	mov    %esi,%eax
80101289:	c1 f8 0c             	sar    $0xc,%eax
8010128c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101292:	50                   	push   %eax
80101293:	ff 75 d8             	push   -0x28(%ebp)
80101296:	e8 35 ee ff ff       	call   801000d0 <bread>
8010129b:	83 c4 10             	add    $0x10,%esp
8010129e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012a1:	a1 b4 25 11 80       	mov    0x801125b4,%eax
801012a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012a9:	31 c0                	xor    %eax,%eax
801012ab:	eb 2f                	jmp    801012dc <balloc+0x7c>
801012ad:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012b0:	89 c1                	mov    %eax,%ecx
801012b2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012ba:	83 e1 07             	and    $0x7,%ecx
801012bd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012bf:	89 c1                	mov    %eax,%ecx
801012c1:	c1 f9 03             	sar    $0x3,%ecx
801012c4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012c9:	89 fa                	mov    %edi,%edx
801012cb:	85 df                	test   %ebx,%edi
801012cd:	74 41                	je     80101310 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012cf:	83 c0 01             	add    $0x1,%eax
801012d2:	83 c6 01             	add    $0x1,%esi
801012d5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012da:	74 05                	je     801012e1 <balloc+0x81>
801012dc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012df:	77 cf                	ja     801012b0 <balloc+0x50>
    brelse(bp);
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	ff 75 e4             	push   -0x1c(%ebp)
801012e7:	e8 04 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012ec:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012f3:	83 c4 10             	add    $0x10,%esp
801012f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012f9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012ff:	77 80                	ja     80101281 <balloc+0x21>
  panic("balloc: out of blocks");
80101301:	83 ec 0c             	sub    $0xc,%esp
80101304:	68 d2 7a 10 80       	push   $0x80107ad2
80101309:	e8 72 f0 ff ff       	call   80100380 <panic>
8010130e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101310:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101313:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101316:	09 da                	or     %ebx,%edx
80101318:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010131c:	57                   	push   %edi
8010131d:	e8 3e 1c 00 00       	call   80102f60 <log_write>
        brelse(bp);
80101322:	89 3c 24             	mov    %edi,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010132a:	58                   	pop    %eax
8010132b:	5a                   	pop    %edx
8010132c:	56                   	push   %esi
8010132d:	ff 75 d8             	push   -0x28(%ebp)
80101330:	e8 9b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101335:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101338:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010133a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010133d:	68 00 02 00 00       	push   $0x200
80101342:	6a 00                	push   $0x0
80101344:	50                   	push   %eax
80101345:	e8 86 39 00 00       	call   80104cd0 <memset>
  log_write(bp);
8010134a:	89 1c 24             	mov    %ebx,(%esp)
8010134d:	e8 0e 1c 00 00       	call   80102f60 <log_write>
  brelse(bp);
80101352:	89 1c 24             	mov    %ebx,(%esp)
80101355:	e8 96 ee ff ff       	call   801001f0 <brelse>
}
8010135a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135d:	89 f0                	mov    %esi,%eax
8010135f:	5b                   	pop    %ebx
80101360:	5e                   	pop    %esi
80101361:	5f                   	pop    %edi
80101362:	5d                   	pop    %ebp
80101363:	c3                   	ret    
80101364:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010136f:	90                   	nop

80101370 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	57                   	push   %edi
80101374:	89 c7                	mov    %eax,%edi
80101376:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101377:	31 f6                	xor    %esi,%esi
{
80101379:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010137f:	83 ec 28             	sub    $0x28,%esp
80101382:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101385:	68 60 09 11 80       	push   $0x80110960
8010138a:	e8 81 38 00 00       	call   80104c10 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101392:	83 c4 10             	add    $0x10,%esp
80101395:	eb 1b                	jmp    801013b2 <iget+0x42>
80101397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010139e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a0:	39 3b                	cmp    %edi,(%ebx)
801013a2:	74 6c                	je     80101410 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013aa:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013b0:	73 26                	jae    801013d8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013b2:	8b 43 08             	mov    0x8(%ebx),%eax
801013b5:	85 c0                	test   %eax,%eax
801013b7:	7f e7                	jg     801013a0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013b9:	85 f6                	test   %esi,%esi
801013bb:	75 e7                	jne    801013a4 <iget+0x34>
801013bd:	85 c0                	test   %eax,%eax
801013bf:	75 76                	jne    80101437 <iget+0xc7>
801013c1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013c3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013c9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013cf:	72 e1                	jb     801013b2 <iget+0x42>
801013d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013d8:	85 f6                	test   %esi,%esi
801013da:	74 79                	je     80101455 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013dc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013df:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013e1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013e4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013eb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013f2:	68 60 09 11 80       	push   $0x80110960
801013f7:	e8 b4 37 00 00       	call   80104bb0 <release>

  return ip;
801013fc:	83 c4 10             	add    $0x10,%esp
}
801013ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101402:	89 f0                	mov    %esi,%eax
80101404:	5b                   	pop    %ebx
80101405:	5e                   	pop    %esi
80101406:	5f                   	pop    %edi
80101407:	5d                   	pop    %ebp
80101408:	c3                   	ret    
80101409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101410:	39 53 04             	cmp    %edx,0x4(%ebx)
80101413:	75 8f                	jne    801013a4 <iget+0x34>
      release(&icache.lock);
80101415:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101418:	83 c0 01             	add    $0x1,%eax
      return ip;
8010141b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010141d:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101422:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101425:	e8 86 37 00 00       	call   80104bb0 <release>
      return ip;
8010142a:	83 c4 10             	add    $0x10,%esp
}
8010142d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101430:	89 f0                	mov    %esi,%eax
80101432:	5b                   	pop    %ebx
80101433:	5e                   	pop    %esi
80101434:	5f                   	pop    %edi
80101435:	5d                   	pop    %ebp
80101436:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101437:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010143d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101443:	73 10                	jae    80101455 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101445:	8b 43 08             	mov    0x8(%ebx),%eax
80101448:	85 c0                	test   %eax,%eax
8010144a:	0f 8f 50 ff ff ff    	jg     801013a0 <iget+0x30>
80101450:	e9 68 ff ff ff       	jmp    801013bd <iget+0x4d>
    panic("iget: no inodes");
80101455:	83 ec 0c             	sub    $0xc,%esp
80101458:	68 e8 7a 10 80       	push   $0x80107ae8
8010145d:	e8 1e ef ff ff       	call   80100380 <panic>
80101462:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101470 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	89 c6                	mov    %eax,%esi
80101477:	53                   	push   %ebx
80101478:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010147b:	83 fa 0b             	cmp    $0xb,%edx
8010147e:	0f 86 8c 00 00 00    	jbe    80101510 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101484:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101487:	83 fb 7f             	cmp    $0x7f,%ebx
8010148a:	0f 87 a2 00 00 00    	ja     80101532 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101490:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101496:	85 c0                	test   %eax,%eax
80101498:	74 5e                	je     801014f8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010149a:	83 ec 08             	sub    $0x8,%esp
8010149d:	50                   	push   %eax
8010149e:	ff 36                	push   (%esi)
801014a0:	e8 2b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014a5:	83 c4 10             	add    $0x10,%esp
801014a8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014ac:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014ae:	8b 3b                	mov    (%ebx),%edi
801014b0:	85 ff                	test   %edi,%edi
801014b2:	74 1c                	je     801014d0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014b4:	83 ec 0c             	sub    $0xc,%esp
801014b7:	52                   	push   %edx
801014b8:	e8 33 ed ff ff       	call   801001f0 <brelse>
801014bd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c3:	89 f8                	mov    %edi,%eax
801014c5:	5b                   	pop    %ebx
801014c6:	5e                   	pop    %esi
801014c7:	5f                   	pop    %edi
801014c8:	5d                   	pop    %ebp
801014c9:	c3                   	ret    
801014ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014d3:	8b 06                	mov    (%esi),%eax
801014d5:	e8 86 fd ff ff       	call   80101260 <balloc>
      log_write(bp);
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014e0:	89 03                	mov    %eax,(%ebx)
801014e2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014e4:	52                   	push   %edx
801014e5:	e8 76 1a 00 00       	call   80102f60 <log_write>
801014ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014ed:	83 c4 10             	add    $0x10,%esp
801014f0:	eb c2                	jmp    801014b4 <bmap+0x44>
801014f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014f8:	8b 06                	mov    (%esi),%eax
801014fa:	e8 61 fd ff ff       	call   80101260 <balloc>
801014ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101505:	eb 93                	jmp    8010149a <bmap+0x2a>
80101507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101510:	8d 5a 14             	lea    0x14(%edx),%ebx
80101513:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101517:	85 ff                	test   %edi,%edi
80101519:	75 a5                	jne    801014c0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010151b:	8b 00                	mov    (%eax),%eax
8010151d:	e8 3e fd ff ff       	call   80101260 <balloc>
80101522:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101526:	89 c7                	mov    %eax,%edi
}
80101528:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010152b:	5b                   	pop    %ebx
8010152c:	89 f8                	mov    %edi,%eax
8010152e:	5e                   	pop    %esi
8010152f:	5f                   	pop    %edi
80101530:	5d                   	pop    %ebp
80101531:	c3                   	ret    
  panic("bmap: out of range");
80101532:	83 ec 0c             	sub    $0xc,%esp
80101535:	68 f8 7a 10 80       	push   $0x80107af8
8010153a:	e8 41 ee ff ff       	call   80100380 <panic>
8010153f:	90                   	nop

80101540 <readsb>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101548:	83 ec 08             	sub    $0x8,%esp
8010154b:	6a 01                	push   $0x1
8010154d:	ff 75 08             	push   0x8(%ebp)
80101550:	e8 7b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101555:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101558:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010155a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010155d:	6a 1c                	push   $0x1c
8010155f:	50                   	push   %eax
80101560:	56                   	push   %esi
80101561:	e8 0a 38 00 00       	call   80104d70 <memmove>
  brelse(bp);
80101566:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101569:	83 c4 10             	add    $0x10,%esp
}
8010156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5d                   	pop    %ebp
  brelse(bp);
80101572:	e9 79 ec ff ff       	jmp    801001f0 <brelse>
80101577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010157e:	66 90                	xchg   %ax,%ax

80101580 <iinit>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	53                   	push   %ebx
80101584:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101589:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010158c:	68 0b 7b 10 80       	push   $0x80107b0b
80101591:	68 60 09 11 80       	push   $0x80110960
80101596:	e8 a5 34 00 00       	call   80104a40 <initlock>
  for(i = 0; i < NINODE; i++) {
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015a0:	83 ec 08             	sub    $0x8,%esp
801015a3:	68 12 7b 10 80       	push   $0x80107b12
801015a8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015af:	e8 5c 33 00 00       	call   80104910 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015b4:	83 c4 10             	add    $0x10,%esp
801015b7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801015bd:	75 e1                	jne    801015a0 <iinit+0x20>
  bp = bread(dev, 1);
801015bf:	83 ec 08             	sub    $0x8,%esp
801015c2:	6a 01                	push   $0x1
801015c4:	ff 75 08             	push   0x8(%ebp)
801015c7:	e8 04 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015cc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015cf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015d1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015d4:	6a 1c                	push   $0x1c
801015d6:	50                   	push   %eax
801015d7:	68 b4 25 11 80       	push   $0x801125b4
801015dc:	e8 8f 37 00 00       	call   80104d70 <memmove>
  brelse(bp);
801015e1:	89 1c 24             	mov    %ebx,(%esp)
801015e4:	e8 07 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015e9:	ff 35 cc 25 11 80    	push   0x801125cc
801015ef:	ff 35 c8 25 11 80    	push   0x801125c8
801015f5:	ff 35 c4 25 11 80    	push   0x801125c4
801015fb:	ff 35 c0 25 11 80    	push   0x801125c0
80101601:	ff 35 bc 25 11 80    	push   0x801125bc
80101607:	ff 35 b8 25 11 80    	push   0x801125b8
8010160d:	ff 35 b4 25 11 80    	push   0x801125b4
80101613:	68 78 7b 10 80       	push   $0x80107b78
80101618:	e8 83 f0 ff ff       	call   801006a0 <cprintf>
}
8010161d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101620:	83 c4 30             	add    $0x30,%esp
80101623:	c9                   	leave  
80101624:	c3                   	ret    
80101625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010162c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101630 <ialloc>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	83 ec 1c             	sub    $0x1c,%esp
80101639:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101643:	8b 75 08             	mov    0x8(%ebp),%esi
80101646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	0f 86 91 00 00 00    	jbe    801016e0 <ialloc+0xb0>
8010164f:	bf 01 00 00 00       	mov    $0x1,%edi
80101654:	eb 21                	jmp    80101677 <ialloc+0x47>
80101656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010165d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101660:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101663:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101666:	53                   	push   %ebx
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101675:	73 69                	jae    801016e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101677:	89 f8                	mov    %edi,%eax
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	c1 e8 03             	shr    $0x3,%eax
8010167f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101685:	50                   	push   %eax
80101686:	56                   	push   %esi
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010168c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010168f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101691:	89 f8                	mov    %edi,%eax
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010169d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016a1:	75 bd                	jne    80101660 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016a3:	83 ec 04             	sub    $0x4,%esp
801016a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016a9:	6a 40                	push   $0x40
801016ab:	6a 00                	push   $0x0
801016ad:	51                   	push   %ecx
801016ae:	e8 1d 36 00 00       	call   80104cd0 <memset>
      dip->type = type;
801016b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016bd:	89 1c 24             	mov    %ebx,(%esp)
801016c0:	e8 9b 18 00 00       	call   80102f60 <log_write>
      brelse(bp);
801016c5:	89 1c 24             	mov    %ebx,(%esp)
801016c8:	e8 23 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016cd:	83 c4 10             	add    $0x10,%esp
}
801016d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016d3:	89 fa                	mov    %edi,%edx
}
801016d5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016d6:	89 f0                	mov    %esi,%eax
}
801016d8:	5e                   	pop    %esi
801016d9:	5f                   	pop    %edi
801016da:	5d                   	pop    %ebp
      return iget(dev, inum);
801016db:	e9 90 fc ff ff       	jmp    80101370 <iget>
  panic("ialloc: no inodes");
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	68 18 7b 10 80       	push   $0x80107b18
801016e8:	e8 93 ec ff ff       	call   80100380 <panic>
801016ed:	8d 76 00             	lea    0x0(%esi),%esi

801016f0 <iupdate>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fe:	83 ec 08             	sub    $0x8,%esp
80101701:	c1 e8 03             	shr    $0x3,%eax
80101704:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010170a:	50                   	push   %eax
8010170b:	ff 73 a4             	push   -0x5c(%ebx)
8010170e:	e8 bd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101713:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101717:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101729:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010172c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101730:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101733:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101737:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010173b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010173f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101743:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101747:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010174a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174d:	6a 34                	push   $0x34
8010174f:	53                   	push   %ebx
80101750:	50                   	push   %eax
80101751:	e8 1a 36 00 00       	call   80104d70 <memmove>
  log_write(bp);
80101756:	89 34 24             	mov    %esi,(%esp)
80101759:	e8 02 18 00 00       	call   80102f60 <log_write>
  brelse(bp);
8010175e:	89 75 08             	mov    %esi,0x8(%ebp)
80101761:	83 c4 10             	add    $0x10,%esp
}
80101764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101767:	5b                   	pop    %ebx
80101768:	5e                   	pop    %esi
80101769:	5d                   	pop    %ebp
  brelse(bp);
8010176a:	e9 81 ea ff ff       	jmp    801001f0 <brelse>
8010176f:	90                   	nop

80101770 <idup>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	53                   	push   %ebx
80101774:	83 ec 10             	sub    $0x10,%esp
80101777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010177a:	68 60 09 11 80       	push   $0x80110960
8010177f:	e8 8c 34 00 00       	call   80104c10 <acquire>
  ip->ref++;
80101784:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101788:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010178f:	e8 1c 34 00 00       	call   80104bb0 <release>
}
80101794:	89 d8                	mov    %ebx,%eax
80101796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101799:	c9                   	leave  
8010179a:	c3                   	ret    
8010179b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010179f:	90                   	nop

801017a0 <ilock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	0f 84 b7 00 00 00    	je     80101867 <ilock+0xc7>
801017b0:	8b 53 08             	mov    0x8(%ebx),%edx
801017b3:	85 d2                	test   %edx,%edx
801017b5:	0f 8e ac 00 00 00    	jle    80101867 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017bb:	83 ec 0c             	sub    $0xc,%esp
801017be:	8d 43 0c             	lea    0xc(%ebx),%eax
801017c1:	50                   	push   %eax
801017c2:	e8 89 31 00 00       	call   80104950 <acquiresleep>
  if(ip->valid == 0){
801017c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	85 c0                	test   %eax,%eax
801017cf:	74 0f                	je     801017e0 <ilock+0x40>
}
801017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d4:	5b                   	pop    %ebx
801017d5:	5e                   	pop    %esi
801017d6:	5d                   	pop    %ebp
801017d7:	c3                   	ret    
801017d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017df:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e0:	8b 43 04             	mov    0x4(%ebx),%eax
801017e3:	83 ec 08             	sub    $0x8,%esp
801017e6:	c1 e8 03             	shr    $0x3,%eax
801017e9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017ef:	50                   	push   %eax
801017f0:	ff 33                	push   (%ebx)
801017f2:	e8 d9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017fc:	8b 43 04             	mov    0x4(%ebx),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101809:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010180f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101813:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101817:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010181b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010181f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101823:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101827:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010182b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010182e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101831:	6a 34                	push   $0x34
80101833:	50                   	push   %eax
80101834:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101837:	50                   	push   %eax
80101838:	e8 33 35 00 00       	call   80104d70 <memmove>
    brelse(bp);
8010183d:	89 34 24             	mov    %esi,(%esp)
80101840:	e8 ab e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010184d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101854:	0f 85 77 ff ff ff    	jne    801017d1 <ilock+0x31>
      panic("ilock: no type");
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	68 30 7b 10 80       	push   $0x80107b30
80101862:	e8 19 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 2a 7b 10 80       	push   $0x80107b2a
8010186f:	e8 0c eb ff ff       	call   80100380 <panic>
80101874:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010187b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010187f:	90                   	nop

80101880 <iunlock>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	56                   	push   %esi
80101884:	53                   	push   %ebx
80101885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101888:	85 db                	test   %ebx,%ebx
8010188a:	74 28                	je     801018b4 <iunlock+0x34>
8010188c:	83 ec 0c             	sub    $0xc,%esp
8010188f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101892:	56                   	push   %esi
80101893:	e8 58 31 00 00       	call   801049f0 <holdingsleep>
80101898:	83 c4 10             	add    $0x10,%esp
8010189b:	85 c0                	test   %eax,%eax
8010189d:	74 15                	je     801018b4 <iunlock+0x34>
8010189f:	8b 43 08             	mov    0x8(%ebx),%eax
801018a2:	85 c0                	test   %eax,%eax
801018a4:	7e 0e                	jle    801018b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018af:	e9 fc 30 00 00       	jmp    801049b0 <releasesleep>
    panic("iunlock");
801018b4:	83 ec 0c             	sub    $0xc,%esp
801018b7:	68 3f 7b 10 80       	push   $0x80107b3f
801018bc:	e8 bf ea ff ff       	call   80100380 <panic>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cf:	90                   	nop

801018d0 <iput>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 28             	sub    $0x28,%esp
801018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018df:	57                   	push   %edi
801018e0:	e8 6b 30 00 00       	call   80104950 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 d2                	test   %edx,%edx
801018ed:	74 07                	je     801018f6 <iput+0x26>
801018ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018f4:	74 32                	je     80101928 <iput+0x58>
  releasesleep(&ip->lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	57                   	push   %edi
801018fa:	e8 b1 30 00 00       	call   801049b0 <releasesleep>
  acquire(&icache.lock);
801018ff:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101906:	e8 05 33 00 00       	call   80104c10 <acquire>
  ip->ref--;
8010190b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010190f:	83 c4 10             	add    $0x10,%esp
80101912:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5f                   	pop    %edi
8010191f:	5d                   	pop    %ebp
  release(&icache.lock);
80101920:	e9 8b 32 00 00       	jmp    80104bb0 <release>
80101925:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101928:	83 ec 0c             	sub    $0xc,%esp
8010192b:	68 60 09 11 80       	push   $0x80110960
80101930:	e8 db 32 00 00       	call   80104c10 <acquire>
    int r = ip->ref;
80101935:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101938:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010193f:	e8 6c 32 00 00       	call   80104bb0 <release>
    if(r == 1){
80101944:	83 c4 10             	add    $0x10,%esp
80101947:	83 fe 01             	cmp    $0x1,%esi
8010194a:	75 aa                	jne    801018f6 <iput+0x26>
8010194c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101952:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101955:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101958:	89 cf                	mov    %ecx,%edi
8010195a:	eb 0b                	jmp    80101967 <iput+0x97>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101960:	83 c6 04             	add    $0x4,%esi
80101963:	39 fe                	cmp    %edi,%esi
80101965:	74 19                	je     80101980 <iput+0xb0>
    if(ip->addrs[i]){
80101967:	8b 16                	mov    (%esi),%edx
80101969:	85 d2                	test   %edx,%edx
8010196b:	74 f3                	je     80101960 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010196d:	8b 03                	mov    (%ebx),%eax
8010196f:	e8 6c f8 ff ff       	call   801011e0 <bfree>
      ip->addrs[i] = 0;
80101974:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010197a:	eb e4                	jmp    80101960 <iput+0x90>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101980:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101986:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101989:	85 c0                	test   %eax,%eax
8010198b:	75 2d                	jne    801019ba <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010198d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101990:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101997:	53                   	push   %ebx
80101998:	e8 53 fd ff ff       	call   801016f0 <iupdate>
      ip->type = 0;
8010199d:	31 c0                	xor    %eax,%eax
8010199f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019a3:	89 1c 24             	mov    %ebx,(%esp)
801019a6:	e8 45 fd ff ff       	call   801016f0 <iupdate>
      ip->valid = 0;
801019ab:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019b2:	83 c4 10             	add    $0x10,%esp
801019b5:	e9 3c ff ff ff       	jmp    801018f6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019ba:	83 ec 08             	sub    $0x8,%esp
801019bd:	50                   	push   %eax
801019be:	ff 33                	push   (%ebx)
801019c0:	e8 0b e7 ff ff       	call   801000d0 <bread>
801019c5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019c8:	83 c4 10             	add    $0x10,%esp
801019cb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019d4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019d7:	89 cf                	mov    %ecx,%edi
801019d9:	eb 0c                	jmp    801019e7 <iput+0x117>
801019db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019df:	90                   	nop
801019e0:	83 c6 04             	add    $0x4,%esi
801019e3:	39 f7                	cmp    %esi,%edi
801019e5:	74 0f                	je     801019f6 <iput+0x126>
      if(a[j])
801019e7:	8b 16                	mov    (%esi),%edx
801019e9:	85 d2                	test   %edx,%edx
801019eb:	74 f3                	je     801019e0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019ed:	8b 03                	mov    (%ebx),%eax
801019ef:	e8 ec f7 ff ff       	call   801011e0 <bfree>
801019f4:	eb ea                	jmp    801019e0 <iput+0x110>
    brelse(bp);
801019f6:	83 ec 0c             	sub    $0xc,%esp
801019f9:	ff 75 e4             	push   -0x1c(%ebp)
801019fc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019ff:	e8 ec e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a04:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a0a:	8b 03                	mov    (%ebx),%eax
80101a0c:	e8 cf f7 ff ff       	call   801011e0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a11:	83 c4 10             	add    $0x10,%esp
80101a14:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a1b:	00 00 00 
80101a1e:	e9 6a ff ff ff       	jmp    8010198d <iput+0xbd>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <iunlockput>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a38:	85 db                	test   %ebx,%ebx
80101a3a:	74 34                	je     80101a70 <iunlockput+0x40>
80101a3c:	83 ec 0c             	sub    $0xc,%esp
80101a3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a42:	56                   	push   %esi
80101a43:	e8 a8 2f 00 00       	call   801049f0 <holdingsleep>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	74 21                	je     80101a70 <iunlockput+0x40>
80101a4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a52:	85 c0                	test   %eax,%eax
80101a54:	7e 1a                	jle    80101a70 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	56                   	push   %esi
80101a5a:	e8 51 2f 00 00       	call   801049b0 <releasesleep>
  iput(ip);
80101a5f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a62:	83 c4 10             	add    $0x10,%esp
}
80101a65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5d                   	pop    %ebp
  iput(ip);
80101a6b:	e9 60 fe ff ff       	jmp    801018d0 <iput>
    panic("iunlock");
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	68 3f 7b 10 80       	push   $0x80107b3f
80101a78:	e8 03 e9 ff ff       	call   80100380 <panic>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi

80101a80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	8b 55 08             	mov    0x8(%ebp),%edx
80101a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a89:	8b 0a                	mov    (%edx),%ecx
80101a8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101aa3:	8b 52 58             	mov    0x58(%edx),%edx
80101aa6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101aa9:	5d                   	pop    %ebp
80101aaa:	c3                   	ret    
80101aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aaf:	90                   	nop

80101ab0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
80101ab9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101abc:	8b 45 08             	mov    0x8(%ebp),%eax
80101abf:	8b 75 10             	mov    0x10(%ebp),%esi
80101ac2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ac5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101acd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ad0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ad3:	0f 84 a7 00 00 00    	je     80101b80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ad9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101adc:	8b 40 58             	mov    0x58(%eax),%eax
80101adf:	39 c6                	cmp    %eax,%esi
80101ae1:	0f 87 ba 00 00 00    	ja     80101ba1 <readi+0xf1>
80101ae7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aea:	31 c9                	xor    %ecx,%ecx
80101aec:	89 da                	mov    %ebx,%edx
80101aee:	01 f2                	add    %esi,%edx
80101af0:	0f 92 c1             	setb   %cl
80101af3:	89 cf                	mov    %ecx,%edi
80101af5:	0f 82 a6 00 00 00    	jb     80101ba1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101afb:	89 c1                	mov    %eax,%ecx
80101afd:	29 f1                	sub    %esi,%ecx
80101aff:	39 d0                	cmp    %edx,%eax
80101b01:	0f 43 cb             	cmovae %ebx,%ecx
80101b04:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b07:	85 c9                	test   %ecx,%ecx
80101b09:	74 67                	je     80101b72 <readi+0xc2>
80101b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b0f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b13:	89 f2                	mov    %esi,%edx
80101b15:	c1 ea 09             	shr    $0x9,%edx
80101b18:	89 d8                	mov    %ebx,%eax
80101b1a:	e8 51 f9 ff ff       	call   80101470 <bmap>
80101b1f:	83 ec 08             	sub    $0x8,%esp
80101b22:	50                   	push   %eax
80101b23:	ff 33                	push   (%ebx)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b32:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b34:	89 f0                	mov    %esi,%eax
80101b36:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b40:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b42:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b46:	39 d9                	cmp    %ebx,%ecx
80101b48:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b4b:	83 c4 0c             	add    $0xc,%esp
80101b4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4f:	01 df                	add    %ebx,%edi
80101b51:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b53:	50                   	push   %eax
80101b54:	ff 75 e0             	push   -0x20(%ebp)
80101b57:	e8 14 32 00 00       	call   80104d70 <memmove>
    brelse(bp);
80101b5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b5f:	89 14 24             	mov    %edx,(%esp)
80101b62:	e8 89 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b6a:	83 c4 10             	add    $0x10,%esp
80101b6d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b70:	77 9e                	ja     80101b10 <readi+0x60>
  }
  return n;
80101b72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b78:	5b                   	pop    %ebx
80101b79:	5e                   	pop    %esi
80101b7a:	5f                   	pop    %edi
80101b7b:	5d                   	pop    %ebp
80101b7c:	c3                   	ret    
80101b7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b84:	66 83 f8 09          	cmp    $0x9,%ax
80101b88:	77 17                	ja     80101ba1 <readi+0xf1>
80101b8a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b91:	85 c0                	test   %eax,%eax
80101b93:	74 0c                	je     80101ba1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b9f:	ff e0                	jmp    *%eax
      return -1;
80101ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba6:	eb cd                	jmp    80101b75 <readi+0xc5>
80101ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101baf:	90                   	nop

80101bb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bbf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bc7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bca:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bcd:	8b 75 10             	mov    0x10(%ebp),%esi
80101bd0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bd3:	0f 84 b7 00 00 00    	je     80101c90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bdc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bdf:	0f 87 e7 00 00 00    	ja     80101ccc <writei+0x11c>
80101be5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101be8:	31 d2                	xor    %edx,%edx
80101bea:	89 f8                	mov    %edi,%eax
80101bec:	01 f0                	add    %esi,%eax
80101bee:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bf1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bf6:	0f 87 d0 00 00 00    	ja     80101ccc <writei+0x11c>
80101bfc:	85 d2                	test   %edx,%edx
80101bfe:	0f 85 c8 00 00 00    	jne    80101ccc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c0b:	85 ff                	test   %edi,%edi
80101c0d:	74 72                	je     80101c81 <writei+0xd1>
80101c0f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c13:	89 f2                	mov    %esi,%edx
80101c15:	c1 ea 09             	shr    $0x9,%edx
80101c18:	89 f8                	mov    %edi,%eax
80101c1a:	e8 51 f8 ff ff       	call   80101470 <bmap>
80101c1f:	83 ec 08             	sub    $0x8,%esp
80101c22:	50                   	push   %eax
80101c23:	ff 37                	push   (%edi)
80101c25:	e8 a6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c2a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c2f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c32:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c35:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 f0                	mov    %esi,%eax
80101c39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c3e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c40:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c44:	39 d9                	cmp    %ebx,%ecx
80101c46:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c49:	83 c4 0c             	add    $0xc,%esp
80101c4c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c4f:	ff 75 dc             	push   -0x24(%ebp)
80101c52:	50                   	push   %eax
80101c53:	e8 18 31 00 00       	call   80104d70 <memmove>
    log_write(bp);
80101c58:	89 3c 24             	mov    %edi,(%esp)
80101c5b:	e8 00 13 00 00       	call   80102f60 <log_write>
    brelse(bp);
80101c60:	89 3c 24             	mov    %edi,(%esp)
80101c63:	e8 88 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c68:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c6b:	83 c4 10             	add    $0x10,%esp
80101c6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c71:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c74:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c77:	77 97                	ja     80101c10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c7c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c7f:	77 37                	ja     80101cb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c81:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c87:	5b                   	pop    %ebx
80101c88:	5e                   	pop    %esi
80101c89:	5f                   	pop    %edi
80101c8a:	5d                   	pop    %ebp
80101c8b:	c3                   	ret    
80101c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 32                	ja     80101ccc <writei+0x11c>
80101c9a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 27                	je     80101ccc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101ca5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101caf:	ff e0                	jmp    *%eax
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101cb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cbb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cbe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cc1:	50                   	push   %eax
80101cc2:	e8 29 fa ff ff       	call   801016f0 <iupdate>
80101cc7:	83 c4 10             	add    $0x10,%esp
80101cca:	eb b5                	jmp    80101c81 <writei+0xd1>
      return -1;
80101ccc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cd1:	eb b1                	jmp    80101c84 <writei+0xd4>
80101cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ce0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ce6:	6a 0e                	push   $0xe
80101ce8:	ff 75 0c             	push   0xc(%ebp)
80101ceb:	ff 75 08             	push   0x8(%ebp)
80101cee:	e8 ed 30 00 00       	call   80104de0 <strncmp>
}
80101cf3:	c9                   	leave  
80101cf4:	c3                   	ret    
80101cf5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d00 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	83 ec 1c             	sub    $0x1c,%esp
80101d09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d0c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d11:	0f 85 85 00 00 00    	jne    80101d9c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d17:	8b 53 58             	mov    0x58(%ebx),%edx
80101d1a:	31 ff                	xor    %edi,%edi
80101d1c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d1f:	85 d2                	test   %edx,%edx
80101d21:	74 3e                	je     80101d61 <dirlookup+0x61>
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d28:	6a 10                	push   $0x10
80101d2a:	57                   	push   %edi
80101d2b:	56                   	push   %esi
80101d2c:	53                   	push   %ebx
80101d2d:	e8 7e fd ff ff       	call   80101ab0 <readi>
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	83 f8 10             	cmp    $0x10,%eax
80101d38:	75 55                	jne    80101d8f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d3f:	74 18                	je     80101d59 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d41:	83 ec 04             	sub    $0x4,%esp
80101d44:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d47:	6a 0e                	push   $0xe
80101d49:	50                   	push   %eax
80101d4a:	ff 75 0c             	push   0xc(%ebp)
80101d4d:	e8 8e 30 00 00       	call   80104de0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d52:	83 c4 10             	add    $0x10,%esp
80101d55:	85 c0                	test   %eax,%eax
80101d57:	74 17                	je     80101d70 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d59:	83 c7 10             	add    $0x10,%edi
80101d5c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d5f:	72 c7                	jb     80101d28 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d64:	31 c0                	xor    %eax,%eax
}
80101d66:	5b                   	pop    %ebx
80101d67:	5e                   	pop    %esi
80101d68:	5f                   	pop    %edi
80101d69:	5d                   	pop    %ebp
80101d6a:	c3                   	ret    
80101d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop
      if(poff)
80101d70:	8b 45 10             	mov    0x10(%ebp),%eax
80101d73:	85 c0                	test   %eax,%eax
80101d75:	74 05                	je     80101d7c <dirlookup+0x7c>
        *poff = off;
80101d77:	8b 45 10             	mov    0x10(%ebp),%eax
80101d7a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d7c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d80:	8b 03                	mov    (%ebx),%eax
80101d82:	e8 e9 f5 ff ff       	call   80101370 <iget>
}
80101d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d8a:	5b                   	pop    %ebx
80101d8b:	5e                   	pop    %esi
80101d8c:	5f                   	pop    %edi
80101d8d:	5d                   	pop    %ebp
80101d8e:	c3                   	ret    
      panic("dirlookup read");
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	68 59 7b 10 80       	push   $0x80107b59
80101d97:	e8 e4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d9c:	83 ec 0c             	sub    $0xc,%esp
80101d9f:	68 47 7b 10 80       	push   $0x80107b47
80101da4:	e8 d7 e5 ff ff       	call   80100380 <panic>
80101da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101db0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	57                   	push   %edi
80101db4:	56                   	push   %esi
80101db5:	53                   	push   %ebx
80101db6:	89 c3                	mov    %eax,%ebx
80101db8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dbb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dbe:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dc1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101dc4:	0f 84 64 01 00 00    	je     80101f2e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dca:	e8 61 1c 00 00       	call   80103a30 <myproc>
  acquire(&icache.lock);
80101dcf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dd2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dd5:	68 60 09 11 80       	push   $0x80110960
80101dda:	e8 31 2e 00 00       	call   80104c10 <acquire>
  ip->ref++;
80101ddf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101de3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dea:	e8 c1 2d 00 00       	call   80104bb0 <release>
80101def:	83 c4 10             	add    $0x10,%esp
80101df2:	eb 07                	jmp    80101dfb <namex+0x4b>
80101df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101df8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101dfb:	0f b6 03             	movzbl (%ebx),%eax
80101dfe:	3c 2f                	cmp    $0x2f,%al
80101e00:	74 f6                	je     80101df8 <namex+0x48>
  if(*path == 0)
80101e02:	84 c0                	test   %al,%al
80101e04:	0f 84 06 01 00 00    	je     80101f10 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e0a:	0f b6 03             	movzbl (%ebx),%eax
80101e0d:	84 c0                	test   %al,%al
80101e0f:	0f 84 10 01 00 00    	je     80101f25 <namex+0x175>
80101e15:	89 df                	mov    %ebx,%edi
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	0f 84 06 01 00 00    	je     80101f25 <namex+0x175>
80101e1f:	90                   	nop
80101e20:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e24:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e27:	3c 2f                	cmp    $0x2f,%al
80101e29:	74 04                	je     80101e2f <namex+0x7f>
80101e2b:	84 c0                	test   %al,%al
80101e2d:	75 f1                	jne    80101e20 <namex+0x70>
  len = path - s;
80101e2f:	89 f8                	mov    %edi,%eax
80101e31:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e33:	83 f8 0d             	cmp    $0xd,%eax
80101e36:	0f 8e ac 00 00 00    	jle    80101ee8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e3c:	83 ec 04             	sub    $0x4,%esp
80101e3f:	6a 0e                	push   $0xe
80101e41:	53                   	push   %ebx
    path++;
80101e42:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e44:	ff 75 e4             	push   -0x1c(%ebp)
80101e47:	e8 24 2f 00 00       	call   80104d70 <memmove>
80101e4c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e4f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e52:	75 0c                	jne    80101e60 <namex+0xb0>
80101e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e58:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e5b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e5e:	74 f8                	je     80101e58 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e60:	83 ec 0c             	sub    $0xc,%esp
80101e63:	56                   	push   %esi
80101e64:	e8 37 f9 ff ff       	call   801017a0 <ilock>
    if(ip->type != T_DIR){
80101e69:	83 c4 10             	add    $0x10,%esp
80101e6c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e71:	0f 85 cd 00 00 00    	jne    80101f44 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e77:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	74 09                	je     80101e87 <namex+0xd7>
80101e7e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e81:	0f 84 22 01 00 00    	je     80101fa9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e87:	83 ec 04             	sub    $0x4,%esp
80101e8a:	6a 00                	push   $0x0
80101e8c:	ff 75 e4             	push   -0x1c(%ebp)
80101e8f:	56                   	push   %esi
80101e90:	e8 6b fe ff ff       	call   80101d00 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e95:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e98:	83 c4 10             	add    $0x10,%esp
80101e9b:	89 c7                	mov    %eax,%edi
80101e9d:	85 c0                	test   %eax,%eax
80101e9f:	0f 84 e1 00 00 00    	je     80101f86 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101eab:	52                   	push   %edx
80101eac:	e8 3f 2b 00 00       	call   801049f0 <holdingsleep>
80101eb1:	83 c4 10             	add    $0x10,%esp
80101eb4:	85 c0                	test   %eax,%eax
80101eb6:	0f 84 30 01 00 00    	je     80101fec <namex+0x23c>
80101ebc:	8b 56 08             	mov    0x8(%esi),%edx
80101ebf:	85 d2                	test   %edx,%edx
80101ec1:	0f 8e 25 01 00 00    	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101ec7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eca:	83 ec 0c             	sub    $0xc,%esp
80101ecd:	52                   	push   %edx
80101ece:	e8 dd 2a 00 00       	call   801049b0 <releasesleep>
  iput(ip);
80101ed3:	89 34 24             	mov    %esi,(%esp)
80101ed6:	89 fe                	mov    %edi,%esi
80101ed8:	e8 f3 f9 ff ff       	call   801018d0 <iput>
80101edd:	83 c4 10             	add    $0x10,%esp
80101ee0:	e9 16 ff ff ff       	jmp    80101dfb <namex+0x4b>
80101ee5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ee8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101eeb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101eee:	83 ec 04             	sub    $0x4,%esp
80101ef1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ef4:	50                   	push   %eax
80101ef5:	53                   	push   %ebx
    name[len] = 0;
80101ef6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ef8:	ff 75 e4             	push   -0x1c(%ebp)
80101efb:	e8 70 2e 00 00       	call   80104d70 <memmove>
    name[len] = 0;
80101f00:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f03:	83 c4 10             	add    $0x10,%esp
80101f06:	c6 02 00             	movb   $0x0,(%edx)
80101f09:	e9 41 ff ff ff       	jmp    80101e4f <namex+0x9f>
80101f0e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f10:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f13:	85 c0                	test   %eax,%eax
80101f15:	0f 85 be 00 00 00    	jne    80101fd9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f1e:	89 f0                	mov    %esi,%eax
80101f20:	5b                   	pop    %ebx
80101f21:	5e                   	pop    %esi
80101f22:	5f                   	pop    %edi
80101f23:	5d                   	pop    %ebp
80101f24:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f28:	89 df                	mov    %ebx,%edi
80101f2a:	31 c0                	xor    %eax,%eax
80101f2c:	eb c0                	jmp    80101eee <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f2e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f33:	b8 01 00 00 00       	mov    $0x1,%eax
80101f38:	e8 33 f4 ff ff       	call   80101370 <iget>
80101f3d:	89 c6                	mov    %eax,%esi
80101f3f:	e9 b7 fe ff ff       	jmp    80101dfb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f44:	83 ec 0c             	sub    $0xc,%esp
80101f47:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f4a:	53                   	push   %ebx
80101f4b:	e8 a0 2a 00 00       	call   801049f0 <holdingsleep>
80101f50:	83 c4 10             	add    $0x10,%esp
80101f53:	85 c0                	test   %eax,%eax
80101f55:	0f 84 91 00 00 00    	je     80101fec <namex+0x23c>
80101f5b:	8b 46 08             	mov    0x8(%esi),%eax
80101f5e:	85 c0                	test   %eax,%eax
80101f60:	0f 8e 86 00 00 00    	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	53                   	push   %ebx
80101f6a:	e8 41 2a 00 00       	call   801049b0 <releasesleep>
  iput(ip);
80101f6f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f72:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f74:	e8 57 f9 ff ff       	call   801018d0 <iput>
      return 0;
80101f79:	83 c4 10             	add    $0x10,%esp
}
80101f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f7f:	89 f0                	mov    %esi,%eax
80101f81:	5b                   	pop    %ebx
80101f82:	5e                   	pop    %esi
80101f83:	5f                   	pop    %edi
80101f84:	5d                   	pop    %ebp
80101f85:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f86:	83 ec 0c             	sub    $0xc,%esp
80101f89:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f8c:	52                   	push   %edx
80101f8d:	e8 5e 2a 00 00       	call   801049f0 <holdingsleep>
80101f92:	83 c4 10             	add    $0x10,%esp
80101f95:	85 c0                	test   %eax,%eax
80101f97:	74 53                	je     80101fec <namex+0x23c>
80101f99:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f9c:	85 c9                	test   %ecx,%ecx
80101f9e:	7e 4c                	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101fa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	52                   	push   %edx
80101fa7:	eb c1                	jmp    80101f6a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fa9:	83 ec 0c             	sub    $0xc,%esp
80101fac:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101faf:	53                   	push   %ebx
80101fb0:	e8 3b 2a 00 00       	call   801049f0 <holdingsleep>
80101fb5:	83 c4 10             	add    $0x10,%esp
80101fb8:	85 c0                	test   %eax,%eax
80101fba:	74 30                	je     80101fec <namex+0x23c>
80101fbc:	8b 7e 08             	mov    0x8(%esi),%edi
80101fbf:	85 ff                	test   %edi,%edi
80101fc1:	7e 29                	jle    80101fec <namex+0x23c>
  releasesleep(&ip->lock);
80101fc3:	83 ec 0c             	sub    $0xc,%esp
80101fc6:	53                   	push   %ebx
80101fc7:	e8 e4 29 00 00       	call   801049b0 <releasesleep>
}
80101fcc:	83 c4 10             	add    $0x10,%esp
}
80101fcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd2:	89 f0                	mov    %esi,%eax
80101fd4:	5b                   	pop    %ebx
80101fd5:	5e                   	pop    %esi
80101fd6:	5f                   	pop    %edi
80101fd7:	5d                   	pop    %ebp
80101fd8:	c3                   	ret    
    iput(ip);
80101fd9:	83 ec 0c             	sub    $0xc,%esp
80101fdc:	56                   	push   %esi
    return 0;
80101fdd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fdf:	e8 ec f8 ff ff       	call   801018d0 <iput>
    return 0;
80101fe4:	83 c4 10             	add    $0x10,%esp
80101fe7:	e9 2f ff ff ff       	jmp    80101f1b <namex+0x16b>
    panic("iunlock");
80101fec:	83 ec 0c             	sub    $0xc,%esp
80101fef:	68 3f 7b 10 80       	push   $0x80107b3f
80101ff4:	e8 87 e3 ff ff       	call   80100380 <panic>
80101ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102000 <dirlink>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	57                   	push   %edi
80102004:	56                   	push   %esi
80102005:	53                   	push   %ebx
80102006:	83 ec 20             	sub    $0x20,%esp
80102009:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010200c:	6a 00                	push   $0x0
8010200e:	ff 75 0c             	push   0xc(%ebp)
80102011:	53                   	push   %ebx
80102012:	e8 e9 fc ff ff       	call   80101d00 <dirlookup>
80102017:	83 c4 10             	add    $0x10,%esp
8010201a:	85 c0                	test   %eax,%eax
8010201c:	75 67                	jne    80102085 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010201e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102021:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102024:	85 ff                	test   %edi,%edi
80102026:	74 29                	je     80102051 <dirlink+0x51>
80102028:	31 ff                	xor    %edi,%edi
8010202a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010202d:	eb 09                	jmp    80102038 <dirlink+0x38>
8010202f:	90                   	nop
80102030:	83 c7 10             	add    $0x10,%edi
80102033:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102036:	73 19                	jae    80102051 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102038:	6a 10                	push   $0x10
8010203a:	57                   	push   %edi
8010203b:	56                   	push   %esi
8010203c:	53                   	push   %ebx
8010203d:	e8 6e fa ff ff       	call   80101ab0 <readi>
80102042:	83 c4 10             	add    $0x10,%esp
80102045:	83 f8 10             	cmp    $0x10,%eax
80102048:	75 4e                	jne    80102098 <dirlink+0x98>
    if(de.inum == 0)
8010204a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010204f:	75 df                	jne    80102030 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102051:	83 ec 04             	sub    $0x4,%esp
80102054:	8d 45 da             	lea    -0x26(%ebp),%eax
80102057:	6a 0e                	push   $0xe
80102059:	ff 75 0c             	push   0xc(%ebp)
8010205c:	50                   	push   %eax
8010205d:	e8 ce 2d 00 00       	call   80104e30 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102062:	6a 10                	push   $0x10
  de.inum = inum;
80102064:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102067:	57                   	push   %edi
80102068:	56                   	push   %esi
80102069:	53                   	push   %ebx
  de.inum = inum;
8010206a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010206e:	e8 3d fb ff ff       	call   80101bb0 <writei>
80102073:	83 c4 20             	add    $0x20,%esp
80102076:	83 f8 10             	cmp    $0x10,%eax
80102079:	75 2a                	jne    801020a5 <dirlink+0xa5>
  return 0;
8010207b:	31 c0                	xor    %eax,%eax
}
8010207d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102080:	5b                   	pop    %ebx
80102081:	5e                   	pop    %esi
80102082:	5f                   	pop    %edi
80102083:	5d                   	pop    %ebp
80102084:	c3                   	ret    
    iput(ip);
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	50                   	push   %eax
80102089:	e8 42 f8 ff ff       	call   801018d0 <iput>
    return -1;
8010208e:	83 c4 10             	add    $0x10,%esp
80102091:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102096:	eb e5                	jmp    8010207d <dirlink+0x7d>
      panic("dirlink read");
80102098:	83 ec 0c             	sub    $0xc,%esp
8010209b:	68 68 7b 10 80       	push   $0x80107b68
801020a0:	e8 db e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020a5:	83 ec 0c             	sub    $0xc,%esp
801020a8:	68 4a 81 10 80       	push   $0x8010814a
801020ad:	e8 ce e2 ff ff       	call   80100380 <panic>
801020b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020c0 <namei>:

struct inode*
namei(char *path)
{
801020c0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020c1:	31 d2                	xor    %edx,%edx
{
801020c3:	89 e5                	mov    %esp,%ebp
801020c5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020c8:	8b 45 08             	mov    0x8(%ebp),%eax
801020cb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ce:	e8 dd fc ff ff       	call   80101db0 <namex>
}
801020d3:	c9                   	leave  
801020d4:	c3                   	ret    
801020d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020e0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020e0:	55                   	push   %ebp
  return namex(path, 1, name);
801020e1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020e6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ee:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020ef:	e9 bc fc ff ff       	jmp    80101db0 <namex>
801020f4:	66 90                	xchg   %ax,%ax
801020f6:	66 90                	xchg   %ax,%ax
801020f8:	66 90                	xchg   %ax,%ax
801020fa:	66 90                	xchg   %ax,%ax
801020fc:	66 90                	xchg   %ax,%ax
801020fe:	66 90                	xchg   %ax,%ax

80102100 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	57                   	push   %edi
80102104:	56                   	push   %esi
80102105:	53                   	push   %ebx
80102106:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102109:	85 c0                	test   %eax,%eax
8010210b:	0f 84 b4 00 00 00    	je     801021c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102111:	8b 70 08             	mov    0x8(%eax),%esi
80102114:	89 c3                	mov    %eax,%ebx
80102116:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010211c:	0f 87 96 00 00 00    	ja     801021b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102122:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010212e:	66 90                	xchg   %ax,%ax
80102130:	89 ca                	mov    %ecx,%edx
80102132:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102133:	83 e0 c0             	and    $0xffffffc0,%eax
80102136:	3c 40                	cmp    $0x40,%al
80102138:	75 f6                	jne    80102130 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010213a:	31 ff                	xor    %edi,%edi
8010213c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102141:	89 f8                	mov    %edi,%eax
80102143:	ee                   	out    %al,(%dx)
80102144:	b8 01 00 00 00       	mov    $0x1,%eax
80102149:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010214e:	ee                   	out    %al,(%dx)
8010214f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102154:	89 f0                	mov    %esi,%eax
80102156:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102157:	89 f0                	mov    %esi,%eax
80102159:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010215e:	c1 f8 08             	sar    $0x8,%eax
80102161:	ee                   	out    %al,(%dx)
80102162:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102167:	89 f8                	mov    %edi,%eax
80102169:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010216a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010216e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102173:	c1 e0 04             	shl    $0x4,%eax
80102176:	83 e0 10             	and    $0x10,%eax
80102179:	83 c8 e0             	or     $0xffffffe0,%eax
8010217c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010217d:	f6 03 04             	testb  $0x4,(%ebx)
80102180:	75 16                	jne    80102198 <idestart+0x98>
80102182:	b8 20 00 00 00       	mov    $0x20,%eax
80102187:	89 ca                	mov    %ecx,%edx
80102189:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010218a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010218d:	5b                   	pop    %ebx
8010218e:	5e                   	pop    %esi
8010218f:	5f                   	pop    %edi
80102190:	5d                   	pop    %ebp
80102191:	c3                   	ret    
80102192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102198:	b8 30 00 00 00       	mov    $0x30,%eax
8010219d:	89 ca                	mov    %ecx,%edx
8010219f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ad:	fc                   	cld    
801021ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021b3:	5b                   	pop    %ebx
801021b4:	5e                   	pop    %esi
801021b5:	5f                   	pop    %edi
801021b6:	5d                   	pop    %ebp
801021b7:	c3                   	ret    
    panic("incorrect blockno");
801021b8:	83 ec 0c             	sub    $0xc,%esp
801021bb:	68 d4 7b 10 80       	push   $0x80107bd4
801021c0:	e8 bb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021c5:	83 ec 0c             	sub    $0xc,%esp
801021c8:	68 cb 7b 10 80       	push   $0x80107bcb
801021cd:	e8 ae e1 ff ff       	call   80100380 <panic>
801021d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021e0 <ideinit>:
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021e6:	68 e6 7b 10 80       	push   $0x80107be6
801021eb:	68 00 26 11 80       	push   $0x80112600
801021f0:	e8 4b 28 00 00       	call   80104a40 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021f5:	58                   	pop    %eax
801021f6:	a1 84 27 11 80       	mov    0x80112784,%eax
801021fb:	5a                   	pop    %edx
801021fc:	83 e8 01             	sub    $0x1,%eax
801021ff:	50                   	push   %eax
80102200:	6a 0e                	push   $0xe
80102202:	e8 99 02 00 00       	call   801024a0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102207:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010220a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220f:	90                   	nop
80102210:	ec                   	in     (%dx),%al
80102211:	83 e0 c0             	and    $0xffffffc0,%eax
80102214:	3c 40                	cmp    $0x40,%al
80102216:	75 f8                	jne    80102210 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102218:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010221d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102222:	ee                   	out    %al,(%dx)
80102223:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102228:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010222d:	eb 06                	jmp    80102235 <ideinit+0x55>
8010222f:	90                   	nop
  for(i=0; i<1000; i++){
80102230:	83 e9 01             	sub    $0x1,%ecx
80102233:	74 0f                	je     80102244 <ideinit+0x64>
80102235:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102236:	84 c0                	test   %al,%al
80102238:	74 f6                	je     80102230 <ideinit+0x50>
      havedisk1 = 1;
8010223a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102241:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102244:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102249:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010224e:	ee                   	out    %al,(%dx)
}
8010224f:	c9                   	leave  
80102250:	c3                   	ret    
80102251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010225f:	90                   	nop

80102260 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	57                   	push   %edi
80102264:	56                   	push   %esi
80102265:	53                   	push   %ebx
80102266:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102269:	68 00 26 11 80       	push   $0x80112600
8010226e:	e8 9d 29 00 00       	call   80104c10 <acquire>

  if((b = idequeue) == 0){
80102273:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102279:	83 c4 10             	add    $0x10,%esp
8010227c:	85 db                	test   %ebx,%ebx
8010227e:	74 63                	je     801022e3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102280:	8b 43 58             	mov    0x58(%ebx),%eax
80102283:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102288:	8b 33                	mov    (%ebx),%esi
8010228a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102290:	75 2f                	jne    801022c1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102292:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010229e:	66 90                	xchg   %ax,%ax
801022a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022a1:	89 c1                	mov    %eax,%ecx
801022a3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022a6:	80 f9 40             	cmp    $0x40,%cl
801022a9:	75 f5                	jne    801022a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022ab:	a8 21                	test   $0x21,%al
801022ad:	75 12                	jne    801022c1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022af:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022b2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022b7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022bc:	fc                   	cld    
801022bd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022bf:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022c1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022c4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022c7:	83 ce 02             	or     $0x2,%esi
801022ca:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022cc:	53                   	push   %ebx
801022cd:	e8 0e 1f 00 00       	call   801041e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022d2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022d7:	83 c4 10             	add    $0x10,%esp
801022da:	85 c0                	test   %eax,%eax
801022dc:	74 05                	je     801022e3 <ideintr+0x83>
    idestart(idequeue);
801022de:	e8 1d fe ff ff       	call   80102100 <idestart>
    release(&idelock);
801022e3:	83 ec 0c             	sub    $0xc,%esp
801022e6:	68 00 26 11 80       	push   $0x80112600
801022eb:	e8 c0 28 00 00       	call   80104bb0 <release>

  release(&idelock);
}
801022f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022f3:	5b                   	pop    %ebx
801022f4:	5e                   	pop    %esi
801022f5:	5f                   	pop    %edi
801022f6:	5d                   	pop    %ebp
801022f7:	c3                   	ret    
801022f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ff:	90                   	nop

80102300 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	53                   	push   %ebx
80102304:	83 ec 10             	sub    $0x10,%esp
80102307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010230a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010230d:	50                   	push   %eax
8010230e:	e8 dd 26 00 00       	call   801049f0 <holdingsleep>
80102313:	83 c4 10             	add    $0x10,%esp
80102316:	85 c0                	test   %eax,%eax
80102318:	0f 84 c3 00 00 00    	je     801023e1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 e0 06             	and    $0x6,%eax
80102323:	83 f8 02             	cmp    $0x2,%eax
80102326:	0f 84 a8 00 00 00    	je     801023d4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010232c:	8b 53 04             	mov    0x4(%ebx),%edx
8010232f:	85 d2                	test   %edx,%edx
80102331:	74 0d                	je     80102340 <iderw+0x40>
80102333:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102338:	85 c0                	test   %eax,%eax
8010233a:	0f 84 87 00 00 00    	je     801023c7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102340:	83 ec 0c             	sub    $0xc,%esp
80102343:	68 00 26 11 80       	push   $0x80112600
80102348:	e8 c3 28 00 00       	call   80104c10 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010234d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102352:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102359:	83 c4 10             	add    $0x10,%esp
8010235c:	85 c0                	test   %eax,%eax
8010235e:	74 60                	je     801023c0 <iderw+0xc0>
80102360:	89 c2                	mov    %eax,%edx
80102362:	8b 40 58             	mov    0x58(%eax),%eax
80102365:	85 c0                	test   %eax,%eax
80102367:	75 f7                	jne    80102360 <iderw+0x60>
80102369:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010236c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010236e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102374:	74 3a                	je     801023b0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102376:	8b 03                	mov    (%ebx),%eax
80102378:	83 e0 06             	and    $0x6,%eax
8010237b:	83 f8 02             	cmp    $0x2,%eax
8010237e:	74 1b                	je     8010239b <iderw+0x9b>
    sleep(b, &idelock);
80102380:	83 ec 08             	sub    $0x8,%esp
80102383:	68 00 26 11 80       	push   $0x80112600
80102388:	53                   	push   %ebx
80102389:	e8 92 1d 00 00       	call   80104120 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010238e:	8b 03                	mov    (%ebx),%eax
80102390:	83 c4 10             	add    $0x10,%esp
80102393:	83 e0 06             	and    $0x6,%eax
80102396:	83 f8 02             	cmp    $0x2,%eax
80102399:	75 e5                	jne    80102380 <iderw+0x80>
  }


  release(&idelock);
8010239b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
801023a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023a5:	c9                   	leave  
  release(&idelock);
801023a6:	e9 05 28 00 00       	jmp    80104bb0 <release>
801023ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023af:	90                   	nop
    idestart(b);
801023b0:	89 d8                	mov    %ebx,%eax
801023b2:	e8 49 fd ff ff       	call   80102100 <idestart>
801023b7:	eb bd                	jmp    80102376 <iderw+0x76>
801023b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023c0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023c5:	eb a5                	jmp    8010236c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023c7:	83 ec 0c             	sub    $0xc,%esp
801023ca:	68 15 7c 10 80       	push   $0x80107c15
801023cf:	e8 ac df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023d4:	83 ec 0c             	sub    $0xc,%esp
801023d7:	68 00 7c 10 80       	push   $0x80107c00
801023dc:	e8 9f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023e1:	83 ec 0c             	sub    $0xc,%esp
801023e4:	68 ea 7b 10 80       	push   $0x80107bea
801023e9:	e8 92 df ff ff       	call   80100380 <panic>
801023ee:	66 90                	xchg   %ax,%ax

801023f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023f1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023f8:	00 c0 fe 
{
801023fb:	89 e5                	mov    %esp,%ebp
801023fd:	56                   	push   %esi
801023fe:	53                   	push   %ebx
  ioapic->reg = reg;
801023ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102406:	00 00 00 
  return ioapic->data;
80102409:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010240f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102412:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102418:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010241e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102425:	c1 ee 10             	shr    $0x10,%esi
80102428:	89 f0                	mov    %esi,%eax
8010242a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010242d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102430:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102433:	39 c2                	cmp    %eax,%edx
80102435:	74 16                	je     8010244d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102437:	83 ec 0c             	sub    $0xc,%esp
8010243a:	68 34 7c 10 80       	push   $0x80107c34
8010243f:	e8 5c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010244a:	83 c4 10             	add    $0x10,%esp
8010244d:	83 c6 21             	add    $0x21,%esi
{
80102450:	ba 10 00 00 00       	mov    $0x10,%edx
80102455:	b8 20 00 00 00       	mov    $0x20,%eax
8010245a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102460:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102462:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102464:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010246a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010246d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102473:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102476:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102479:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010247c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010247e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102484:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010248b:	39 f0                	cmp    %esi,%eax
8010248d:	75 d1                	jne    80102460 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010248f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102492:	5b                   	pop    %ebx
80102493:	5e                   	pop    %esi
80102494:	5d                   	pop    %ebp
80102495:	c3                   	ret    
80102496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010249d:	8d 76 00             	lea    0x0(%esi),%esi

801024a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024a0:	55                   	push   %ebp
  ioapic->reg = reg;
801024a1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801024a7:	89 e5                	mov    %esp,%ebp
801024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024ac:	8d 50 20             	lea    0x20(%eax),%edx
801024af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024c6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024cb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ce:	89 50 10             	mov    %edx,0x10(%eax)
}
801024d1:	5d                   	pop    %ebp
801024d2:	c3                   	ret    
801024d3:	66 90                	xchg   %ax,%ax
801024d5:	66 90                	xchg   %ax,%ax
801024d7:	66 90                	xchg   %ax,%ax
801024d9:	66 90                	xchg   %ax,%ax
801024db:	66 90                	xchg   %ax,%ax
801024dd:	66 90                	xchg   %ax,%ax
801024df:	90                   	nop

801024e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	53                   	push   %ebx
801024e4:	83 ec 04             	sub    $0x4,%esp
801024e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024f0:	75 76                	jne    80102568 <kfree+0x88>
801024f2:	81 fb d0 69 11 80    	cmp    $0x801169d0,%ebx
801024f8:	72 6e                	jb     80102568 <kfree+0x88>
801024fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102500:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102505:	77 61                	ja     80102568 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102507:	83 ec 04             	sub    $0x4,%esp
8010250a:	68 00 10 00 00       	push   $0x1000
8010250f:	6a 01                	push   $0x1
80102511:	53                   	push   %ebx
80102512:	e8 b9 27 00 00       	call   80104cd0 <memset>

  if(kmem.use_lock)
80102517:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010251d:	83 c4 10             	add    $0x10,%esp
80102520:	85 d2                	test   %edx,%edx
80102522:	75 1c                	jne    80102540 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102524:	a1 78 26 11 80       	mov    0x80112678,%eax
80102529:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010252b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102530:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102536:	85 c0                	test   %eax,%eax
80102538:	75 1e                	jne    80102558 <kfree+0x78>
    release(&kmem.lock);
}
8010253a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010253d:	c9                   	leave  
8010253e:	c3                   	ret    
8010253f:	90                   	nop
    acquire(&kmem.lock);
80102540:	83 ec 0c             	sub    $0xc,%esp
80102543:	68 40 26 11 80       	push   $0x80112640
80102548:	e8 c3 26 00 00       	call   80104c10 <acquire>
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	eb d2                	jmp    80102524 <kfree+0x44>
80102552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102558:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010255f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102562:	c9                   	leave  
    release(&kmem.lock);
80102563:	e9 48 26 00 00       	jmp    80104bb0 <release>
    panic("kfree");
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	68 66 7c 10 80       	push   $0x80107c66
80102570:	e8 0b de ff ff       	call   80100380 <panic>
80102575:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102580 <freerange>:
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102584:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102587:	8b 75 0c             	mov    0xc(%ebp),%esi
8010258a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010258b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102591:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102597:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010259d:	39 de                	cmp    %ebx,%esi
8010259f:	72 23                	jb     801025c4 <freerange+0x44>
801025a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 23 ff ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 f3                	cmp    %esi,%ebx
801025c2:	76 e4                	jbe    801025a8 <freerange+0x28>
}
801025c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5d                   	pop    %ebp
801025ca:	c3                   	ret    
801025cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <kinit2>:
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025d4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025d7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025da:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ed:	39 de                	cmp    %ebx,%esi
801025ef:	72 23                	jb     80102614 <kinit2+0x44>
801025f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 d3 fe ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 e4                	jae    801025f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102614:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010261b:	00 00 00 
}
8010261e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5d                   	pop    %ebp
80102624:	c3                   	ret    
80102625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <kinit1>:
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	56                   	push   %esi
80102634:	53                   	push   %ebx
80102635:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102638:	83 ec 08             	sub    $0x8,%esp
8010263b:	68 6c 7c 10 80       	push   $0x80107c6c
80102640:	68 40 26 11 80       	push   $0x80112640
80102645:	e8 f6 23 00 00       	call   80104a40 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010264a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102650:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102657:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010265a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102660:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102666:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010266c:	39 de                	cmp    %ebx,%esi
8010266e:	72 1c                	jb     8010268c <kinit1+0x5c>
    kfree(p);
80102670:	83 ec 0c             	sub    $0xc,%esp
80102673:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102679:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010267f:	50                   	push   %eax
80102680:	e8 5b fe ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102685:	83 c4 10             	add    $0x10,%esp
80102688:	39 de                	cmp    %ebx,%esi
8010268a:	73 e4                	jae    80102670 <kinit1+0x40>
}
8010268c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010268f:	5b                   	pop    %ebx
80102690:	5e                   	pop    %esi
80102691:	5d                   	pop    %ebp
80102692:	c3                   	ret    
80102693:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010269a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026a0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801026a0:	a1 74 26 11 80       	mov    0x80112674,%eax
801026a5:	85 c0                	test   %eax,%eax
801026a7:	75 1f                	jne    801026c8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026a9:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801026ae:	85 c0                	test   %eax,%eax
801026b0:	74 0e                	je     801026c0 <kalloc+0x20>
    kmem.freelist = r->next;
801026b2:	8b 10                	mov    (%eax),%edx
801026b4:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801026ba:	c3                   	ret    
801026bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026bf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026c0:	c3                   	ret    
801026c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026c8:	55                   	push   %ebp
801026c9:	89 e5                	mov    %esp,%ebp
801026cb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ce:	68 40 26 11 80       	push   $0x80112640
801026d3:	e8 38 25 00 00       	call   80104c10 <acquire>
  r = kmem.freelist;
801026d8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801026dd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801026e3:	83 c4 10             	add    $0x10,%esp
801026e6:	85 c0                	test   %eax,%eax
801026e8:	74 08                	je     801026f2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ea:	8b 08                	mov    (%eax),%ecx
801026ec:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026f2:	85 d2                	test   %edx,%edx
801026f4:	74 16                	je     8010270c <kalloc+0x6c>
    release(&kmem.lock);
801026f6:	83 ec 0c             	sub    $0xc,%esp
801026f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026fc:	68 40 26 11 80       	push   $0x80112640
80102701:	e8 aa 24 00 00       	call   80104bb0 <release>
  return (char*)r;
80102706:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102709:	83 c4 10             	add    $0x10,%esp
}
8010270c:	c9                   	leave  
8010270d:	c3                   	ret    
8010270e:	66 90                	xchg   %ax,%ax

80102710 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102710:	ba 64 00 00 00       	mov    $0x64,%edx
80102715:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102716:	a8 01                	test   $0x1,%al
80102718:	0f 84 c2 00 00 00    	je     801027e0 <kbdgetc+0xd0>
{
8010271e:	55                   	push   %ebp
8010271f:	ba 60 00 00 00       	mov    $0x60,%edx
80102724:	89 e5                	mov    %esp,%ebp
80102726:	53                   	push   %ebx
80102727:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102728:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010272e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102731:	3c e0                	cmp    $0xe0,%al
80102733:	74 5b                	je     80102790 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102735:	89 da                	mov    %ebx,%edx
80102737:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010273a:	84 c0                	test   %al,%al
8010273c:	78 62                	js     801027a0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010273e:	85 d2                	test   %edx,%edx
80102740:	74 09                	je     8010274b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102742:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102745:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102748:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010274b:	0f b6 91 a0 7d 10 80 	movzbl -0x7fef8260(%ecx),%edx
  shift ^= togglecode[data];
80102752:	0f b6 81 a0 7c 10 80 	movzbl -0x7fef8360(%ecx),%eax
  shift |= shiftcode[data];
80102759:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010275b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010275d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010275f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102765:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102768:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010276b:	8b 04 85 80 7c 10 80 	mov    -0x7fef8380(,%eax,4),%eax
80102772:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102776:	74 0b                	je     80102783 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102778:	8d 50 9f             	lea    -0x61(%eax),%edx
8010277b:	83 fa 19             	cmp    $0x19,%edx
8010277e:	77 48                	ja     801027c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102780:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102783:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102786:	c9                   	leave  
80102787:	c3                   	ret    
80102788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278f:	90                   	nop
    shift |= E0ESC;
80102790:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102793:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102795:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010279b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010279e:	c9                   	leave  
8010279f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801027a0:	83 e0 7f             	and    $0x7f,%eax
801027a3:	85 d2                	test   %edx,%edx
801027a5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027a8:	0f b6 81 a0 7d 10 80 	movzbl -0x7fef8260(%ecx),%eax
801027af:	83 c8 40             	or     $0x40,%eax
801027b2:	0f b6 c0             	movzbl %al,%eax
801027b5:	f7 d0                	not    %eax
801027b7:	21 d8                	and    %ebx,%eax
}
801027b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801027bc:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801027c1:	31 c0                	xor    %eax,%eax
}
801027c3:	c9                   	leave  
801027c4:	c3                   	ret    
801027c5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027cb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027d1:	c9                   	leave  
      c += 'a' - 'A';
801027d2:	83 f9 1a             	cmp    $0x1a,%ecx
801027d5:	0f 42 c2             	cmovb  %edx,%eax
}
801027d8:	c3                   	ret    
801027d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027e5:	c3                   	ret    
801027e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ed:	8d 76 00             	lea    0x0(%esi),%esi

801027f0 <kbdintr>:

void
kbdintr(void)
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027f6:	68 10 27 10 80       	push   $0x80102710
801027fb:	e8 80 e0 ff ff       	call   80100880 <consoleintr>
}
80102800:	83 c4 10             	add    $0x10,%esp
80102803:	c9                   	leave  
80102804:	c3                   	ret    
80102805:	66 90                	xchg   %ax,%ax
80102807:	66 90                	xchg   %ax,%ax
80102809:	66 90                	xchg   %ax,%ax
8010280b:	66 90                	xchg   %ax,%ax
8010280d:	66 90                	xchg   %ax,%ax
8010280f:	90                   	nop

80102810 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102810:	a1 80 26 11 80       	mov    0x80112680,%eax
80102815:	85 c0                	test   %eax,%eax
80102817:	0f 84 cb 00 00 00    	je     801028e8 <lapicinit+0xd8>
  lapic[index] = value;
8010281d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102824:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102831:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102837:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010283e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010284b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102858:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102865:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102868:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010286b:	8b 50 30             	mov    0x30(%eax),%edx
8010286e:	c1 ea 10             	shr    $0x10,%edx
80102871:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102877:	75 77                	jne    801028f0 <lapicinit+0xe0>
  lapic[index] = value;
80102879:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102880:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102883:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102886:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010288d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102890:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102893:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010289a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028a7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028aa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ad:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ba:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028c1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028c4:	8b 50 20             	mov    0x20(%eax),%edx
801028c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ce:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028d0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028d6:	80 e6 10             	and    $0x10,%dh
801028d9:	75 f5                	jne    801028d0 <lapicinit+0xc0>
  lapic[index] = value;
801028db:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028e2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028e8:	c3                   	ret    
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028f0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028f7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028fa:	8b 50 20             	mov    0x20(%eax),%edx
}
801028fd:	e9 77 ff ff ff       	jmp    80102879 <lapicinit+0x69>
80102902:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102910 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102910:	a1 80 26 11 80       	mov    0x80112680,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 07                	je     80102920 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102919:	8b 40 20             	mov    0x20(%eax),%eax
8010291c:	c1 e8 18             	shr    $0x18,%eax
8010291f:	c3                   	ret    
    return 0;
80102920:	31 c0                	xor    %eax,%eax
}
80102922:	c3                   	ret    
80102923:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102930 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102930:	a1 80 26 11 80       	mov    0x80112680,%eax
80102935:	85 c0                	test   %eax,%eax
80102937:	74 0d                	je     80102946 <lapiceoi+0x16>
  lapic[index] = value;
80102939:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102940:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102943:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102946:	c3                   	ret    
80102947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294e:	66 90                	xchg   %ax,%ax

80102950 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102950:	c3                   	ret    
80102951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010295f:	90                   	nop

80102960 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102960:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102961:	b8 0f 00 00 00       	mov    $0xf,%eax
80102966:	ba 70 00 00 00       	mov    $0x70,%edx
8010296b:	89 e5                	mov    %esp,%ebp
8010296d:	53                   	push   %ebx
8010296e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102971:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102974:	ee                   	out    %al,(%dx)
80102975:	b8 0a 00 00 00       	mov    $0xa,%eax
8010297a:	ba 71 00 00 00       	mov    $0x71,%edx
8010297f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102980:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102982:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102985:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010298b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010298d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102990:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102992:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102995:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102998:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010299e:	a1 80 26 11 80       	mov    0x80112680,%eax
801029a3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ac:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029b3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029c0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029cc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029cf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029d8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029e7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ed:	c9                   	leave  
801029ee:	c3                   	ret    
801029ef:	90                   	nop

801029f0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029f0:	55                   	push   %ebp
801029f1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029f6:	ba 70 00 00 00       	mov    $0x70,%edx
801029fb:	89 e5                	mov    %esp,%ebp
801029fd:	57                   	push   %edi
801029fe:	56                   	push   %esi
801029ff:	53                   	push   %ebx
80102a00:	83 ec 4c             	sub    $0x4c,%esp
80102a03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a04:	ba 71 00 00 00       	mov    $0x71,%edx
80102a09:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a0a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a12:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a15:	8d 76 00             	lea    0x0(%esi),%esi
80102a18:	31 c0                	xor    %eax,%eax
80102a1a:	89 da                	mov    %ebx,%edx
80102a1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a22:	89 ca                	mov    %ecx,%edx
80102a24:	ec                   	in     (%dx),%al
80102a25:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a28:	89 da                	mov    %ebx,%edx
80102a2a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a30:	89 ca                	mov    %ecx,%edx
80102a32:	ec                   	in     (%dx),%al
80102a33:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a36:	89 da                	mov    %ebx,%edx
80102a38:	b8 04 00 00 00       	mov    $0x4,%eax
80102a3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3e:	89 ca                	mov    %ecx,%edx
80102a40:	ec                   	in     (%dx),%al
80102a41:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a44:	89 da                	mov    %ebx,%edx
80102a46:	b8 07 00 00 00       	mov    $0x7,%eax
80102a4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4c:	89 ca                	mov    %ecx,%edx
80102a4e:	ec                   	in     (%dx),%al
80102a4f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a52:	89 da                	mov    %ebx,%edx
80102a54:	b8 08 00 00 00       	mov    $0x8,%eax
80102a59:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5a:	89 ca                	mov    %ecx,%edx
80102a5c:	ec                   	in     (%dx),%al
80102a5d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5f:	89 da                	mov    %ebx,%edx
80102a61:	b8 09 00 00 00       	mov    $0x9,%eax
80102a66:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a67:	89 ca                	mov    %ecx,%edx
80102a69:	ec                   	in     (%dx),%al
80102a6a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6c:	89 da                	mov    %ebx,%edx
80102a6e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a74:	89 ca                	mov    %ecx,%edx
80102a76:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a77:	84 c0                	test   %al,%al
80102a79:	78 9d                	js     80102a18 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a7b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a7f:	89 fa                	mov    %edi,%edx
80102a81:	0f b6 fa             	movzbl %dl,%edi
80102a84:	89 f2                	mov    %esi,%edx
80102a86:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a89:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a8d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a90:	89 da                	mov    %ebx,%edx
80102a92:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a95:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a98:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a9c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a9f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102aa2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102aa6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102aa9:	31 c0                	xor    %eax,%eax
80102aab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aac:	89 ca                	mov    %ecx,%edx
80102aae:	ec                   	in     (%dx),%al
80102aaf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab2:	89 da                	mov    %ebx,%edx
80102ab4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ab7:	b8 02 00 00 00       	mov    $0x2,%eax
80102abc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abd:	89 ca                	mov    %ecx,%edx
80102abf:	ec                   	in     (%dx),%al
80102ac0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac3:	89 da                	mov    %ebx,%edx
80102ac5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ac8:	b8 04 00 00 00       	mov    $0x4,%eax
80102acd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ace:	89 ca                	mov    %ecx,%edx
80102ad0:	ec                   	in     (%dx),%al
80102ad1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad4:	89 da                	mov    %ebx,%edx
80102ad6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ad9:	b8 07 00 00 00       	mov    $0x7,%eax
80102ade:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102adf:	89 ca                	mov    %ecx,%edx
80102ae1:	ec                   	in     (%dx),%al
80102ae2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae5:	89 da                	mov    %ebx,%edx
80102ae7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aea:	b8 08 00 00 00       	mov    $0x8,%eax
80102aef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af0:	89 ca                	mov    %ecx,%edx
80102af2:	ec                   	in     (%dx),%al
80102af3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af6:	89 da                	mov    %ebx,%edx
80102af8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102afb:	b8 09 00 00 00       	mov    $0x9,%eax
80102b00:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b01:	89 ca                	mov    %ecx,%edx
80102b03:	ec                   	in     (%dx),%al
80102b04:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b07:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b0d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b10:	6a 18                	push   $0x18
80102b12:	50                   	push   %eax
80102b13:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b16:	50                   	push   %eax
80102b17:	e8 04 22 00 00       	call   80104d20 <memcmp>
80102b1c:	83 c4 10             	add    $0x10,%esp
80102b1f:	85 c0                	test   %eax,%eax
80102b21:	0f 85 f1 fe ff ff    	jne    80102a18 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b27:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b2b:	75 78                	jne    80102ba5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b2d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b30:	89 c2                	mov    %eax,%edx
80102b32:	83 e0 0f             	and    $0xf,%eax
80102b35:	c1 ea 04             	shr    $0x4,%edx
80102b38:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b41:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b44:	89 c2                	mov    %eax,%edx
80102b46:	83 e0 0f             	and    $0xf,%eax
80102b49:	c1 ea 04             	shr    $0x4,%edx
80102b4c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b52:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b55:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b58:	89 c2                	mov    %eax,%edx
80102b5a:	83 e0 0f             	and    $0xf,%eax
80102b5d:	c1 ea 04             	shr    $0x4,%edx
80102b60:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b63:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b66:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b69:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b6c:	89 c2                	mov    %eax,%edx
80102b6e:	83 e0 0f             	and    $0xf,%eax
80102b71:	c1 ea 04             	shr    $0x4,%edx
80102b74:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b77:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b80:	89 c2                	mov    %eax,%edx
80102b82:	83 e0 0f             	and    $0xf,%eax
80102b85:	c1 ea 04             	shr    $0x4,%edx
80102b88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b8e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b91:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b94:	89 c2                	mov    %eax,%edx
80102b96:	83 e0 0f             	and    $0xf,%eax
80102b99:	c1 ea 04             	shr    $0x4,%edx
80102b9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ba2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ba5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ba8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bab:	89 06                	mov    %eax,(%esi)
80102bad:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bb0:	89 46 04             	mov    %eax,0x4(%esi)
80102bb3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bb6:	89 46 08             	mov    %eax,0x8(%esi)
80102bb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bbc:	89 46 0c             	mov    %eax,0xc(%esi)
80102bbf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bc2:	89 46 10             	mov    %eax,0x10(%esi)
80102bc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bc8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bcb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bd5:	5b                   	pop    %ebx
80102bd6:	5e                   	pop    %esi
80102bd7:	5f                   	pop    %edi
80102bd8:	5d                   	pop    %ebp
80102bd9:	c3                   	ret    
80102bda:	66 90                	xchg   %ax,%ax
80102bdc:	66 90                	xchg   %ax,%ax
80102bde:	66 90                	xchg   %ax,%ax

80102be0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102be0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102be6:	85 c9                	test   %ecx,%ecx
80102be8:	0f 8e 8a 00 00 00    	jle    80102c78 <install_trans+0x98>
{
80102bee:	55                   	push   %ebp
80102bef:	89 e5                	mov    %esp,%ebp
80102bf1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bf2:	31 ff                	xor    %edi,%edi
{
80102bf4:	56                   	push   %esi
80102bf5:	53                   	push   %ebx
80102bf6:	83 ec 0c             	sub    $0xc,%esp
80102bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c00:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c05:	83 ec 08             	sub    $0x8,%esp
80102c08:	01 f8                	add    %edi,%eax
80102c0a:	83 c0 01             	add    $0x1,%eax
80102c0d:	50                   	push   %eax
80102c0e:	ff 35 e4 26 11 80    	push   0x801126e4
80102c14:	e8 b7 d4 ff ff       	call   801000d0 <bread>
80102c19:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c1b:	58                   	pop    %eax
80102c1c:	5a                   	pop    %edx
80102c1d:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c24:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c2a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c2d:	e8 9e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c32:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c35:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c37:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c3a:	68 00 02 00 00       	push   $0x200
80102c3f:	50                   	push   %eax
80102c40:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c43:	50                   	push   %eax
80102c44:	e8 27 21 00 00       	call   80104d70 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c49:	89 1c 24             	mov    %ebx,(%esp)
80102c4c:	e8 5f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c51:	89 34 24             	mov    %esi,(%esp)
80102c54:	e8 97 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c59:	89 1c 24             	mov    %ebx,(%esp)
80102c5c:	e8 8f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c61:	83 c4 10             	add    $0x10,%esp
80102c64:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c6a:	7f 94                	jg     80102c00 <install_trans+0x20>
  }
}
80102c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c6f:	5b                   	pop    %ebx
80102c70:	5e                   	pop    %esi
80102c71:	5f                   	pop    %edi
80102c72:	5d                   	pop    %ebp
80102c73:	c3                   	ret    
80102c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c78:	c3                   	ret    
80102c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	53                   	push   %ebx
80102c84:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c87:	ff 35 d4 26 11 80    	push   0x801126d4
80102c8d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c93:	e8 38 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c98:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c9b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c9d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102ca2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102ca5:	85 c0                	test   %eax,%eax
80102ca7:	7e 19                	jle    80102cc2 <write_head+0x42>
80102ca9:	31 d2                	xor    %edx,%edx
80102cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102caf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102cb0:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102cb7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cbb:	83 c2 01             	add    $0x1,%edx
80102cbe:	39 d0                	cmp    %edx,%eax
80102cc0:	75 ee                	jne    80102cb0 <write_head+0x30>
  }
  bwrite(buf);
80102cc2:	83 ec 0c             	sub    $0xc,%esp
80102cc5:	53                   	push   %ebx
80102cc6:	e8 e5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102ccb:	89 1c 24             	mov    %ebx,(%esp)
80102cce:	e8 1d d5 ff ff       	call   801001f0 <brelse>
}
80102cd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cd6:	83 c4 10             	add    $0x10,%esp
80102cd9:	c9                   	leave  
80102cda:	c3                   	ret    
80102cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cdf:	90                   	nop

80102ce0 <initlog>:
{
80102ce0:	55                   	push   %ebp
80102ce1:	89 e5                	mov    %esp,%ebp
80102ce3:	53                   	push   %ebx
80102ce4:	83 ec 2c             	sub    $0x2c,%esp
80102ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cea:	68 a0 7e 10 80       	push   $0x80107ea0
80102cef:	68 a0 26 11 80       	push   $0x801126a0
80102cf4:	e8 47 1d 00 00       	call   80104a40 <initlock>
  readsb(dev, &sb);
80102cf9:	58                   	pop    %eax
80102cfa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 3b e8 ff ff       	call   80101540 <readsb>
  log.start = sb.logstart;
80102d05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d08:	59                   	pop    %ecx
  log.dev = dev;
80102d09:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102d0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d12:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102d17:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102d1d:	5a                   	pop    %edx
80102d1e:	50                   	push   %eax
80102d1f:	53                   	push   %ebx
80102d20:	e8 ab d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d25:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d28:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d2b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d31:	85 db                	test   %ebx,%ebx
80102d33:	7e 1d                	jle    80102d52 <initlog+0x72>
80102d35:	31 d2                	xor    %edx,%edx
80102d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d3e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d40:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d44:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d4b:	83 c2 01             	add    $0x1,%edx
80102d4e:	39 d3                	cmp    %edx,%ebx
80102d50:	75 ee                	jne    80102d40 <initlog+0x60>
  brelse(buf);
80102d52:	83 ec 0c             	sub    $0xc,%esp
80102d55:	50                   	push   %eax
80102d56:	e8 95 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d5b:	e8 80 fe ff ff       	call   80102be0 <install_trans>
  log.lh.n = 0;
80102d60:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d67:	00 00 00 
  write_head(); // clear the log
80102d6a:	e8 11 ff ff ff       	call   80102c80 <write_head>
}
80102d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d72:	83 c4 10             	add    $0x10,%esp
80102d75:	c9                   	leave  
80102d76:	c3                   	ret    
80102d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d86:	68 a0 26 11 80       	push   $0x801126a0
80102d8b:	e8 80 1e 00 00       	call   80104c10 <acquire>
80102d90:	83 c4 10             	add    $0x10,%esp
80102d93:	eb 18                	jmp    80102dad <begin_op+0x2d>
80102d95:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d98:	83 ec 08             	sub    $0x8,%esp
80102d9b:	68 a0 26 11 80       	push   $0x801126a0
80102da0:	68 a0 26 11 80       	push   $0x801126a0
80102da5:	e8 76 13 00 00       	call   80104120 <sleep>
80102daa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102dad:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102db2:	85 c0                	test   %eax,%eax
80102db4:	75 e2                	jne    80102d98 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102db6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102dbb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102dc1:	83 c0 01             	add    $0x1,%eax
80102dc4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102dc7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dca:	83 fa 1e             	cmp    $0x1e,%edx
80102dcd:	7f c9                	jg     80102d98 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dcf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dd2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102dd7:	68 a0 26 11 80       	push   $0x801126a0
80102ddc:	e8 cf 1d 00 00       	call   80104bb0 <release>
      break;
    }
  }
}
80102de1:	83 c4 10             	add    $0x10,%esp
80102de4:	c9                   	leave  
80102de5:	c3                   	ret    
80102de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ded:	8d 76 00             	lea    0x0(%esi),%esi

80102df0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	57                   	push   %edi
80102df4:	56                   	push   %esi
80102df5:	53                   	push   %ebx
80102df6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102df9:	68 a0 26 11 80       	push   $0x801126a0
80102dfe:	e8 0d 1e 00 00       	call   80104c10 <acquire>
  log.outstanding -= 1;
80102e03:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102e08:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102e0e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e11:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e14:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102e1a:	85 f6                	test   %esi,%esi
80102e1c:	0f 85 22 01 00 00    	jne    80102f44 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e22:	85 db                	test   %ebx,%ebx
80102e24:	0f 85 f6 00 00 00    	jne    80102f20 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e2a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e31:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e34:	83 ec 0c             	sub    $0xc,%esp
80102e37:	68 a0 26 11 80       	push   $0x801126a0
80102e3c:	e8 6f 1d 00 00       	call   80104bb0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e41:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e47:	83 c4 10             	add    $0x10,%esp
80102e4a:	85 c9                	test   %ecx,%ecx
80102e4c:	7f 42                	jg     80102e90 <end_op+0xa0>
    acquire(&log.lock);
80102e4e:	83 ec 0c             	sub    $0xc,%esp
80102e51:	68 a0 26 11 80       	push   $0x801126a0
80102e56:	e8 b5 1d 00 00       	call   80104c10 <acquire>
    wakeup(&log);
80102e5b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102e62:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e69:	00 00 00 
    wakeup(&log);
80102e6c:	e8 6f 13 00 00       	call   801041e0 <wakeup>
    release(&log.lock);
80102e71:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e78:	e8 33 1d 00 00       	call   80104bb0 <release>
80102e7d:	83 c4 10             	add    $0x10,%esp
}
80102e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e83:	5b                   	pop    %ebx
80102e84:	5e                   	pop    %esi
80102e85:	5f                   	pop    %edi
80102e86:	5d                   	pop    %ebp
80102e87:	c3                   	ret    
80102e88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e8f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e90:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e95:	83 ec 08             	sub    $0x8,%esp
80102e98:	01 d8                	add    %ebx,%eax
80102e9a:	83 c0 01             	add    $0x1,%eax
80102e9d:	50                   	push   %eax
80102e9e:	ff 35 e4 26 11 80    	push   0x801126e4
80102ea4:	e8 27 d2 ff ff       	call   801000d0 <bread>
80102ea9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eab:	58                   	pop    %eax
80102eac:	5a                   	pop    %edx
80102ead:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102eb4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eba:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ebd:	e8 0e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ec2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ec5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ec7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eca:	68 00 02 00 00       	push   $0x200
80102ecf:	50                   	push   %eax
80102ed0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ed3:	50                   	push   %eax
80102ed4:	e8 97 1e 00 00       	call   80104d70 <memmove>
    bwrite(to);  // write the log
80102ed9:	89 34 24             	mov    %esi,(%esp)
80102edc:	e8 cf d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ee1:	89 3c 24             	mov    %edi,(%esp)
80102ee4:	e8 07 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ee9:	89 34 24             	mov    %esi,(%esp)
80102eec:	e8 ff d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ef1:	83 c4 10             	add    $0x10,%esp
80102ef4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102efa:	7c 94                	jl     80102e90 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102efc:	e8 7f fd ff ff       	call   80102c80 <write_head>
    install_trans(); // Now install writes to home locations
80102f01:	e8 da fc ff ff       	call   80102be0 <install_trans>
    log.lh.n = 0;
80102f06:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102f0d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f10:	e8 6b fd ff ff       	call   80102c80 <write_head>
80102f15:	e9 34 ff ff ff       	jmp    80102e4e <end_op+0x5e>
80102f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f20:	83 ec 0c             	sub    $0xc,%esp
80102f23:	68 a0 26 11 80       	push   $0x801126a0
80102f28:	e8 b3 12 00 00       	call   801041e0 <wakeup>
  release(&log.lock);
80102f2d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f34:	e8 77 1c 00 00       	call   80104bb0 <release>
80102f39:	83 c4 10             	add    $0x10,%esp
}
80102f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f3f:	5b                   	pop    %ebx
80102f40:	5e                   	pop    %esi
80102f41:	5f                   	pop    %edi
80102f42:	5d                   	pop    %ebp
80102f43:	c3                   	ret    
    panic("log.committing");
80102f44:	83 ec 0c             	sub    $0xc,%esp
80102f47:	68 a4 7e 10 80       	push   $0x80107ea4
80102f4c:	e8 2f d4 ff ff       	call   80100380 <panic>
80102f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f5f:	90                   	nop

80102f60 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	53                   	push   %ebx
80102f64:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f67:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f70:	83 fa 1d             	cmp    $0x1d,%edx
80102f73:	0f 8f 85 00 00 00    	jg     80102ffe <log_write+0x9e>
80102f79:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f7e:	83 e8 01             	sub    $0x1,%eax
80102f81:	39 c2                	cmp    %eax,%edx
80102f83:	7d 79                	jge    80102ffe <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f85:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f8a:	85 c0                	test   %eax,%eax
80102f8c:	7e 7d                	jle    8010300b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f8e:	83 ec 0c             	sub    $0xc,%esp
80102f91:	68 a0 26 11 80       	push   $0x801126a0
80102f96:	e8 75 1c 00 00       	call   80104c10 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f9b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102fa1:	83 c4 10             	add    $0x10,%esp
80102fa4:	85 d2                	test   %edx,%edx
80102fa6:	7e 4a                	jle    80102ff2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fa8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fab:	31 c0                	xor    %eax,%eax
80102fad:	eb 08                	jmp    80102fb7 <log_write+0x57>
80102faf:	90                   	nop
80102fb0:	83 c0 01             	add    $0x1,%eax
80102fb3:	39 c2                	cmp    %eax,%edx
80102fb5:	74 29                	je     80102fe0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fb7:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102fbe:	75 f0                	jne    80102fb0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fc7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fcd:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102fd4:	c9                   	leave  
  release(&log.lock);
80102fd5:	e9 d6 1b 00 00       	jmp    80104bb0 <release>
80102fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fe0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80102fe7:	83 c2 01             	add    $0x1,%edx
80102fea:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102ff0:	eb d5                	jmp    80102fc7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102ff2:	8b 43 08             	mov    0x8(%ebx),%eax
80102ff5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102ffa:	75 cb                	jne    80102fc7 <log_write+0x67>
80102ffc:	eb e9                	jmp    80102fe7 <log_write+0x87>
    panic("too big a transaction");
80102ffe:	83 ec 0c             	sub    $0xc,%esp
80103001:	68 b3 7e 10 80       	push   $0x80107eb3
80103006:	e8 75 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010300b:	83 ec 0c             	sub    $0xc,%esp
8010300e:	68 c9 7e 10 80       	push   $0x80107ec9
80103013:	e8 68 d3 ff ff       	call   80100380 <panic>
80103018:	66 90                	xchg   %ax,%ax
8010301a:	66 90                	xchg   %ax,%ax
8010301c:	66 90                	xchg   %ax,%ax
8010301e:	66 90                	xchg   %ax,%ax

80103020 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	53                   	push   %ebx
80103024:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103027:	e8 e4 09 00 00       	call   80103a10 <cpuid>
8010302c:	89 c3                	mov    %eax,%ebx
8010302e:	e8 dd 09 00 00       	call   80103a10 <cpuid>
80103033:	83 ec 04             	sub    $0x4,%esp
80103036:	53                   	push   %ebx
80103037:	50                   	push   %eax
80103038:	68 e4 7e 10 80       	push   $0x80107ee4
8010303d:	e8 5e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103042:	e8 99 30 00 00       	call   801060e0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103047:	e8 64 09 00 00       	call   801039b0 <mycpu>
8010304c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010304e:	b8 01 00 00 00       	mov    $0x1,%eax
80103053:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010305a:	e8 b1 0c 00 00       	call   80103d10 <scheduler>
8010305f:	90                   	nop

80103060 <mpenter>:
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103066:	e8 d5 41 00 00       	call   80107240 <switchkvm>
  seginit();
8010306b:	e8 40 41 00 00       	call   801071b0 <seginit>
  lapicinit();
80103070:	e8 9b f7 ff ff       	call   80102810 <lapicinit>
  mpmain();
80103075:	e8 a6 ff ff ff       	call   80103020 <mpmain>
8010307a:	66 90                	xchg   %ax,%ax
8010307c:	66 90                	xchg   %ax,%ax
8010307e:	66 90                	xchg   %ax,%ax

80103080 <main>:
{
80103080:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103084:	83 e4 f0             	and    $0xfffffff0,%esp
80103087:	ff 71 fc             	push   -0x4(%ecx)
8010308a:	55                   	push   %ebp
8010308b:	89 e5                	mov    %esp,%ebp
8010308d:	53                   	push   %ebx
8010308e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010308f:	83 ec 08             	sub    $0x8,%esp
80103092:	68 00 00 40 80       	push   $0x80400000
80103097:	68 d0 69 11 80       	push   $0x801169d0
8010309c:	e8 8f f5 ff ff       	call   80102630 <kinit1>
  kvmalloc();      // kernel page table
801030a1:	e8 8a 46 00 00       	call   80107730 <kvmalloc>
  mpinit();        // detect other processors
801030a6:	e8 85 01 00 00       	call   80103230 <mpinit>
  lapicinit();     // interrupt controller
801030ab:	e8 60 f7 ff ff       	call   80102810 <lapicinit>
  seginit();       // segment descriptors
801030b0:	e8 fb 40 00 00       	call   801071b0 <seginit>
  picinit();       // disable pic
801030b5:	e8 76 03 00 00       	call   80103430 <picinit>
  ioapicinit();    // another interrupt controller
801030ba:	e8 31 f3 ff ff       	call   801023f0 <ioapicinit>
  consoleinit();   // console hardware
801030bf:	e8 9c d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030c4:	e8 77 33 00 00       	call   80106440 <uartinit>
  pinit();         // process table
801030c9:	e8 c2 08 00 00       	call   80103990 <pinit>
  tvinit();        // trap vectors
801030ce:	e8 8d 2f 00 00       	call   80106060 <tvinit>
  binit();         // buffer cache
801030d3:	e8 68 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030d8:	e8 53 dd ff ff       	call   80100e30 <fileinit>
  ideinit();       // disk 
801030dd:	e8 fe f0 ff ff       	call   801021e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030e2:	83 c4 0c             	add    $0xc,%esp
801030e5:	68 8a 00 00 00       	push   $0x8a
801030ea:	68 8c b4 10 80       	push   $0x8010b48c
801030ef:	68 00 70 00 80       	push   $0x80007000
801030f4:	e8 77 1c 00 00       	call   80104d70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030f9:	83 c4 10             	add    $0x10,%esp
801030fc:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103103:	00 00 00 
80103106:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010310b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103110:	76 7e                	jbe    80103190 <main+0x110>
80103112:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103117:	eb 20                	jmp    80103139 <main+0xb9>
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103120:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103127:	00 00 00 
8010312a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103130:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103135:	39 c3                	cmp    %eax,%ebx
80103137:	73 57                	jae    80103190 <main+0x110>
    if(c == mycpu())  // We've started already.
80103139:	e8 72 08 00 00       	call   801039b0 <mycpu>
8010313e:	39 c3                	cmp    %eax,%ebx
80103140:	74 de                	je     80103120 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103142:	e8 59 f5 ff ff       	call   801026a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103147:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010314a:	c7 05 f8 6f 00 80 60 	movl   $0x80103060,0x80006ff8
80103151:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103154:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010315b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010315e:	05 00 10 00 00       	add    $0x1000,%eax
80103163:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103168:	0f b6 03             	movzbl (%ebx),%eax
8010316b:	68 00 70 00 00       	push   $0x7000
80103170:	50                   	push   %eax
80103171:	e8 ea f7 ff ff       	call   80102960 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103176:	83 c4 10             	add    $0x10,%esp
80103179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103180:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103186:	85 c0                	test   %eax,%eax
80103188:	74 f6                	je     80103180 <main+0x100>
8010318a:	eb 94                	jmp    80103120 <main+0xa0>
8010318c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103190:	83 ec 08             	sub    $0x8,%esp
80103193:	68 00 00 00 8e       	push   $0x8e000000
80103198:	68 00 00 40 80       	push   $0x80400000
8010319d:	e8 2e f4 ff ff       	call   801025d0 <kinit2>
  userinit();      // first user process
801031a2:	e8 b9 08 00 00       	call   80103a60 <userinit>
  mpmain();        // finish this processor's setup
801031a7:	e8 74 fe ff ff       	call   80103020 <mpmain>
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	57                   	push   %edi
801031b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031bb:	53                   	push   %ebx
  e = addr+len;
801031bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031bf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031c2:	39 de                	cmp    %ebx,%esi
801031c4:	72 10                	jb     801031d6 <mpsearch1+0x26>
801031c6:	eb 50                	jmp    80103218 <mpsearch1+0x68>
801031c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031cf:	90                   	nop
801031d0:	89 fe                	mov    %edi,%esi
801031d2:	39 fb                	cmp    %edi,%ebx
801031d4:	76 42                	jbe    80103218 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d6:	83 ec 04             	sub    $0x4,%esp
801031d9:	8d 7e 10             	lea    0x10(%esi),%edi
801031dc:	6a 04                	push   $0x4
801031de:	68 f8 7e 10 80       	push   $0x80107ef8
801031e3:	56                   	push   %esi
801031e4:	e8 37 1b 00 00       	call   80104d20 <memcmp>
801031e9:	83 c4 10             	add    $0x10,%esp
801031ec:	85 c0                	test   %eax,%eax
801031ee:	75 e0                	jne    801031d0 <mpsearch1+0x20>
801031f0:	89 f2                	mov    %esi,%edx
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031f8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031fb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031fe:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103200:	39 fa                	cmp    %edi,%edx
80103202:	75 f4                	jne    801031f8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103204:	84 c0                	test   %al,%al
80103206:	75 c8                	jne    801031d0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103208:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010320b:	89 f0                	mov    %esi,%eax
8010320d:	5b                   	pop    %ebx
8010320e:	5e                   	pop    %esi
8010320f:	5f                   	pop    %edi
80103210:	5d                   	pop    %ebp
80103211:	c3                   	ret    
80103212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010321b:	31 f6                	xor    %esi,%esi
}
8010321d:	5b                   	pop    %ebx
8010321e:	89 f0                	mov    %esi,%eax
80103220:	5e                   	pop    %esi
80103221:	5f                   	pop    %edi
80103222:	5d                   	pop    %ebp
80103223:	c3                   	ret    
80103224:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010322b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010322f:	90                   	nop

80103230 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103230:	55                   	push   %ebp
80103231:	89 e5                	mov    %esp,%ebp
80103233:	57                   	push   %edi
80103234:	56                   	push   %esi
80103235:	53                   	push   %ebx
80103236:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103239:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103240:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103247:	c1 e0 08             	shl    $0x8,%eax
8010324a:	09 d0                	or     %edx,%eax
8010324c:	c1 e0 04             	shl    $0x4,%eax
8010324f:	75 1b                	jne    8010326c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103251:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103258:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010325f:	c1 e0 08             	shl    $0x8,%eax
80103262:	09 d0                	or     %edx,%eax
80103264:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103267:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010326c:	ba 00 04 00 00       	mov    $0x400,%edx
80103271:	e8 3a ff ff ff       	call   801031b0 <mpsearch1>
80103276:	89 c3                	mov    %eax,%ebx
80103278:	85 c0                	test   %eax,%eax
8010327a:	0f 84 40 01 00 00    	je     801033c0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103280:	8b 73 04             	mov    0x4(%ebx),%esi
80103283:	85 f6                	test   %esi,%esi
80103285:	0f 84 25 01 00 00    	je     801033b0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010328b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010328e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103294:	6a 04                	push   $0x4
80103296:	68 fd 7e 10 80       	push   $0x80107efd
8010329b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010329c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010329f:	e8 7c 1a 00 00       	call   80104d20 <memcmp>
801032a4:	83 c4 10             	add    $0x10,%esp
801032a7:	85 c0                	test   %eax,%eax
801032a9:	0f 85 01 01 00 00    	jne    801033b0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801032af:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032b6:	3c 01                	cmp    $0x1,%al
801032b8:	74 08                	je     801032c2 <mpinit+0x92>
801032ba:	3c 04                	cmp    $0x4,%al
801032bc:	0f 85 ee 00 00 00    	jne    801033b0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032c2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032c9:	66 85 d2             	test   %dx,%dx
801032cc:	74 22                	je     801032f0 <mpinit+0xc0>
801032ce:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032d1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032d3:	31 d2                	xor    %edx,%edx
801032d5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032d8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032df:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032e2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032e4:	39 c7                	cmp    %eax,%edi
801032e6:	75 f0                	jne    801032d8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032e8:	84 d2                	test   %dl,%dl
801032ea:	0f 85 c0 00 00 00    	jne    801033b0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032f0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032f6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032fb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103302:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103308:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103310:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103313:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103317:	90                   	nop
80103318:	39 d0                	cmp    %edx,%eax
8010331a:	73 15                	jae    80103331 <mpinit+0x101>
    switch(*p){
8010331c:	0f b6 08             	movzbl (%eax),%ecx
8010331f:	80 f9 02             	cmp    $0x2,%cl
80103322:	74 4c                	je     80103370 <mpinit+0x140>
80103324:	77 3a                	ja     80103360 <mpinit+0x130>
80103326:	84 c9                	test   %cl,%cl
80103328:	74 56                	je     80103380 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010332a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010332d:	39 d0                	cmp    %edx,%eax
8010332f:	72 eb                	jb     8010331c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103331:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103334:	85 f6                	test   %esi,%esi
80103336:	0f 84 d9 00 00 00    	je     80103415 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010333c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103340:	74 15                	je     80103357 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103342:	b8 70 00 00 00       	mov    $0x70,%eax
80103347:	ba 22 00 00 00       	mov    $0x22,%edx
8010334c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010334d:	ba 23 00 00 00       	mov    $0x23,%edx
80103352:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103353:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103356:	ee                   	out    %al,(%dx)
  }
}
80103357:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010335a:	5b                   	pop    %ebx
8010335b:	5e                   	pop    %esi
8010335c:	5f                   	pop    %edi
8010335d:	5d                   	pop    %ebp
8010335e:	c3                   	ret    
8010335f:	90                   	nop
    switch(*p){
80103360:	83 e9 03             	sub    $0x3,%ecx
80103363:	80 f9 01             	cmp    $0x1,%cl
80103366:	76 c2                	jbe    8010332a <mpinit+0xfa>
80103368:	31 f6                	xor    %esi,%esi
8010336a:	eb ac                	jmp    80103318 <mpinit+0xe8>
8010336c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103370:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103374:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103377:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010337d:	eb 99                	jmp    80103318 <mpinit+0xe8>
8010337f:	90                   	nop
      if(ncpu < NCPU) {
80103380:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103386:	83 f9 07             	cmp    $0x7,%ecx
80103389:	7f 19                	jg     801033a4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103391:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103395:	83 c1 01             	add    $0x1,%ecx
80103398:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010339e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
801033a4:	83 c0 14             	add    $0x14,%eax
      continue;
801033a7:	e9 6c ff ff ff       	jmp    80103318 <mpinit+0xe8>
801033ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033b0:	83 ec 0c             	sub    $0xc,%esp
801033b3:	68 02 7f 10 80       	push   $0x80107f02
801033b8:	e8 c3 cf ff ff       	call   80100380 <panic>
801033bd:	8d 76 00             	lea    0x0(%esi),%esi
{
801033c0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033c5:	eb 13                	jmp    801033da <mpinit+0x1aa>
801033c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ce:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033d0:	89 f3                	mov    %esi,%ebx
801033d2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033d8:	74 d6                	je     801033b0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033da:	83 ec 04             	sub    $0x4,%esp
801033dd:	8d 73 10             	lea    0x10(%ebx),%esi
801033e0:	6a 04                	push   $0x4
801033e2:	68 f8 7e 10 80       	push   $0x80107ef8
801033e7:	53                   	push   %ebx
801033e8:	e8 33 19 00 00       	call   80104d20 <memcmp>
801033ed:	83 c4 10             	add    $0x10,%esp
801033f0:	85 c0                	test   %eax,%eax
801033f2:	75 dc                	jne    801033d0 <mpinit+0x1a0>
801033f4:	89 da                	mov    %ebx,%edx
801033f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033fd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103400:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103403:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103406:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103408:	39 d6                	cmp    %edx,%esi
8010340a:	75 f4                	jne    80103400 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010340c:	84 c0                	test   %al,%al
8010340e:	75 c0                	jne    801033d0 <mpinit+0x1a0>
80103410:	e9 6b fe ff ff       	jmp    80103280 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103415:	83 ec 0c             	sub    $0xc,%esp
80103418:	68 1c 7f 10 80       	push   $0x80107f1c
8010341d:	e8 5e cf ff ff       	call   80100380 <panic>
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <picinit>:
80103430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103435:	ba 21 00 00 00       	mov    $0x21,%edx
8010343a:	ee                   	out    %al,(%dx)
8010343b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103440:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103441:	c3                   	ret    
80103442:	66 90                	xchg   %ax,%ax
80103444:	66 90                	xchg   %ax,%ax
80103446:	66 90                	xchg   %ax,%ax
80103448:	66 90                	xchg   %ax,%ax
8010344a:	66 90                	xchg   %ax,%ax
8010344c:	66 90                	xchg   %ax,%ax
8010344e:	66 90                	xchg   %ax,%ax

80103450 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103450:	55                   	push   %ebp
80103451:	89 e5                	mov    %esp,%ebp
80103453:	57                   	push   %edi
80103454:	56                   	push   %esi
80103455:	53                   	push   %ebx
80103456:	83 ec 0c             	sub    $0xc,%esp
80103459:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010345c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010345f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103465:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010346b:	e8 e0 d9 ff ff       	call   80100e50 <filealloc>
80103470:	89 03                	mov    %eax,(%ebx)
80103472:	85 c0                	test   %eax,%eax
80103474:	0f 84 a8 00 00 00    	je     80103522 <pipealloc+0xd2>
8010347a:	e8 d1 d9 ff ff       	call   80100e50 <filealloc>
8010347f:	89 06                	mov    %eax,(%esi)
80103481:	85 c0                	test   %eax,%eax
80103483:	0f 84 87 00 00 00    	je     80103510 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103489:	e8 12 f2 ff ff       	call   801026a0 <kalloc>
8010348e:	89 c7                	mov    %eax,%edi
80103490:	85 c0                	test   %eax,%eax
80103492:	0f 84 b0 00 00 00    	je     80103548 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103498:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010349f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034a2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034a5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034ac:	00 00 00 
  p->nwrite = 0;
801034af:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034b6:	00 00 00 
  p->nread = 0;
801034b9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034c0:	00 00 00 
  initlock(&p->lock, "pipe");
801034c3:	68 3b 7f 10 80       	push   $0x80107f3b
801034c8:	50                   	push   %eax
801034c9:	e8 72 15 00 00       	call   80104a40 <initlock>
  (*f0)->type = FD_PIPE;
801034ce:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034d0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034d9:	8b 03                	mov    (%ebx),%eax
801034db:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034df:	8b 03                	mov    (%ebx),%eax
801034e1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034e5:	8b 03                	mov    (%ebx),%eax
801034e7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ea:	8b 06                	mov    (%esi),%eax
801034ec:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034f2:	8b 06                	mov    (%esi),%eax
801034f4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034f8:	8b 06                	mov    (%esi),%eax
801034fa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034fe:	8b 06                	mov    (%esi),%eax
80103500:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103503:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103506:	31 c0                	xor    %eax,%eax
}
80103508:	5b                   	pop    %ebx
80103509:	5e                   	pop    %esi
8010350a:	5f                   	pop    %edi
8010350b:	5d                   	pop    %ebp
8010350c:	c3                   	ret    
8010350d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103510:	8b 03                	mov    (%ebx),%eax
80103512:	85 c0                	test   %eax,%eax
80103514:	74 1e                	je     80103534 <pipealloc+0xe4>
    fileclose(*f0);
80103516:	83 ec 0c             	sub    $0xc,%esp
80103519:	50                   	push   %eax
8010351a:	e8 f1 d9 ff ff       	call   80100f10 <fileclose>
8010351f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103522:	8b 06                	mov    (%esi),%eax
80103524:	85 c0                	test   %eax,%eax
80103526:	74 0c                	je     80103534 <pipealloc+0xe4>
    fileclose(*f1);
80103528:	83 ec 0c             	sub    $0xc,%esp
8010352b:	50                   	push   %eax
8010352c:	e8 df d9 ff ff       	call   80100f10 <fileclose>
80103531:	83 c4 10             	add    $0x10,%esp
}
80103534:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103537:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010353c:	5b                   	pop    %ebx
8010353d:	5e                   	pop    %esi
8010353e:	5f                   	pop    %edi
8010353f:	5d                   	pop    %ebp
80103540:	c3                   	ret    
80103541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103548:	8b 03                	mov    (%ebx),%eax
8010354a:	85 c0                	test   %eax,%eax
8010354c:	75 c8                	jne    80103516 <pipealloc+0xc6>
8010354e:	eb d2                	jmp    80103522 <pipealloc+0xd2>

80103550 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	56                   	push   %esi
80103554:	53                   	push   %ebx
80103555:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103558:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010355b:	83 ec 0c             	sub    $0xc,%esp
8010355e:	53                   	push   %ebx
8010355f:	e8 ac 16 00 00       	call   80104c10 <acquire>
  if(writable){
80103564:	83 c4 10             	add    $0x10,%esp
80103567:	85 f6                	test   %esi,%esi
80103569:	74 65                	je     801035d0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010356b:	83 ec 0c             	sub    $0xc,%esp
8010356e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103574:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010357b:	00 00 00 
    wakeup(&p->nread);
8010357e:	50                   	push   %eax
8010357f:	e8 5c 0c 00 00       	call   801041e0 <wakeup>
80103584:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103587:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010358d:	85 d2                	test   %edx,%edx
8010358f:	75 0a                	jne    8010359b <pipeclose+0x4b>
80103591:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103597:	85 c0                	test   %eax,%eax
80103599:	74 15                	je     801035b0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010359b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010359e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a1:	5b                   	pop    %ebx
801035a2:	5e                   	pop    %esi
801035a3:	5d                   	pop    %ebp
    release(&p->lock);
801035a4:	e9 07 16 00 00       	jmp    80104bb0 <release>
801035a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	53                   	push   %ebx
801035b4:	e8 f7 15 00 00       	call   80104bb0 <release>
    kfree((char*)p);
801035b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035bc:	83 c4 10             	add    $0x10,%esp
}
801035bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035c2:	5b                   	pop    %ebx
801035c3:	5e                   	pop    %esi
801035c4:	5d                   	pop    %ebp
    kfree((char*)p);
801035c5:	e9 16 ef ff ff       	jmp    801024e0 <kfree>
801035ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035e0:	00 00 00 
    wakeup(&p->nwrite);
801035e3:	50                   	push   %eax
801035e4:	e8 f7 0b 00 00       	call   801041e0 <wakeup>
801035e9:	83 c4 10             	add    $0x10,%esp
801035ec:	eb 99                	jmp    80103587 <pipeclose+0x37>
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	57                   	push   %edi
801035f4:	56                   	push   %esi
801035f5:	53                   	push   %ebx
801035f6:	83 ec 28             	sub    $0x28,%esp
801035f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035fc:	53                   	push   %ebx
801035fd:	e8 0e 16 00 00       	call   80104c10 <acquire>
  for(i = 0; i < n; i++){
80103602:	8b 45 10             	mov    0x10(%ebp),%eax
80103605:	83 c4 10             	add    $0x10,%esp
80103608:	85 c0                	test   %eax,%eax
8010360a:	0f 8e c0 00 00 00    	jle    801036d0 <pipewrite+0xe0>
80103610:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103613:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103619:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010361f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103622:	03 45 10             	add    0x10(%ebp),%eax
80103625:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103628:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010362e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103634:	89 ca                	mov    %ecx,%edx
80103636:	05 00 02 00 00       	add    $0x200,%eax
8010363b:	39 c1                	cmp    %eax,%ecx
8010363d:	74 3f                	je     8010367e <pipewrite+0x8e>
8010363f:	eb 67                	jmp    801036a8 <pipewrite+0xb8>
80103641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103648:	e8 e3 03 00 00       	call   80103a30 <myproc>
8010364d:	8b 48 24             	mov    0x24(%eax),%ecx
80103650:	85 c9                	test   %ecx,%ecx
80103652:	75 34                	jne    80103688 <pipewrite+0x98>
      wakeup(&p->nread);
80103654:	83 ec 0c             	sub    $0xc,%esp
80103657:	57                   	push   %edi
80103658:	e8 83 0b 00 00       	call   801041e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010365d:	58                   	pop    %eax
8010365e:	5a                   	pop    %edx
8010365f:	53                   	push   %ebx
80103660:	56                   	push   %esi
80103661:	e8 ba 0a 00 00       	call   80104120 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103666:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010366c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103672:	83 c4 10             	add    $0x10,%esp
80103675:	05 00 02 00 00       	add    $0x200,%eax
8010367a:	39 c2                	cmp    %eax,%edx
8010367c:	75 2a                	jne    801036a8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010367e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103684:	85 c0                	test   %eax,%eax
80103686:	75 c0                	jne    80103648 <pipewrite+0x58>
        release(&p->lock);
80103688:	83 ec 0c             	sub    $0xc,%esp
8010368b:	53                   	push   %ebx
8010368c:	e8 1f 15 00 00       	call   80104bb0 <release>
        return -1;
80103691:	83 c4 10             	add    $0x10,%esp
80103694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103699:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010369c:	5b                   	pop    %ebx
8010369d:	5e                   	pop    %esi
8010369e:	5f                   	pop    %edi
8010369f:	5d                   	pop    %ebp
801036a0:	c3                   	ret    
801036a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036ab:	8d 4a 01             	lea    0x1(%edx),%ecx
801036ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036b4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036ba:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801036bd:	83 c6 01             	add    $0x1,%esi
801036c0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036c3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036c7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036ca:	0f 85 58 ff ff ff    	jne    80103628 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036d0:	83 ec 0c             	sub    $0xc,%esp
801036d3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036d9:	50                   	push   %eax
801036da:	e8 01 0b 00 00       	call   801041e0 <wakeup>
  release(&p->lock);
801036df:	89 1c 24             	mov    %ebx,(%esp)
801036e2:	e8 c9 14 00 00       	call   80104bb0 <release>
  return n;
801036e7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ea:	83 c4 10             	add    $0x10,%esp
801036ed:	eb aa                	jmp    80103699 <pipewrite+0xa9>
801036ef:	90                   	nop

801036f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	57                   	push   %edi
801036f4:	56                   	push   %esi
801036f5:	53                   	push   %ebx
801036f6:	83 ec 18             	sub    $0x18,%esp
801036f9:	8b 75 08             	mov    0x8(%ebp),%esi
801036fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ff:	56                   	push   %esi
80103700:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103706:	e8 05 15 00 00       	call   80104c10 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010370b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103711:	83 c4 10             	add    $0x10,%esp
80103714:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010371a:	74 2f                	je     8010374b <piperead+0x5b>
8010371c:	eb 37                	jmp    80103755 <piperead+0x65>
8010371e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103720:	e8 0b 03 00 00       	call   80103a30 <myproc>
80103725:	8b 48 24             	mov    0x24(%eax),%ecx
80103728:	85 c9                	test   %ecx,%ecx
8010372a:	0f 85 80 00 00 00    	jne    801037b0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103730:	83 ec 08             	sub    $0x8,%esp
80103733:	56                   	push   %esi
80103734:	53                   	push   %ebx
80103735:	e8 e6 09 00 00       	call   80104120 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010373a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103740:	83 c4 10             	add    $0x10,%esp
80103743:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103749:	75 0a                	jne    80103755 <piperead+0x65>
8010374b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103751:	85 c0                	test   %eax,%eax
80103753:	75 cb                	jne    80103720 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103755:	8b 55 10             	mov    0x10(%ebp),%edx
80103758:	31 db                	xor    %ebx,%ebx
8010375a:	85 d2                	test   %edx,%edx
8010375c:	7f 20                	jg     8010377e <piperead+0x8e>
8010375e:	eb 2c                	jmp    8010378c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103760:	8d 48 01             	lea    0x1(%eax),%ecx
80103763:	25 ff 01 00 00       	and    $0x1ff,%eax
80103768:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010376e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103773:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103776:	83 c3 01             	add    $0x1,%ebx
80103779:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010377c:	74 0e                	je     8010378c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010377e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103784:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010378a:	75 d4                	jne    80103760 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010378c:	83 ec 0c             	sub    $0xc,%esp
8010378f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103795:	50                   	push   %eax
80103796:	e8 45 0a 00 00       	call   801041e0 <wakeup>
  release(&p->lock);
8010379b:	89 34 24             	mov    %esi,(%esp)
8010379e:	e8 0d 14 00 00       	call   80104bb0 <release>
  return i;
801037a3:	83 c4 10             	add    $0x10,%esp
}
801037a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a9:	89 d8                	mov    %ebx,%eax
801037ab:	5b                   	pop    %ebx
801037ac:	5e                   	pop    %esi
801037ad:	5f                   	pop    %edi
801037ae:	5d                   	pop    %ebp
801037af:	c3                   	ret    
      release(&p->lock);
801037b0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037b8:	56                   	push   %esi
801037b9:	e8 f2 13 00 00       	call   80104bb0 <release>
      return -1;
801037be:	83 c4 10             	add    $0x10,%esp
}
801037c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037c4:	89 d8                	mov    %ebx,%eax
801037c6:	5b                   	pop    %ebx
801037c7:	5e                   	pop    %esi
801037c8:	5f                   	pop    %edi
801037c9:	5d                   	pop    %ebp
801037ca:	c3                   	ret    
801037cb:	66 90                	xchg   %ax,%ax
801037cd:	66 90                	xchg   %ax,%ax
801037cf:	90                   	nop

801037d0 <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801037d5:	eb 17                	jmp    801037ee <wakeup1+0x1e>
801037d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037de:	66 90                	xchg   %ax,%ax
801037e0:	81 c2 90 00 00 00    	add    $0x90,%edx
801037e6:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
801037ec:	74 20                	je     8010380e <wakeup1+0x3e>
    if(p->state == SLEEPING && p->chan == chan){
801037ee:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
801037f2:	75 ec                	jne    801037e0 <wakeup1+0x10>
801037f4:	39 42 20             	cmp    %eax,0x20(%edx)
801037f7:	75 e7                	jne    801037e0 <wakeup1+0x10>
      p->state = RUNNABLE;
801037f9:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103800:	81 c2 90 00 00 00    	add    $0x90,%edx
80103806:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
8010380c:	75 e0                	jne    801037ee <wakeup1+0x1e>
    }
}
8010380e:	c3                   	ret    
8010380f:	90                   	nop

80103810 <allocproc>:
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	56                   	push   %esi
80103814:	89 c6                	mov    %eax,%esi
80103816:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103817:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  acquire(&ptable.lock);
8010381c:	83 ec 0c             	sub    $0xc,%esp
8010381f:	68 20 2d 11 80       	push   $0x80112d20
80103824:	e8 e7 13 00 00       	call   80104c10 <acquire>
80103829:	83 c4 10             	add    $0x10,%esp
8010382c:	eb 14                	jmp    80103842 <allocproc+0x32>
8010382e:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103830:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103836:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
8010383c:	0f 84 ce 00 00 00    	je     80103910 <allocproc+0x100>
    if(p->state == UNUSED)
80103842:	8b 43 0c             	mov    0xc(%ebx),%eax
80103845:	85 c0                	test   %eax,%eax
80103847:	75 e7                	jne    80103830 <allocproc+0x20>
  p->state = EMBRYO;
80103849:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->mthread = p;
80103850:	89 9b 88 00 00 00    	mov    %ebx,0x88(%ebx)
  p->tno = 1;
80103856:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
  p->nexttid = 1;
8010385d:	c7 83 80 00 00 00 01 	movl   $0x1,0x80(%ebx)
80103864:	00 00 00 
  if (creator){
80103867:	85 f6                	test   %esi,%esi
80103869:	74 7d                	je     801038e8 <allocproc+0xd8>
    p->pid = creator->pid;
8010386b:	8b 46 10             	mov    0x10(%esi),%eax
8010386e:	89 43 10             	mov    %eax,0x10(%ebx)
    p->tid = (creator->nexttid)++;
80103871:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
80103877:	8d 50 01             	lea    0x1(%eax),%edx
8010387a:	89 96 80 00 00 00    	mov    %edx,0x80(%esi)
  release(&ptable.lock);
80103880:	83 ec 0c             	sub    $0xc,%esp
    p->tid = (creator->nexttid)++;
80103883:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  release(&ptable.lock);
80103889:	68 20 2d 11 80       	push   $0x80112d20
8010388e:	e8 1d 13 00 00       	call   80104bb0 <release>
  if((p->kstack = kalloc()) == 0){
80103893:	e8 08 ee ff ff       	call   801026a0 <kalloc>
80103898:	83 c4 10             	add    $0x10,%esp
8010389b:	89 43 08             	mov    %eax,0x8(%ebx)
8010389e:	85 c0                	test   %eax,%eax
801038a0:	0f 84 85 00 00 00    	je     8010392b <allocproc+0x11b>
  sp -= sizeof *p->tf;
801038a6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
801038ac:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801038af:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801038b4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801038b7:	c7 40 14 47 60 10 80 	movl   $0x80106047,0x14(%eax)
  p->context = (struct context*)sp;
801038be:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038c1:	6a 14                	push   $0x14
801038c3:	6a 00                	push   $0x0
801038c5:	50                   	push   %eax
801038c6:	e8 05 14 00 00       	call   80104cd0 <memset>
  p->context->eip = (uint)forkret;
801038cb:	8b 43 1c             	mov    0x1c(%ebx),%eax
  return p;
801038ce:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038d1:	c7 40 10 40 39 10 80 	movl   $0x80103940,0x10(%eax)
}
801038d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038db:	89 d8                	mov    %ebx,%eax
801038dd:	5b                   	pop    %ebx
801038de:	5e                   	pop    %esi
801038df:	5d                   	pop    %ebp
801038e0:	c3                   	ret    
801038e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->tid = (p->nexttid)++;
801038e8:	c7 83 80 00 00 00 02 	movl   $0x2,0x80(%ebx)
801038ef:	00 00 00 
    p->pid = nextpid++;
801038f2:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801038f7:	8d 50 01             	lea    0x1(%eax),%edx
801038fa:	89 43 10             	mov    %eax,0x10(%ebx)
    p->tid = (p->nexttid)++;
801038fd:	b8 01 00 00 00       	mov    $0x1,%eax
    p->pid = nextpid++;
80103902:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80103908:	e9 73 ff ff ff       	jmp    80103880 <allocproc+0x70>
8010390d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103910:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103913:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103915:	68 20 2d 11 80       	push   $0x80112d20
8010391a:	e8 91 12 00 00       	call   80104bb0 <release>
  return 0;
8010391f:	83 c4 10             	add    $0x10,%esp
}
80103922:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103925:	89 d8                	mov    %ebx,%eax
80103927:	5b                   	pop    %ebx
80103928:	5e                   	pop    %esi
80103929:	5d                   	pop    %ebp
8010392a:	c3                   	ret    
    p->state = UNUSED;
8010392b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
}
80103932:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80103935:	31 db                	xor    %ebx,%ebx
}
80103937:	89 d8                	mov    %ebx,%eax
80103939:	5b                   	pop    %ebx
8010393a:	5e                   	pop    %esi
8010393b:	5d                   	pop    %ebp
8010393c:	c3                   	ret    
8010393d:	8d 76 00             	lea    0x0(%esi),%esi

80103940 <forkret>:
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
80103946:	68 20 2d 11 80       	push   $0x80112d20
8010394b:	e8 60 12 00 00       	call   80104bb0 <release>
  if (first) {
80103950:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	85 c0                	test   %eax,%eax
8010395a:	75 04                	jne    80103960 <forkret+0x20>
}
8010395c:	c9                   	leave  
8010395d:	c3                   	ret    
8010395e:	66 90                	xchg   %ax,%ax
    first = 0;
80103960:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103967:	00 00 00 
    iinit(ROOTDEV);
8010396a:	83 ec 0c             	sub    $0xc,%esp
8010396d:	6a 01                	push   $0x1
8010396f:	e8 0c dc ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
80103974:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010397b:	e8 60 f3 ff ff       	call   80102ce0 <initlog>
}
80103980:	83 c4 10             	add    $0x10,%esp
80103983:	c9                   	leave  
80103984:	c3                   	ret    
80103985:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010398c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103990 <pinit>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103996:	68 40 7f 10 80       	push   $0x80107f40
8010399b:	68 20 2d 11 80       	push   $0x80112d20
801039a0:	e8 9b 10 00 00       	call   80104a40 <initlock>
}
801039a5:	83 c4 10             	add    $0x10,%esp
801039a8:	c9                   	leave  
801039a9:	c3                   	ret    
801039aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039b0 <mycpu>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	56                   	push   %esi
801039b4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039b5:	9c                   	pushf  
801039b6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039b7:	f6 c4 02             	test   $0x2,%ah
801039ba:	75 46                	jne    80103a02 <mycpu+0x52>
  apicid = lapicid();
801039bc:	e8 4f ef ff ff       	call   80102910 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039c1:	8b 35 84 27 11 80    	mov    0x80112784,%esi
801039c7:	85 f6                	test   %esi,%esi
801039c9:	7e 2a                	jle    801039f5 <mycpu+0x45>
801039cb:	31 d2                	xor    %edx,%edx
801039cd:	eb 08                	jmp    801039d7 <mycpu+0x27>
801039cf:	90                   	nop
801039d0:	83 c2 01             	add    $0x1,%edx
801039d3:	39 f2                	cmp    %esi,%edx
801039d5:	74 1e                	je     801039f5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801039d7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039dd:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
801039e4:	39 c3                	cmp    %eax,%ebx
801039e6:	75 e8                	jne    801039d0 <mycpu+0x20>
}
801039e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039eb:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
801039f1:	5b                   	pop    %ebx
801039f2:	5e                   	pop    %esi
801039f3:	5d                   	pop    %ebp
801039f4:	c3                   	ret    
  panic("unknown apicid\n");
801039f5:	83 ec 0c             	sub    $0xc,%esp
801039f8:	68 47 7f 10 80       	push   $0x80107f47
801039fd:	e8 7e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a02:	83 ec 0c             	sub    $0xc,%esp
80103a05:	68 28 80 10 80       	push   $0x80108028
80103a0a:	e8 71 c9 ff ff       	call   80100380 <panic>
80103a0f:	90                   	nop

80103a10 <cpuid>:
cpuid() {
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a16:	e8 95 ff ff ff       	call   801039b0 <mycpu>
}
80103a1b:	c9                   	leave  
  return mycpu()-cpus;
80103a1c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103a21:	c1 f8 04             	sar    $0x4,%eax
80103a24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a2a:	c3                   	ret    
80103a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a2f:	90                   	nop

80103a30 <myproc>:
myproc(void) {
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	53                   	push   %ebx
80103a34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a37:	e8 84 10 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
80103a3c:	e8 6f ff ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103a41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a47:	e8 c4 10 00 00       	call   80104b10 <popcli>
}
80103a4c:	89 d8                	mov    %ebx,%eax
80103a4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a51:	c9                   	leave  
80103a52:	c3                   	ret    
80103a53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a60 <userinit>:
{
80103a60:	55                   	push   %ebp
  p = allocproc(0);
80103a61:	31 c0                	xor    %eax,%eax
{
80103a63:	89 e5                	mov    %esp,%ebp
80103a65:	53                   	push   %ebx
80103a66:	83 ec 04             	sub    $0x4,%esp
  p = allocproc(0);
80103a69:	e8 a2 fd ff ff       	call   80103810 <allocproc>
80103a6e:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a70:	a3 54 51 11 80       	mov    %eax,0x80115154
  if((p->pgdir = setupkvm()) == 0)
80103a75:	e8 36 3c 00 00       	call   801076b0 <setupkvm>
80103a7a:	89 43 04             	mov    %eax,0x4(%ebx)
80103a7d:	85 c0                	test   %eax,%eax
80103a7f:	0f 84 bd 00 00 00    	je     80103b42 <userinit+0xe2>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a85:	83 ec 04             	sub    $0x4,%esp
80103a88:	68 2c 00 00 00       	push   $0x2c
80103a8d:	68 60 b4 10 80       	push   $0x8010b460
80103a92:	50                   	push   %eax
80103a93:	e8 c8 38 00 00       	call   80107360 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a98:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a9b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103aa1:	6a 4c                	push   $0x4c
80103aa3:	6a 00                	push   $0x0
80103aa5:	ff 73 18             	push   0x18(%ebx)
80103aa8:	e8 23 12 00 00       	call   80104cd0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103aad:	8b 43 18             	mov    0x18(%ebx),%eax
80103ab0:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ab5:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ab8:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103abd:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ac1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac4:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ac8:	8b 43 18             	mov    0x18(%ebx),%eax
80103acb:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103acf:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ad3:	8b 43 18             	mov    0x18(%ebx),%eax
80103ad6:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ada:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103ade:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae1:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ae8:	8b 43 18             	mov    0x18(%ebx),%eax
80103aeb:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103af2:	8b 43 18             	mov    0x18(%ebx),%eax
80103af5:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103afc:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103aff:	6a 10                	push   $0x10
80103b01:	68 70 7f 10 80       	push   $0x80107f70
80103b06:	50                   	push   %eax
80103b07:	e8 84 13 00 00       	call   80104e90 <safestrcpy>
  p->cwd = namei("/");
80103b0c:	c7 04 24 79 7f 10 80 	movl   $0x80107f79,(%esp)
80103b13:	e8 a8 e5 ff ff       	call   801020c0 <namei>
80103b18:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b1b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b22:	e8 e9 10 00 00       	call   80104c10 <acquire>
  p->state = RUNNABLE;
80103b27:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b2e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b35:	e8 76 10 00 00       	call   80104bb0 <release>
}
80103b3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b3d:	83 c4 10             	add    $0x10,%esp
80103b40:	c9                   	leave  
80103b41:	c3                   	ret    
    panic("userinit: out of memory?");
80103b42:	83 ec 0c             	sub    $0xc,%esp
80103b45:	68 57 7f 10 80       	push   $0x80107f57
80103b4a:	e8 31 c8 ff ff       	call   80100380 <panic>
80103b4f:	90                   	nop

80103b50 <growproc>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	56                   	push   %esi
80103b54:	53                   	push   %ebx
80103b55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b58:	e8 63 0f 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
80103b5d:	e8 4e fe ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103b62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b68:	e8 a3 0f 00 00       	call   80104b10 <popcli>
  sz = curproc->mthread->sz;
80103b6d:	8b 93 88 00 00 00    	mov    0x88(%ebx),%edx
80103b73:	8b 02                	mov    (%edx),%eax
  if(n > 0){
80103b75:	85 f6                	test   %esi,%esi
80103b77:	7f 1f                	jg     80103b98 <growproc+0x48>
  } else if(n < 0){
80103b79:	75 45                	jne    80103bc0 <growproc+0x70>
  switchuvm(curproc);
80103b7b:	83 ec 0c             	sub    $0xc,%esp
  curproc->mthread->sz = sz;
80103b7e:	89 02                	mov    %eax,(%edx)
  switchuvm(curproc);
80103b80:	53                   	push   %ebx
80103b81:	e8 ca 36 00 00       	call   80107250 <switchuvm>
  return 0;
80103b86:	83 c4 10             	add    $0x10,%esp
80103b89:	31 c0                	xor    %eax,%eax
}
80103b8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b8e:	5b                   	pop    %ebx
80103b8f:	5e                   	pop    %esi
80103b90:	5d                   	pop    %ebp
80103b91:	c3                   	ret    
80103b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b98:	83 ec 04             	sub    $0x4,%esp
80103b9b:	01 c6                	add    %eax,%esi
80103b9d:	56                   	push   %esi
80103b9e:	50                   	push   %eax
80103b9f:	ff 73 04             	push   0x4(%ebx)
80103ba2:	e8 29 39 00 00       	call   801074d0 <allocuvm>
80103ba7:	83 c4 10             	add    $0x10,%esp
80103baa:	85 c0                	test   %eax,%eax
80103bac:	74 28                	je     80103bd6 <growproc+0x86>
  curproc->mthread->sz = sz;
80103bae:	8b 93 88 00 00 00    	mov    0x88(%ebx),%edx
80103bb4:	eb c5                	jmp    80103b7b <growproc+0x2b>
80103bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bc0:	83 ec 04             	sub    $0x4,%esp
80103bc3:	01 c6                	add    %eax,%esi
80103bc5:	56                   	push   %esi
80103bc6:	50                   	push   %eax
80103bc7:	ff 73 04             	push   0x4(%ebx)
80103bca:	e8 31 3a 00 00       	call   80107600 <deallocuvm>
80103bcf:	83 c4 10             	add    $0x10,%esp
80103bd2:	85 c0                	test   %eax,%eax
80103bd4:	75 d8                	jne    80103bae <growproc+0x5e>
      return -1;
80103bd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bdb:	eb ae                	jmp    80103b8b <growproc+0x3b>
80103bdd:	8d 76 00             	lea    0x0(%esi),%esi

80103be0 <fork>:
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	57                   	push   %edi
80103be4:	56                   	push   %esi
80103be5:	53                   	push   %ebx
80103be6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103be9:	e8 d2 0e 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
80103bee:	e8 bd fd ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103bf3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bf9:	e8 12 0f 00 00       	call   80104b10 <popcli>
  if((np = allocproc(0)) == 0){
80103bfe:	31 c0                	xor    %eax,%eax
80103c00:	e8 0b fc ff ff       	call   80103810 <allocproc>
80103c05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c08:	85 c0                	test   %eax,%eax
80103c0a:	0f 84 c5 00 00 00    	je     80103cd5 <fork+0xf5>
80103c10:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->mthread->sz)) == 0){
80103c12:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103c18:	83 ec 08             	sub    $0x8,%esp
80103c1b:	ff 30                	push   (%eax)
80103c1d:	ff 73 04             	push   0x4(%ebx)
80103c20:	e8 7b 3b 00 00       	call   801077a0 <copyuvm>
80103c25:	83 c4 10             	add    $0x10,%esp
80103c28:	89 47 04             	mov    %eax,0x4(%edi)
80103c2b:	85 c0                	test   %eax,%eax
80103c2d:	0f 84 a9 00 00 00    	je     80103cdc <fork+0xfc>
  np->sz = curproc->mthread->sz;
80103c33:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103c39:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c3c:	8b 00                	mov    (%eax),%eax
  *np->tf = *curproc->tf;
80103c3e:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c41:	89 59 14             	mov    %ebx,0x14(%ecx)
  np->sz = curproc->mthread->sz;
80103c44:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103c46:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103c48:	8b 73 18             	mov    0x18(%ebx),%esi
80103c4b:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c50:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c52:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c54:	8b 40 18             	mov    0x18(%eax),%eax
80103c57:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103c5e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80103c60:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c64:	85 c0                	test   %eax,%eax
80103c66:	74 13                	je     80103c7b <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c68:	83 ec 0c             	sub    $0xc,%esp
80103c6b:	50                   	push   %eax
80103c6c:	e8 4f d2 ff ff       	call   80100ec0 <filedup>
80103c71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c74:	83 c4 10             	add    $0x10,%esp
80103c77:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c7b:	83 c6 01             	add    $0x1,%esi
80103c7e:	83 fe 10             	cmp    $0x10,%esi
80103c81:	75 dd                	jne    80103c60 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103c83:	83 ec 0c             	sub    $0xc,%esp
80103c86:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c89:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c8c:	e8 df da ff ff       	call   80101770 <idup>
80103c91:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c94:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c97:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c9a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c9d:	6a 10                	push   $0x10
80103c9f:	53                   	push   %ebx
80103ca0:	50                   	push   %eax
80103ca1:	e8 ea 11 00 00       	call   80104e90 <safestrcpy>
  pid = np->pid;
80103ca6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103ca9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cb0:	e8 5b 0f 00 00       	call   80104c10 <acquire>
  np->state = RUNNABLE;
80103cb5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103cbc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cc3:	e8 e8 0e 00 00       	call   80104bb0 <release>
  return pid;
80103cc8:	83 c4 10             	add    $0x10,%esp
}
80103ccb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cce:	89 d8                	mov    %ebx,%eax
80103cd0:	5b                   	pop    %ebx
80103cd1:	5e                   	pop    %esi
80103cd2:	5f                   	pop    %edi
80103cd3:	5d                   	pop    %ebp
80103cd4:	c3                   	ret    
    return -1;
80103cd5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cda:	eb ef                	jmp    80103ccb <fork+0xeb>
    kfree(np->kstack);
80103cdc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103cdf:	83 ec 0c             	sub    $0xc,%esp
80103ce2:	ff 73 08             	push   0x8(%ebx)
80103ce5:	e8 f6 e7 ff ff       	call   801024e0 <kfree>
    np->kstack = 0;
80103cea:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103cf1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103cf4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103cfb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d00:	eb c9                	jmp    80103ccb <fork+0xeb>
80103d02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d10 <scheduler>:
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	57                   	push   %edi
80103d14:	56                   	push   %esi
80103d15:	53                   	push   %ebx
80103d16:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d19:	e8 92 fc ff ff       	call   801039b0 <mycpu>
  c->proc = 0;
80103d1e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d25:	00 00 00 
  struct cpu *c = mycpu();
80103d28:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d2a:	8d 78 04             	lea    0x4(%eax),%edi
80103d2d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d30:	fb                   	sti    
    acquire(&ptable.lock);
80103d31:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d34:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103d39:	68 20 2d 11 80       	push   $0x80112d20
80103d3e:	e8 cd 0e 00 00       	call   80104c10 <acquire>
80103d43:	83 c4 10             	add    $0x10,%esp
80103d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d4d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103d50:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d54:	75 33                	jne    80103d89 <scheduler+0x79>
      switchuvm(p);
80103d56:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d59:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d5f:	53                   	push   %ebx
80103d60:	e8 eb 34 00 00       	call   80107250 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d65:	58                   	pop    %eax
80103d66:	5a                   	pop    %edx
80103d67:	ff 73 1c             	push   0x1c(%ebx)
80103d6a:	57                   	push   %edi
      p->state = RUNNING;
80103d6b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d72:	e8 74 11 00 00       	call   80104eeb <swtch>
      switchkvm();
80103d77:	e8 c4 34 00 00       	call   80107240 <switchkvm>
      c->proc = 0;
80103d7c:	83 c4 10             	add    $0x10,%esp
80103d7f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d86:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d89:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103d8f:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80103d95:	75 b9                	jne    80103d50 <scheduler+0x40>
    release(&ptable.lock);
80103d97:	83 ec 0c             	sub    $0xc,%esp
80103d9a:	68 20 2d 11 80       	push   $0x80112d20
80103d9f:	e8 0c 0e 00 00       	call   80104bb0 <release>
    sti();
80103da4:	83 c4 10             	add    $0x10,%esp
80103da7:	eb 87                	jmp    80103d30 <scheduler+0x20>
80103da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103db0 <sched>:
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	56                   	push   %esi
80103db4:	53                   	push   %ebx
  pushcli();
80103db5:	e8 06 0d 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
80103dba:	e8 f1 fb ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103dbf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dc5:	e8 46 0d 00 00       	call   80104b10 <popcli>
  if(!holding(&ptable.lock))
80103dca:	83 ec 0c             	sub    $0xc,%esp
80103dcd:	68 20 2d 11 80       	push   $0x80112d20
80103dd2:	e8 99 0d 00 00       	call   80104b70 <holding>
80103dd7:	83 c4 10             	add    $0x10,%esp
80103dda:	85 c0                	test   %eax,%eax
80103ddc:	74 4f                	je     80103e2d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103dde:	e8 cd fb ff ff       	call   801039b0 <mycpu>
80103de3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103dea:	75 68                	jne    80103e54 <sched+0xa4>
  if(p->state == RUNNING)
80103dec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103df0:	74 55                	je     80103e47 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103df2:	9c                   	pushf  
80103df3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103df4:	f6 c4 02             	test   $0x2,%ah
80103df7:	75 41                	jne    80103e3a <sched+0x8a>
  intena = mycpu()->intena;
80103df9:	e8 b2 fb ff ff       	call   801039b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dfe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e01:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e07:	e8 a4 fb ff ff       	call   801039b0 <mycpu>
80103e0c:	83 ec 08             	sub    $0x8,%esp
80103e0f:	ff 70 04             	push   0x4(%eax)
80103e12:	53                   	push   %ebx
80103e13:	e8 d3 10 00 00       	call   80104eeb <swtch>
  mycpu()->intena = intena;
80103e18:	e8 93 fb ff ff       	call   801039b0 <mycpu>
}
80103e1d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e20:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e29:	5b                   	pop    %ebx
80103e2a:	5e                   	pop    %esi
80103e2b:	5d                   	pop    %ebp
80103e2c:	c3                   	ret    
    panic("sched ptable.lock");
80103e2d:	83 ec 0c             	sub    $0xc,%esp
80103e30:	68 7b 7f 10 80       	push   $0x80107f7b
80103e35:	e8 46 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103e3a:	83 ec 0c             	sub    $0xc,%esp
80103e3d:	68 a7 7f 10 80       	push   $0x80107fa7
80103e42:	e8 39 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103e47:	83 ec 0c             	sub    $0xc,%esp
80103e4a:	68 99 7f 10 80       	push   $0x80107f99
80103e4f:	e8 2c c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103e54:	83 ec 0c             	sub    $0xc,%esp
80103e57:	68 8d 7f 10 80       	push   $0x80107f8d
80103e5c:	e8 1f c5 ff ff       	call   80100380 <panic>
80103e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e6f:	90                   	nop

80103e70 <thread_exit>:

// Exit the current thread and pass the retval.
// Deallocating the resources will be done at thread_join().
void 
thread_exit(void *retval)
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	57                   	push   %edi
80103e74:	56                   	push   %esi
80103e75:	53                   	push   %ebx
80103e76:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e79:	e8 b2 fb ff ff       	call   80103a30 <myproc>
80103e7e:	89 c3                	mov    %eax,%ebx
  struct proc *p;
  int fd;

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103e80:	8d 70 28             	lea    0x28(%eax),%esi
80103e83:	8d 78 68             	lea    0x68(%eax),%edi
80103e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e90:	8b 06                	mov    (%esi),%eax
80103e92:	85 c0                	test   %eax,%eax
80103e94:	74 12                	je     80103ea8 <thread_exit+0x38>
      fileclose(curproc->ofile[fd]);
80103e96:	83 ec 0c             	sub    $0xc,%esp
80103e99:	50                   	push   %eax
80103e9a:	e8 71 d0 ff ff       	call   80100f10 <fileclose>
      curproc->ofile[fd] = 0;
80103e9f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ea5:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103ea8:	83 c6 04             	add    $0x4,%esi
80103eab:	39 fe                	cmp    %edi,%esi
80103ead:	75 e1                	jne    80103e90 <thread_exit+0x20>
    }
  }

  begin_op();
80103eaf:	e8 cc ee ff ff       	call   80102d80 <begin_op>
  iput(curproc->cwd);
80103eb4:	83 ec 0c             	sub    $0xc,%esp
80103eb7:	ff 73 68             	push   0x68(%ebx)
80103eba:	e8 11 da ff ff       	call   801018d0 <iput>
  end_op();
80103ebf:	e8 2c ef ff ff       	call   80102df0 <end_op>
  curproc->cwd = 0;
80103ec4:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

  acquire(&ptable.lock);
80103ecb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ed2:	e8 39 0d 00 00       	call   80104c10 <acquire>
  (curproc->mthread->tno)--;
80103ed7:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103edd:	83 68 7c 01          	subl   $0x1,0x7c(%eax)

  // Main process might be sleeping in thread_join().
  wakeup1(curproc->mthread);
80103ee1:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103ee7:	e8 e4 f8 ff ff       	call   801037d0 <wakeup1>

  // Save the return value to thread_join().
  curproc->retval = retval;
80103eec:	8b 45 08             	mov    0x8(%ebp),%eax

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103eef:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef2:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
      p->parent = initproc;
80103ef7:	8b 0d 54 51 11 80    	mov    0x80115154,%ecx
  curproc->retval = retval;
80103efd:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f03:	eb 11                	jmp    80103f16 <thread_exit+0xa6>
80103f05:	8d 76 00             	lea    0x0(%esi),%esi
80103f08:	81 c2 90 00 00 00    	add    $0x90,%edx
80103f0e:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103f14:	74 3a                	je     80103f50 <thread_exit+0xe0>
    if(p->parent == curproc){
80103f16:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f19:	75 ed                	jne    80103f08 <thread_exit+0x98>
      if(p->state == ZOMBIE)
80103f1b:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f1f:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f22:	75 e4                	jne    80103f08 <thread_exit+0x98>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f24:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f29:	eb 11                	jmp    80103f3c <thread_exit+0xcc>
80103f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f2f:	90                   	nop
80103f30:	05 90 00 00 00       	add    $0x90,%eax
80103f35:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80103f3a:	74 cc                	je     80103f08 <thread_exit+0x98>
    if(p->state == SLEEPING && p->chan == chan){
80103f3c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f40:	75 ee                	jne    80103f30 <thread_exit+0xc0>
80103f42:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f45:	75 e9                	jne    80103f30 <thread_exit+0xc0>
      p->state = RUNNABLE;
80103f47:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f4e:	eb e0                	jmp    80103f30 <thread_exit+0xc0>
        wakeup1(initproc);
    }
  }
  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103f50:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103f57:	e8 54 fe ff ff       	call   80103db0 <sched>
  panic("zombie exit");
80103f5c:	83 ec 0c             	sub    $0xc,%esp
80103f5f:	68 bb 7f 10 80       	push   $0x80107fbb
80103f64:	e8 17 c4 ff ff       	call   80100380 <panic>
80103f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f70 <wait>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	56                   	push   %esi
80103f74:	53                   	push   %ebx
  pushcli();
80103f75:	e8 46 0b 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
80103f7a:	e8 31 fa ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103f7f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f85:	e8 86 0b 00 00       	call   80104b10 <popcli>
  acquire(&ptable.lock);
80103f8a:	83 ec 0c             	sub    $0xc,%esp
80103f8d:	68 20 2d 11 80       	push   $0x80112d20
80103f92:	e8 79 0c 00 00       	call   80104c10 <acquire>
80103f97:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f9a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f9c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103fa1:	eb 13                	jmp    80103fb6 <wait+0x46>
80103fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fa7:	90                   	nop
80103fa8:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103fae:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80103fb4:	74 1e                	je     80103fd4 <wait+0x64>
      if(p->parent != curproc)
80103fb6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fb9:	75 ed                	jne    80103fa8 <wait+0x38>
      if(p->state == ZOMBIE){
80103fbb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fbf:	74 5f                	je     80104020 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fc1:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
80103fc7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fcc:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80103fd2:	75 e2                	jne    80103fb6 <wait+0x46>
    if(!havekids || curproc->killed){
80103fd4:	85 c0                	test   %eax,%eax
80103fd6:	0f 84 c1 00 00 00    	je     8010409d <wait+0x12d>
80103fdc:	8b 46 24             	mov    0x24(%esi),%eax
80103fdf:	85 c0                	test   %eax,%eax
80103fe1:	0f 85 b6 00 00 00    	jne    8010409d <wait+0x12d>
  pushcli();
80103fe7:	e8 d4 0a 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
80103fec:	e8 bf f9 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103ff1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ff7:	e8 14 0b 00 00       	call   80104b10 <popcli>
  if(p == 0)
80103ffc:	85 db                	test   %ebx,%ebx
80103ffe:	0f 84 b0 00 00 00    	je     801040b4 <wait+0x144>
  p->chan = chan;
80104004:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104007:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010400e:	e8 9d fd ff ff       	call   80103db0 <sched>
  p->chan = 0;
80104013:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010401a:	e9 7b ff ff ff       	jmp    80103f9a <wait+0x2a>
8010401f:	90                   	nop
        if (p->mthread->tno == 1){
80104020:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
        pid = p->pid;
80104026:	8b 73 10             	mov    0x10(%ebx),%esi
        if (p->mthread->tno == 1){
80104029:	83 78 7c 01          	cmpl   $0x1,0x7c(%eax)
8010402d:	74 5e                	je     8010408d <wait+0x11d>
        kfree(p->kstack);
8010402f:	83 ec 0c             	sub    $0xc,%esp
80104032:	ff 73 08             	push   0x8(%ebx)
80104035:	e8 a6 e4 ff ff       	call   801024e0 <kfree>
        p->kstack = 0;
8010403a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        p->pid = 0;
80104041:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->tid = 0;
80104048:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010404f:	00 00 00 
        p->nexttid = 0;
80104052:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104059:	00 00 00 
        p->parent = 0;
8010405c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104063:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104067:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010406e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104075:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010407c:	e8 2f 0b 00 00       	call   80104bb0 <release>
        return pid;
80104081:	83 c4 10             	add    $0x10,%esp
}
80104084:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104087:	89 f0                	mov    %esi,%eax
80104089:	5b                   	pop    %ebx
8010408a:	5e                   	pop    %esi
8010408b:	5d                   	pop    %ebp
8010408c:	c3                   	ret    
          freevm(p->pgdir);
8010408d:	83 ec 0c             	sub    $0xc,%esp
80104090:	ff 73 04             	push   0x4(%ebx)
80104093:	e8 98 35 00 00       	call   80107630 <freevm>
80104098:	83 c4 10             	add    $0x10,%esp
8010409b:	eb 92                	jmp    8010402f <wait+0xbf>
      release(&ptable.lock);
8010409d:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801040a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801040a5:	68 20 2d 11 80       	push   $0x80112d20
801040aa:	e8 01 0b 00 00       	call   80104bb0 <release>
      return -1;
801040af:	83 c4 10             	add    $0x10,%esp
801040b2:	eb d0                	jmp    80104084 <wait+0x114>
    panic("sleep");
801040b4:	83 ec 0c             	sub    $0xc,%esp
801040b7:	68 c7 7f 10 80       	push   $0x80107fc7
801040bc:	e8 bf c2 ff ff       	call   80100380 <panic>
801040c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040cf:	90                   	nop

801040d0 <yield>:
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	53                   	push   %ebx
801040d4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040d7:	68 20 2d 11 80       	push   $0x80112d20
801040dc:	e8 2f 0b 00 00       	call   80104c10 <acquire>
  pushcli();
801040e1:	e8 da 09 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
801040e6:	e8 c5 f8 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
801040eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040f1:	e8 1a 0a 00 00       	call   80104b10 <popcli>
  myproc()->state = RUNNABLE;
801040f6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040fd:	e8 ae fc ff ff       	call   80103db0 <sched>
  release(&ptable.lock);
80104102:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104109:	e8 a2 0a 00 00       	call   80104bb0 <release>
}
8010410e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104111:	83 c4 10             	add    $0x10,%esp
80104114:	c9                   	leave  
80104115:	c3                   	ret    
80104116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010411d:	8d 76 00             	lea    0x0(%esi),%esi

80104120 <sleep>:
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	57                   	push   %edi
80104124:	56                   	push   %esi
80104125:	53                   	push   %ebx
80104126:	83 ec 0c             	sub    $0xc,%esp
80104129:	8b 7d 08             	mov    0x8(%ebp),%edi
8010412c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010412f:	e8 8c 09 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
80104134:	e8 77 f8 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80104139:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010413f:	e8 cc 09 00 00       	call   80104b10 <popcli>
  if(p == 0)
80104144:	85 db                	test   %ebx,%ebx
80104146:	0f 84 87 00 00 00    	je     801041d3 <sleep+0xb3>
  if(lk == 0)
8010414c:	85 f6                	test   %esi,%esi
8010414e:	74 76                	je     801041c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104150:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104156:	74 50                	je     801041a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104158:	83 ec 0c             	sub    $0xc,%esp
8010415b:	68 20 2d 11 80       	push   $0x80112d20
80104160:	e8 ab 0a 00 00       	call   80104c10 <acquire>
    release(lk);
80104165:	89 34 24             	mov    %esi,(%esp)
80104168:	e8 43 0a 00 00       	call   80104bb0 <release>
  p->chan = chan;
8010416d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104170:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104177:	e8 34 fc ff ff       	call   80103db0 <sched>
  p->chan = 0;
8010417c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104183:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010418a:	e8 21 0a 00 00       	call   80104bb0 <release>
    acquire(lk);
8010418f:	89 75 08             	mov    %esi,0x8(%ebp)
80104192:	83 c4 10             	add    $0x10,%esp
}
80104195:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104198:	5b                   	pop    %ebx
80104199:	5e                   	pop    %esi
8010419a:	5f                   	pop    %edi
8010419b:	5d                   	pop    %ebp
    acquire(lk);
8010419c:	e9 6f 0a 00 00       	jmp    80104c10 <acquire>
801041a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801041a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041b2:	e8 f9 fb ff ff       	call   80103db0 <sched>
  p->chan = 0;
801041b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801041be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041c1:	5b                   	pop    %ebx
801041c2:	5e                   	pop    %esi
801041c3:	5f                   	pop    %edi
801041c4:	5d                   	pop    %ebp
801041c5:	c3                   	ret    
    panic("sleep without lk");
801041c6:	83 ec 0c             	sub    $0xc,%esp
801041c9:	68 cd 7f 10 80       	push   $0x80107fcd
801041ce:	e8 ad c1 ff ff       	call   80100380 <panic>
    panic("sleep");
801041d3:	83 ec 0c             	sub    $0xc,%esp
801041d6:	68 c7 7f 10 80       	push   $0x80107fc7
801041db:	e8 a0 c1 ff ff       	call   80100380 <panic>

801041e0 <wakeup>:
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	53                   	push   %ebx
801041e4:	83 ec 10             	sub    $0x10,%esp
801041e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041ea:	68 20 2d 11 80       	push   $0x80112d20
801041ef:	e8 1c 0a 00 00       	call   80104c10 <acquire>
801041f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041f7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801041fc:	eb 0e                	jmp    8010420c <wakeup+0x2c>
801041fe:	66 90                	xchg   %ax,%ax
80104200:	05 90 00 00 00       	add    $0x90,%eax
80104205:	3d 54 51 11 80       	cmp    $0x80115154,%eax
8010420a:	74 1e                	je     8010422a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan){
8010420c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104210:	75 ee                	jne    80104200 <wakeup+0x20>
80104212:	3b 58 20             	cmp    0x20(%eax),%ebx
80104215:	75 e9                	jne    80104200 <wakeup+0x20>
      p->state = RUNNABLE;
80104217:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010421e:	05 90 00 00 00       	add    $0x90,%eax
80104223:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80104228:	75 e2                	jne    8010420c <wakeup+0x2c>
  release(&ptable.lock);
8010422a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104231:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104234:	c9                   	leave  
  release(&ptable.lock);
80104235:	e9 76 09 00 00       	jmp    80104bb0 <release>
8010423a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104240 <kill>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	56                   	push   %esi
  int found = 0;
80104244:	31 f6                	xor    %esi,%esi
{
80104246:	53                   	push   %ebx
80104247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010424a:	83 ec 0c             	sub    $0xc,%esp
8010424d:	68 20 2d 11 80       	push   $0x80112d20
80104252:	e8 b9 09 00 00       	call   80104c10 <acquire>
80104257:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010425a:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010425f:	eb 13                	jmp    80104274 <kill+0x34>
80104261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104268:	05 90 00 00 00       	add    $0x90,%eax
8010426d:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80104272:	74 2a                	je     8010429e <kill+0x5e>
    if(p->pid == pid){
80104274:	39 58 10             	cmp    %ebx,0x10(%eax)
80104277:	75 ef                	jne    80104268 <kill+0x28>
      if(p->state == SLEEPING)
80104279:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010427d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      found = 1;
80104284:	be 01 00 00 00       	mov    $0x1,%esi
      if(p->state == SLEEPING)
80104289:	75 dd                	jne    80104268 <kill+0x28>
        p->state = RUNNABLE;
8010428b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104292:	05 90 00 00 00       	add    $0x90,%eax
80104297:	3d 54 51 11 80       	cmp    $0x80115154,%eax
8010429c:	75 d6                	jne    80104274 <kill+0x34>
  release(&ptable.lock);
8010429e:	83 ec 0c             	sub    $0xc,%esp
801042a1:	68 20 2d 11 80       	push   $0x80112d20
801042a6:	e8 05 09 00 00       	call   80104bb0 <release>
}
801042ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if (found) return 0;
801042ae:	8d 46 ff             	lea    -0x1(%esi),%eax
}
801042b1:	5b                   	pop    %ebx
801042b2:	5e                   	pop    %esi
801042b3:	5d                   	pop    %ebp
801042b4:	c3                   	ret    
801042b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042c0 <procdump>:
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	57                   	push   %edi
801042c4:	56                   	push   %esi
801042c5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801042c8:	53                   	push   %ebx
801042c9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801042ce:	83 ec 3c             	sub    $0x3c,%esp
801042d1:	eb 27                	jmp    801042fa <procdump+0x3a>
801042d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042d7:	90                   	nop
    cprintf("\n");
801042d8:	83 ec 0c             	sub    $0xc,%esp
801042db:	68 63 83 10 80       	push   $0x80108363
801042e0:	e8 bb c3 ff ff       	call   801006a0 <cprintf>
801042e5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042e8:	81 c3 90 00 00 00    	add    $0x90,%ebx
801042ee:	81 fb c0 51 11 80    	cmp    $0x801151c0,%ebx
801042f4:	0f 84 96 00 00 00    	je     80104390 <procdump+0xd0>
    if(p->state == UNUSED)
801042fa:	8b 43 a0             	mov    -0x60(%ebx),%eax
801042fd:	85 c0                	test   %eax,%eax
801042ff:	74 e7                	je     801042e8 <procdump+0x28>
      state = "???";
80104301:	ba de 7f 10 80       	mov    $0x80107fde,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104306:	83 f8 05             	cmp    $0x5,%eax
80104309:	77 11                	ja     8010431c <procdump+0x5c>
8010430b:	8b 14 85 50 80 10 80 	mov    -0x7fef7fb0(,%eax,4),%edx
      state = "???";
80104312:	b8 de 7f 10 80       	mov    $0x80107fde,%eax
80104317:	85 d2                	test   %edx,%edx
80104319:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d(%d) %s %s", p->pid, p->tid, state, p->name);
8010431c:	83 ec 0c             	sub    $0xc,%esp
8010431f:	53                   	push   %ebx
80104320:	52                   	push   %edx
80104321:	ff 73 18             	push   0x18(%ebx)
80104324:	ff 73 a4             	push   -0x5c(%ebx)
80104327:	68 e2 7f 10 80       	push   $0x80107fe2
8010432c:	e8 6f c3 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104331:	83 c4 20             	add    $0x20,%esp
80104334:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104338:	75 9e                	jne    801042d8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010433a:	83 ec 08             	sub    $0x8,%esp
8010433d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104340:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104343:	50                   	push   %eax
80104344:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104347:	8b 40 0c             	mov    0xc(%eax),%eax
8010434a:	83 c0 08             	add    $0x8,%eax
8010434d:	50                   	push   %eax
8010434e:	e8 0d 07 00 00       	call   80104a60 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104353:	83 c4 10             	add    $0x10,%esp
80104356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010435d:	8d 76 00             	lea    0x0(%esi),%esi
80104360:	8b 17                	mov    (%edi),%edx
80104362:	85 d2                	test   %edx,%edx
80104364:	0f 84 6e ff ff ff    	je     801042d8 <procdump+0x18>
        cprintf(" %p", pc[i]);
8010436a:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010436d:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104370:	52                   	push   %edx
80104371:	68 41 7a 10 80       	push   $0x80107a41
80104376:	e8 25 c3 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010437b:	83 c4 10             	add    $0x10,%esp
8010437e:	39 fe                	cmp    %edi,%esi
80104380:	75 de                	jne    80104360 <procdump+0xa0>
80104382:	e9 51 ff ff ff       	jmp    801042d8 <procdump+0x18>
80104387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010438e:	66 90                	xchg   %ax,%ax
}
80104390:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104393:	5b                   	pop    %ebx
80104394:	5e                   	pop    %esi
80104395:	5f                   	pop    %edi
80104396:	5d                   	pop    %ebp
80104397:	c3                   	ret    
80104398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010439f:	90                   	nop

801043a0 <thread_create>:
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	57                   	push   %edi
801043a4:	56                   	push   %esi
801043a5:	53                   	push   %ebx
801043a6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801043a9:	e8 12 07 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
801043ae:	e8 fd f5 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
801043b3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043b9:	e8 52 07 00 00       	call   80104b10 <popcli>
  if((np = allocproc(curproc)) == 0){
801043be:	89 d8                	mov    %ebx,%eax
801043c0:	e8 4b f4 ff ff       	call   80103810 <allocproc>
801043c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801043c8:	85 c0                	test   %eax,%eax
801043ca:	0f 84 42 01 00 00    	je     80104512 <thread_create+0x172>
  acquire(&ptable.lock);
801043d0:	83 ec 0c             	sub    $0xc,%esp
801043d3:	68 20 2d 11 80       	push   $0x80112d20
801043d8:	e8 33 08 00 00       	call   80104c10 <acquire>
  np->pgdir = curproc->pgdir;
801043dd:	8b 43 04             	mov    0x4(%ebx),%eax
801043e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
801043e3:	b9 13 00 00 00       	mov    $0x13,%ecx
  (curproc->tno)++;
801043e8:	83 43 7c 01          	addl   $0x1,0x7c(%ebx)
  np->mthread = curproc->mthread;
801043ec:	83 c4 10             	add    $0x10,%esp
  np->pgdir = curproc->pgdir;
801043ef:	89 42 04             	mov    %eax,0x4(%edx)
  *np->tf = *curproc->tf;
801043f2:	8b 7a 18             	mov    0x18(%edx),%edi
801043f5:	8b 73 18             	mov    0x18(%ebx),%esi
801043f8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801043fa:	31 f6                	xor    %esi,%esi
  np->mthread = curproc->mthread;
801043fc:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80104402:	89 82 88 00 00 00    	mov    %eax,0x88(%edx)
  for(i = 0; i < NOFILE; i++)
80104408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010440f:	90                   	nop
    if(curproc->ofile[i])
80104410:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104414:	85 c0                	test   %eax,%eax
80104416:	74 13                	je     8010442b <thread_create+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104418:	83 ec 0c             	sub    $0xc,%esp
8010441b:	50                   	push   %eax
8010441c:	e8 9f ca ff ff       	call   80100ec0 <filedup>
80104421:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104424:	83 c4 10             	add    $0x10,%esp
80104427:	89 44 b1 28          	mov    %eax,0x28(%ecx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010442b:	83 c6 01             	add    $0x1,%esi
8010442e:	83 fe 10             	cmp    $0x10,%esi
80104431:	75 dd                	jne    80104410 <thread_create+0x70>
  np->cwd = idup(curproc->cwd);
80104433:	83 ec 0c             	sub    $0xc,%esp
80104436:	ff 73 68             	push   0x68(%ebx)
80104439:	e8 32 d3 ff ff       	call   80101770 <idup>
8010443e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104441:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104444:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104447:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010444a:	6a 10                	push   $0x10
8010444c:	50                   	push   %eax
8010444d:	8d 47 6c             	lea    0x6c(%edi),%eax
80104450:	50                   	push   %eax
80104451:	e8 3a 0a 00 00       	call   80104e90 <safestrcpy>
  sz = PGROUNDUP(curproc->sz);
80104456:	8b 03                	mov    (%ebx),%eax
  if((sz = allocuvm(np->pgdir, sz, sz + 2*PGSIZE)) == 0)
80104458:	83 c4 0c             	add    $0xc,%esp
  sz = PGROUNDUP(curproc->sz);
8010445b:	05 ff 0f 00 00       	add    $0xfff,%eax
80104460:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(np->pgdir, sz, sz + 2*PGSIZE)) == 0)
80104465:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
8010446b:	52                   	push   %edx
8010446c:	50                   	push   %eax
8010446d:	ff 77 04             	push   0x4(%edi)
80104470:	e8 5b 30 00 00       	call   801074d0 <allocuvm>
80104475:	83 c4 10             	add    $0x10,%esp
80104478:	89 c6                	mov    %eax,%esi
8010447a:	85 c0                	test   %eax,%eax
8010447c:	0f 84 90 00 00 00    	je     80104512 <thread_create+0x172>
  clearpteu(np->pgdir, (char*)(sz - 2*PGSIZE));
80104482:	83 ec 08             	sub    $0x8,%esp
80104485:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
8010448b:	50                   	push   %eax
8010448c:	ff 77 04             	push   0x4(%edi)
8010448f:	e8 bc 32 00 00       	call   80107750 <clearpteu>
  curproc->sz = sz;
80104494:	89 33                	mov    %esi,(%ebx)
  *thread = np->tid;
80104496:	8b 45 08             	mov    0x8(%ebp),%eax
80104499:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  np->sz = 2 * PGSIZE;
8010449f:	c7 07 00 20 00 00    	movl   $0x2000,(%edi)
  *thread = np->tid;
801044a5:	89 10                	mov    %edx,(%eax)
  if(copyout(np->pgdir, sp, &arg, sizeof(arg)) < 0)
801044a7:	8d 45 10             	lea    0x10(%ebp),%eax
801044aa:	6a 04                	push   $0x4
801044ac:	50                   	push   %eax
  sp -= 4;
801044ad:	8d 46 fc             	lea    -0x4(%esi),%eax
  if(copyout(np->pgdir, sp, &arg, sizeof(arg)) < 0)
801044b0:	50                   	push   %eax
801044b1:	ff 77 04             	push   0x4(%edi)
801044b4:	e8 67 34 00 00       	call   80107920 <copyout>
801044b9:	83 c4 20             	add    $0x20,%esp
801044bc:	85 c0                	test   %eax,%eax
801044be:	78 52                	js     80104512 <thread_create+0x172>
  sp -= 4;
801044c0:	83 ee 08             	sub    $0x8,%esi
  if(copyout(np->pgdir, sp, &thread_exit, sizeof(thread_exit)) < 0)
801044c3:	6a 01                	push   $0x1
801044c5:	68 70 3e 10 80       	push   $0x80103e70
801044ca:	56                   	push   %esi
801044cb:	ff 77 04             	push   0x4(%edi)
801044ce:	e8 4d 34 00 00       	call   80107920 <copyout>
801044d3:	83 c4 10             	add    $0x10,%esp
801044d6:	85 c0                	test   %eax,%eax
801044d8:	78 38                	js     80104512 <thread_create+0x172>
  np->tf->esp = sp;
801044da:	8b 47 18             	mov    0x18(%edi),%eax
  np->tf->eip = (uint)start_routine;
801044dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  switchuvm(curproc);
801044e0:	83 ec 0c             	sub    $0xc,%esp
  np->tf->esp = sp;
801044e3:	89 70 44             	mov    %esi,0x44(%eax)
  np->tf->eip = (uint)start_routine;
801044e6:	8b 47 18             	mov    0x18(%edi),%eax
801044e9:	89 50 38             	mov    %edx,0x38(%eax)
  switchuvm(curproc);
801044ec:	53                   	push   %ebx
801044ed:	e8 5e 2d 00 00       	call   80107250 <switchuvm>
  np->state = RUNNABLE;
801044f2:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801044f9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104500:	e8 ab 06 00 00       	call   80104bb0 <release>
  return 0;
80104505:	83 c4 10             	add    $0x10,%esp
80104508:	31 c0                	xor    %eax,%eax
}
8010450a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010450d:	5b                   	pop    %ebx
8010450e:	5e                   	pop    %esi
8010450f:	5f                   	pop    %edi
80104510:	5d                   	pop    %ebp
80104511:	c3                   	ret    
    return -1;
80104512:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104517:	eb f1                	jmp    8010450a <thread_create+0x16a>
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104520 <thread_join>:
}

// Wait until the given thread exits
// and take back the resources allocated to it.
int thread_join(thread_t thread, void **retval)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	57                   	push   %edi
80104524:	56                   	push   %esi
80104525:	53                   	push   %ebx
80104526:	83 ec 0c             	sub    $0xc,%esp
80104529:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
8010452c:	e8 8f 05 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
80104531:	e8 7a f4 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80104536:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010453c:	e8 cf 05 00 00       	call   80104b10 <popcli>
  struct proc *p;
  int found;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80104541:	83 ec 0c             	sub    $0xc,%esp
80104544:	68 20 2d 11 80       	push   $0x80112d20
80104549:	e8 c2 06 00 00       	call   80104c10 <acquire>
8010454e:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for the thread.
    found = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->pid != curproc->pid || p->tid != thread)
80104551:	8b 46 10             	mov    0x10(%esi),%eax
    found = 0;
80104554:	31 c9                	xor    %ecx,%ecx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104556:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
8010455b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010455f:	90                   	nop
      if(p->pid != curproc->pid || p->tid != thread)
80104560:	39 43 10             	cmp    %eax,0x10(%ebx)
80104563:	75 13                	jne    80104578 <thread_join+0x58>
80104565:	39 bb 84 00 00 00    	cmp    %edi,0x84(%ebx)
8010456b:	75 0b                	jne    80104578 <thread_join+0x58>
        continue;
      found = 1;
      if(p->state == ZOMBIE){
8010456d:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104571:	74 5d                	je     801045d0 <thread_join+0xb0>
      found = 1;
80104573:	b9 01 00 00 00       	mov    $0x1,%ecx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104578:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010457e:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80104584:	75 da                	jne    80104560 <thread_join+0x40>
        return 0;
      }
    }

    // No point waiting if we don't have any children.
    if(!found || curproc->killed){
80104586:	85 c9                	test   %ecx,%ecx
80104588:	0f 84 b3 00 00 00    	je     80104641 <thread_join+0x121>
8010458e:	8b 46 24             	mov    0x24(%esi),%eax
80104591:	85 c0                	test   %eax,%eax
80104593:	0f 85 a8 00 00 00    	jne    80104641 <thread_join+0x121>
  pushcli();
80104599:	e8 22 05 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
8010459e:	e8 0d f4 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
801045a3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045a9:	e8 62 05 00 00       	call   80104b10 <popcli>
  if(p == 0)
801045ae:	85 db                	test   %ebx,%ebx
801045b0:	0f 84 a2 00 00 00    	je     80104658 <thread_join+0x138>
  p->chan = chan;
801045b6:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801045b9:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801045c0:	e8 eb f7 ff ff       	call   80103db0 <sched>
  p->chan = 0;
801045c5:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801045cc:	eb 83                	jmp    80104551 <thread_join+0x31>
801045ce:	66 90                	xchg   %ax,%ax
        if (retval) *retval = p->retval;
801045d0:	8b 55 0c             	mov    0xc(%ebp),%edx
801045d3:	85 d2                	test   %edx,%edx
801045d5:	74 0b                	je     801045e2 <thread_join+0xc2>
801045d7:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801045dd:	8b 55 0c             	mov    0xc(%ebp),%edx
801045e0:	89 02                	mov    %eax,(%edx)
        kfree(p->kstack);
801045e2:	83 ec 0c             	sub    $0xc,%esp
801045e5:	ff 73 08             	push   0x8(%ebx)
801045e8:	e8 f3 de ff ff       	call   801024e0 <kfree>
        p->kstack = 0;
801045ed:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        p->pid = 0;
801045f4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->tid = 0;
801045fb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104602:	00 00 00 
        p->nexttid = 0;
80104605:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010460c:	00 00 00 
        p->parent = 0;
8010460f:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104616:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010461a:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104621:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104628:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010462f:	e8 7c 05 00 00       	call   80104bb0 <release>
        return 0;
80104634:	83 c4 10             	add    $0x10,%esp
80104637:	31 c0                	xor    %eax,%eax
    }

    // Wait for thread to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104639:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010463c:	5b                   	pop    %ebx
8010463d:	5e                   	pop    %esi
8010463e:	5f                   	pop    %edi
8010463f:	5d                   	pop    %ebp
80104640:	c3                   	ret    
      release(&ptable.lock);
80104641:	83 ec 0c             	sub    $0xc,%esp
80104644:	68 20 2d 11 80       	push   $0x80112d20
80104649:	e8 62 05 00 00       	call   80104bb0 <release>
      return -1;
8010464e:	83 c4 10             	add    $0x10,%esp
80104651:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104656:	eb e1                	jmp    80104639 <thread_join+0x119>
    panic("sleep");
80104658:	83 ec 0c             	sub    $0xc,%esp
8010465b:	68 c7 7f 10 80       	push   $0x80107fc7
80104660:	e8 1b bd ff ff       	call   80100380 <panic>
80104665:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010466c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104670 <thread_join_all>:

int thread_join_all()
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	57                   	push   %edi
80104674:	56                   	push   %esi
80104675:	53                   	push   %ebx
80104676:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104679:	e8 42 04 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
8010467e:	e8 2d f3 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80104683:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104689:	e8 82 04 00 00       	call   80104b10 <popcli>
  struct proc *p;
  int havekids, tid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
8010468e:	83 ec 0c             	sub    $0xc,%esp
80104691:	68 20 2d 11 80       	push   $0x80112d20
80104696:	e8 75 05 00 00       	call   80104c10 <acquire>
8010469b:	83 c4 10             	add    $0x10,%esp
  for(;;){
    havekids = 0;
8010469e:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046a0:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801046a5:	eb 20                	jmp    801046c7 <thread_join_all+0x57>
801046a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ae:	66 90                	xchg   %ax,%ax
      if (p == curproc || p->pid != curproc->pid)
        continue;
      havekids = 1;
801046b0:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046b5:	81 c3 90 00 00 00    	add    $0x90,%ebx
801046bb:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
801046c1:	0f 84 99 00 00 00    	je     80104760 <thread_join_all+0xf0>
      if (p == curproc || p->pid != curproc->pid)
801046c7:	39 de                	cmp    %ebx,%esi
801046c9:	74 ea                	je     801046b5 <thread_join_all+0x45>
801046cb:	8b 56 10             	mov    0x10(%esi),%edx
801046ce:	39 53 10             	cmp    %edx,0x10(%ebx)
801046d1:	75 e2                	jne    801046b5 <thread_join_all+0x45>
      if(p->state == ZOMBIE){
801046d3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801046d7:	75 d7                	jne    801046b0 <thread_join_all+0x40>
        // Found one.
        tid = p->tid;
        kfree(p->kstack);
801046d9:	83 ec 0c             	sub    $0xc,%esp
        tid = p->tid;
801046dc:	8b bb 84 00 00 00    	mov    0x84(%ebx),%edi
        kfree(p->kstack);
801046e2:	ff 73 08             	push   0x8(%ebx)
801046e5:	e8 f6 dd ff ff       	call   801024e0 <kfree>
        p->kstack = 0;
801046ea:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        if (p->pgdir != curproc->pgdir)  // Free only if it has executed.
801046f1:	8b 43 04             	mov    0x4(%ebx),%eax
801046f4:	83 c4 10             	add    $0x10,%esp
801046f7:	3b 46 04             	cmp    0x4(%esi),%eax
801046fa:	74 0c                	je     80104708 <thread_join_all+0x98>
          freevm(p->pgdir);
801046fc:	83 ec 0c             	sub    $0xc,%esp
801046ff:	50                   	push   %eax
80104700:	e8 2b 2f 00 00       	call   80107630 <freevm>
80104705:	83 c4 10             	add    $0x10,%esp
        p->nexttid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80104708:	83 ec 0c             	sub    $0xc,%esp
        p->name[0] = 0;
8010470b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->pid = 0;
8010470f:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->tid = 0;
80104716:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010471d:	00 00 00 
        p->nexttid = 0;
80104720:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104727:	00 00 00 
        p->parent = 0;
8010472a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->killed = 0;
80104731:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104738:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010473f:	68 20 2d 11 80       	push   $0x80112d20
80104744:	e8 67 04 00 00       	call   80104bb0 <release>
        return tid;
80104749:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010474c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010474f:	89 f8                	mov    %edi,%eax
80104751:	5b                   	pop    %ebx
80104752:	5e                   	pop    %esi
80104753:	5f                   	pop    %edi
80104754:	5d                   	pop    %ebp
80104755:	c3                   	ret    
80104756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010475d:	8d 76 00             	lea    0x0(%esi),%esi
    if(!havekids){
80104760:	85 c0                	test   %eax,%eax
80104762:	74 34                	je     80104798 <thread_join_all+0x128>
  pushcli();
80104764:	e8 57 03 00 00       	call   80104ac0 <pushcli>
  c = mycpu();
80104769:	e8 42 f2 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
8010476e:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104774:	e8 97 03 00 00       	call   80104b10 <popcli>
  if(p == 0)
80104779:	85 db                	test   %ebx,%ebx
8010477b:	74 32                	je     801047af <thread_join_all+0x13f>
  p->chan = chan;
8010477d:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104780:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104787:	e8 24 f6 ff ff       	call   80103db0 <sched>
  p->chan = 0;
8010478c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104793:	e9 06 ff ff ff       	jmp    8010469e <thread_join_all+0x2e>
      release(&ptable.lock);
80104798:	83 ec 0c             	sub    $0xc,%esp
      return -1;
8010479b:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      release(&ptable.lock);
801047a0:	68 20 2d 11 80       	push   $0x80112d20
801047a5:	e8 06 04 00 00       	call   80104bb0 <release>
      return -1;
801047aa:	83 c4 10             	add    $0x10,%esp
801047ad:	eb 9d                	jmp    8010474c <thread_join_all+0xdc>
    panic("sleep");
801047af:	83 ec 0c             	sub    $0xc,%esp
801047b2:	68 c7 7f 10 80       	push   $0x80107fc7
801047b7:	e8 c4 bb ff ff       	call   80100380 <panic>
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047c0 <exit>:
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	57                   	push   %edi
801047c4:	56                   	push   %esi
801047c5:	53                   	push   %ebx
801047c6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801047c9:	e8 62 f2 ff ff       	call   80103a30 <myproc>
  if(curproc == initproc)
801047ce:	89 c3                	mov    %eax,%ebx
801047d0:	39 05 54 51 11 80    	cmp    %eax,0x80115154
801047d6:	0f 84 d5 00 00 00    	je     801048b1 <exit+0xf1>
801047dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(thread_join_all() != -1);
801047e0:	e8 8b fe ff ff       	call   80104670 <thread_join_all>
801047e5:	83 f8 ff             	cmp    $0xffffffff,%eax
801047e8:	75 f6                	jne    801047e0 <exit+0x20>
801047ea:	8d 73 28             	lea    0x28(%ebx),%esi
801047ed:	8d 7b 68             	lea    0x68(%ebx),%edi
    if(curproc->ofile[fd]){
801047f0:	8b 06                	mov    (%esi),%eax
801047f2:	85 c0                	test   %eax,%eax
801047f4:	74 12                	je     80104808 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801047f6:	83 ec 0c             	sub    $0xc,%esp
801047f9:	50                   	push   %eax
801047fa:	e8 11 c7 ff ff       	call   80100f10 <fileclose>
      curproc->ofile[fd] = 0;
801047ff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104805:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104808:	83 c6 04             	add    $0x4,%esi
8010480b:	39 f7                	cmp    %esi,%edi
8010480d:	75 e1                	jne    801047f0 <exit+0x30>
  begin_op();
8010480f:	e8 6c e5 ff ff       	call   80102d80 <begin_op>
  iput(curproc->cwd);
80104814:	83 ec 0c             	sub    $0xc,%esp
80104817:	ff 73 68             	push   0x68(%ebx)
8010481a:	e8 b1 d0 ff ff       	call   801018d0 <iput>
  end_op();
8010481f:	e8 cc e5 ff ff       	call   80102df0 <end_op>
  curproc->cwd = 0;
80104824:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
8010482b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104832:	e8 d9 03 00 00       	call   80104c10 <acquire>
  wakeup1(curproc->parent);
80104837:	8b 43 14             	mov    0x14(%ebx),%eax
8010483a:	e8 91 ef ff ff       	call   801037d0 <wakeup1>
      p->parent = initproc;
8010483f:	8b 0d 54 51 11 80    	mov    0x80115154,%ecx
80104845:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104848:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
8010484d:	eb 0f                	jmp    8010485e <exit+0x9e>
8010484f:	90                   	nop
80104850:	81 c2 90 00 00 00    	add    $0x90,%edx
80104856:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
8010485c:	74 3a                	je     80104898 <exit+0xd8>
    if(p->parent == curproc){
8010485e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104861:	75 ed                	jne    80104850 <exit+0x90>
      if(p->state == ZOMBIE)
80104863:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104867:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010486a:	75 e4                	jne    80104850 <exit+0x90>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010486c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104871:	eb 11                	jmp    80104884 <exit+0xc4>
80104873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104877:	90                   	nop
80104878:	05 90 00 00 00       	add    $0x90,%eax
8010487d:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80104882:	74 cc                	je     80104850 <exit+0x90>
    if(p->state == SLEEPING && p->chan == chan){
80104884:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104888:	75 ee                	jne    80104878 <exit+0xb8>
8010488a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010488d:	75 e9                	jne    80104878 <exit+0xb8>
      p->state = RUNNABLE;
8010488f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104896:	eb e0                	jmp    80104878 <exit+0xb8>
  curproc->state = ZOMBIE;
80104898:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010489f:	e8 0c f5 ff ff       	call   80103db0 <sched>
  panic("zombie exit");
801048a4:	83 ec 0c             	sub    $0xc,%esp
801048a7:	68 bb 7f 10 80       	push   $0x80107fbb
801048ac:	e8 cf ba ff ff       	call   80100380 <panic>
    panic("init exiting");
801048b1:	83 ec 0c             	sub    $0xc,%esp
801048b4:	68 ef 7f 10 80       	push   $0x80107fef
801048b9:	e8 c2 ba ff ff       	call   80100380 <panic>
801048be:	66 90                	xchg   %ax,%ax

801048c0 <merge>:

void
merge(struct proc *curproc)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	53                   	push   %ebx
801048c4:	83 ec 10             	sub    $0x10,%esp
801048c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  acquire(&ptable.lock);
801048ca:	68 20 2d 11 80       	push   $0x80112d20
801048cf:	e8 3c 03 00 00       	call   80104c10 <acquire>
801048d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048d7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801048dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p == curproc) continue;
801048e0:	39 c3                	cmp    %eax,%ebx
801048e2:	74 0f                	je     801048f3 <merge+0x33>
    if(p->pid == curproc->pid)
801048e4:	8b 53 10             	mov    0x10(%ebx),%edx
801048e7:	39 50 10             	cmp    %edx,0x10(%eax)
801048ea:	75 07                	jne    801048f3 <merge+0x33>
      p->killed = 1;
801048ec:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048f3:	05 90 00 00 00       	add    $0x90,%eax
801048f8:	3d 54 51 11 80       	cmp    $0x80115154,%eax
801048fd:	75 e1                	jne    801048e0 <merge+0x20>
  }
  release(&ptable.lock);
801048ff:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
80104906:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104909:	c9                   	leave  
  release(&ptable.lock);
8010490a:	e9 a1 02 00 00       	jmp    80104bb0 <release>
8010490f:	90                   	nop

80104910 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	53                   	push   %ebx
80104914:	83 ec 0c             	sub    $0xc,%esp
80104917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010491a:	68 68 80 10 80       	push   $0x80108068
8010491f:	8d 43 04             	lea    0x4(%ebx),%eax
80104922:	50                   	push   %eax
80104923:	e8 18 01 00 00       	call   80104a40 <initlock>
  lk->name = name;
80104928:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010492b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104931:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104934:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010493b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010493e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104941:	c9                   	leave  
80104942:	c3                   	ret    
80104943:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104950 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	53                   	push   %ebx
80104955:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104958:	8d 73 04             	lea    0x4(%ebx),%esi
8010495b:	83 ec 0c             	sub    $0xc,%esp
8010495e:	56                   	push   %esi
8010495f:	e8 ac 02 00 00       	call   80104c10 <acquire>
  while (lk->locked) {
80104964:	8b 13                	mov    (%ebx),%edx
80104966:	83 c4 10             	add    $0x10,%esp
80104969:	85 d2                	test   %edx,%edx
8010496b:	74 16                	je     80104983 <acquiresleep+0x33>
8010496d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104970:	83 ec 08             	sub    $0x8,%esp
80104973:	56                   	push   %esi
80104974:	53                   	push   %ebx
80104975:	e8 a6 f7 ff ff       	call   80104120 <sleep>
  while (lk->locked) {
8010497a:	8b 03                	mov    (%ebx),%eax
8010497c:	83 c4 10             	add    $0x10,%esp
8010497f:	85 c0                	test   %eax,%eax
80104981:	75 ed                	jne    80104970 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104983:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104989:	e8 a2 f0 ff ff       	call   80103a30 <myproc>
8010498e:	8b 40 10             	mov    0x10(%eax),%eax
80104991:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104994:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104997:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010499a:	5b                   	pop    %ebx
8010499b:	5e                   	pop    %esi
8010499c:	5d                   	pop    %ebp
  release(&lk->lk);
8010499d:	e9 0e 02 00 00       	jmp    80104bb0 <release>
801049a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	53                   	push   %ebx
801049b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049b8:	8d 73 04             	lea    0x4(%ebx),%esi
801049bb:	83 ec 0c             	sub    $0xc,%esp
801049be:	56                   	push   %esi
801049bf:	e8 4c 02 00 00       	call   80104c10 <acquire>
  lk->locked = 0;
801049c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801049ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801049d1:	89 1c 24             	mov    %ebx,(%esp)
801049d4:	e8 07 f8 ff ff       	call   801041e0 <wakeup>
  release(&lk->lk);
801049d9:	89 75 08             	mov    %esi,0x8(%ebp)
801049dc:	83 c4 10             	add    $0x10,%esp
}
801049df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049e2:	5b                   	pop    %ebx
801049e3:	5e                   	pop    %esi
801049e4:	5d                   	pop    %ebp
  release(&lk->lk);
801049e5:	e9 c6 01 00 00       	jmp    80104bb0 <release>
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	57                   	push   %edi
801049f4:	31 ff                	xor    %edi,%edi
801049f6:	56                   	push   %esi
801049f7:	53                   	push   %ebx
801049f8:	83 ec 18             	sub    $0x18,%esp
801049fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801049fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104a01:	56                   	push   %esi
80104a02:	e8 09 02 00 00       	call   80104c10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a07:	8b 03                	mov    (%ebx),%eax
80104a09:	83 c4 10             	add    $0x10,%esp
80104a0c:	85 c0                	test   %eax,%eax
80104a0e:	75 18                	jne    80104a28 <holdingsleep+0x38>
  release(&lk->lk);
80104a10:	83 ec 0c             	sub    $0xc,%esp
80104a13:	56                   	push   %esi
80104a14:	e8 97 01 00 00       	call   80104bb0 <release>
  return r;
}
80104a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a1c:	89 f8                	mov    %edi,%eax
80104a1e:	5b                   	pop    %ebx
80104a1f:	5e                   	pop    %esi
80104a20:	5f                   	pop    %edi
80104a21:	5d                   	pop    %ebp
80104a22:	c3                   	ret    
80104a23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a27:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104a28:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a2b:	e8 00 f0 ff ff       	call   80103a30 <myproc>
80104a30:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a33:	0f 94 c0             	sete   %al
80104a36:	0f b6 c0             	movzbl %al,%eax
80104a39:	89 c7                	mov    %eax,%edi
80104a3b:	eb d3                	jmp    80104a10 <holdingsleep+0x20>
80104a3d:	66 90                	xchg   %ax,%ax
80104a3f:	90                   	nop

80104a40 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a46:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a4f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a59:	5d                   	pop    %ebp
80104a5a:	c3                   	ret    
80104a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a5f:	90                   	nop

80104a60 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a60:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a61:	31 d2                	xor    %edx,%edx
{
80104a63:	89 e5                	mov    %esp,%ebp
80104a65:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104a66:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104a69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104a6c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104a6f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a70:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a76:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a7c:	77 1a                	ja     80104a98 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a7e:	8b 58 04             	mov    0x4(%eax),%ebx
80104a81:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a84:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a87:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a89:	83 fa 0a             	cmp    $0xa,%edx
80104a8c:	75 e2                	jne    80104a70 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104a8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a91:	c9                   	leave  
80104a92:	c3                   	ret    
80104a93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a97:	90                   	nop
  for(; i < 10; i++)
80104a98:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104a9b:	8d 51 28             	lea    0x28(%ecx),%edx
80104a9e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104aa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104aa6:	83 c0 04             	add    $0x4,%eax
80104aa9:	39 d0                	cmp    %edx,%eax
80104aab:	75 f3                	jne    80104aa0 <getcallerpcs+0x40>
}
80104aad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab0:	c9                   	leave  
80104ab1:	c3                   	ret    
80104ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ac0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	53                   	push   %ebx
80104ac4:	83 ec 04             	sub    $0x4,%esp
80104ac7:	9c                   	pushf  
80104ac8:	5b                   	pop    %ebx
  asm volatile("cli");
80104ac9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104aca:	e8 e1 ee ff ff       	call   801039b0 <mycpu>
80104acf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ad5:	85 c0                	test   %eax,%eax
80104ad7:	74 17                	je     80104af0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104ad9:	e8 d2 ee ff ff       	call   801039b0 <mycpu>
80104ade:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ae8:	c9                   	leave  
80104ae9:	c3                   	ret    
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104af0:	e8 bb ee ff ff       	call   801039b0 <mycpu>
80104af5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104afb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104b01:	eb d6                	jmp    80104ad9 <pushcli+0x19>
80104b03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b10 <popcli>:

void
popcli(void)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b16:	9c                   	pushf  
80104b17:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b18:	f6 c4 02             	test   $0x2,%ah
80104b1b:	75 35                	jne    80104b52 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b1d:	e8 8e ee ff ff       	call   801039b0 <mycpu>
80104b22:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b29:	78 34                	js     80104b5f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b2b:	e8 80 ee ff ff       	call   801039b0 <mycpu>
80104b30:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b36:	85 d2                	test   %edx,%edx
80104b38:	74 06                	je     80104b40 <popcli+0x30>
    sti();
}
80104b3a:	c9                   	leave  
80104b3b:	c3                   	ret    
80104b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b40:	e8 6b ee ff ff       	call   801039b0 <mycpu>
80104b45:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b4b:	85 c0                	test   %eax,%eax
80104b4d:	74 eb                	je     80104b3a <popcli+0x2a>
  asm volatile("sti");
80104b4f:	fb                   	sti    
}
80104b50:	c9                   	leave  
80104b51:	c3                   	ret    
    panic("popcli - interruptible");
80104b52:	83 ec 0c             	sub    $0xc,%esp
80104b55:	68 73 80 10 80       	push   $0x80108073
80104b5a:	e8 21 b8 ff ff       	call   80100380 <panic>
    panic("popcli");
80104b5f:	83 ec 0c             	sub    $0xc,%esp
80104b62:	68 8a 80 10 80       	push   $0x8010808a
80104b67:	e8 14 b8 ff ff       	call   80100380 <panic>
80104b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b70 <holding>:
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	56                   	push   %esi
80104b74:	53                   	push   %ebx
80104b75:	8b 75 08             	mov    0x8(%ebp),%esi
80104b78:	31 db                	xor    %ebx,%ebx
  pushcli();
80104b7a:	e8 41 ff ff ff       	call   80104ac0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104b7f:	8b 06                	mov    (%esi),%eax
80104b81:	85 c0                	test   %eax,%eax
80104b83:	75 0b                	jne    80104b90 <holding+0x20>
  popcli();
80104b85:	e8 86 ff ff ff       	call   80104b10 <popcli>
}
80104b8a:	89 d8                	mov    %ebx,%eax
80104b8c:	5b                   	pop    %ebx
80104b8d:	5e                   	pop    %esi
80104b8e:	5d                   	pop    %ebp
80104b8f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104b90:	8b 5e 08             	mov    0x8(%esi),%ebx
80104b93:	e8 18 ee ff ff       	call   801039b0 <mycpu>
80104b98:	39 c3                	cmp    %eax,%ebx
80104b9a:	0f 94 c3             	sete   %bl
  popcli();
80104b9d:	e8 6e ff ff ff       	call   80104b10 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104ba2:	0f b6 db             	movzbl %bl,%ebx
}
80104ba5:	89 d8                	mov    %ebx,%eax
80104ba7:	5b                   	pop    %ebx
80104ba8:	5e                   	pop    %esi
80104ba9:	5d                   	pop    %ebp
80104baa:	c3                   	ret    
80104bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104baf:	90                   	nop

80104bb0 <release>:
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	53                   	push   %ebx
80104bb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104bb8:	e8 03 ff ff ff       	call   80104ac0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104bbd:	8b 03                	mov    (%ebx),%eax
80104bbf:	85 c0                	test   %eax,%eax
80104bc1:	75 15                	jne    80104bd8 <release+0x28>
  popcli();
80104bc3:	e8 48 ff ff ff       	call   80104b10 <popcli>
    panic("release");
80104bc8:	83 ec 0c             	sub    $0xc,%esp
80104bcb:	68 91 80 10 80       	push   $0x80108091
80104bd0:	e8 ab b7 ff ff       	call   80100380 <panic>
80104bd5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104bd8:	8b 73 08             	mov    0x8(%ebx),%esi
80104bdb:	e8 d0 ed ff ff       	call   801039b0 <mycpu>
80104be0:	39 c6                	cmp    %eax,%esi
80104be2:	75 df                	jne    80104bc3 <release+0x13>
  popcli();
80104be4:	e8 27 ff ff ff       	call   80104b10 <popcli>
  lk->pcs[0] = 0;
80104be9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104bf0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104bf7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104bfc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104c02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c05:	5b                   	pop    %ebx
80104c06:	5e                   	pop    %esi
80104c07:	5d                   	pop    %ebp
  popcli();
80104c08:	e9 03 ff ff ff       	jmp    80104b10 <popcli>
80104c0d:	8d 76 00             	lea    0x0(%esi),%esi

80104c10 <acquire>:
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	53                   	push   %ebx
80104c14:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104c17:	e8 a4 fe ff ff       	call   80104ac0 <pushcli>
  if(holding(lk))
80104c1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104c1f:	e8 9c fe ff ff       	call   80104ac0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104c24:	8b 03                	mov    (%ebx),%eax
80104c26:	85 c0                	test   %eax,%eax
80104c28:	75 7e                	jne    80104ca8 <acquire+0x98>
  popcli();
80104c2a:	e8 e1 fe ff ff       	call   80104b10 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104c2f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104c38:	8b 55 08             	mov    0x8(%ebp),%edx
80104c3b:	89 c8                	mov    %ecx,%eax
80104c3d:	f0 87 02             	lock xchg %eax,(%edx)
80104c40:	85 c0                	test   %eax,%eax
80104c42:	75 f4                	jne    80104c38 <acquire+0x28>
  __sync_synchronize();
80104c44:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c4c:	e8 5f ed ff ff       	call   801039b0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104c51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c54:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104c56:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104c59:	31 c0                	xor    %eax,%eax
80104c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c5f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c60:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104c66:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c6c:	77 1a                	ja     80104c88 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104c6e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104c71:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104c75:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104c78:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104c7a:	83 f8 0a             	cmp    $0xa,%eax
80104c7d:	75 e1                	jne    80104c60 <acquire+0x50>
}
80104c7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c82:	c9                   	leave  
80104c83:	c3                   	ret    
80104c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104c88:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104c8c:	8d 51 34             	lea    0x34(%ecx),%edx
80104c8f:	90                   	nop
    pcs[i] = 0;
80104c90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c96:	83 c0 04             	add    $0x4,%eax
80104c99:	39 c2                	cmp    %eax,%edx
80104c9b:	75 f3                	jne    80104c90 <acquire+0x80>
}
80104c9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca0:	c9                   	leave  
80104ca1:	c3                   	ret    
80104ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ca8:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104cab:	e8 00 ed ff ff       	call   801039b0 <mycpu>
80104cb0:	39 c3                	cmp    %eax,%ebx
80104cb2:	0f 85 72 ff ff ff    	jne    80104c2a <acquire+0x1a>
  popcli();
80104cb8:	e8 53 fe ff ff       	call   80104b10 <popcli>
    panic("acquire");
80104cbd:	83 ec 0c             	sub    $0xc,%esp
80104cc0:	68 99 80 10 80       	push   $0x80108099
80104cc5:	e8 b6 b6 ff ff       	call   80100380 <panic>
80104cca:	66 90                	xchg   %ax,%ax
80104ccc:	66 90                	xchg   %ax,%ax
80104cce:	66 90                	xchg   %ax,%ax

80104cd0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	8b 55 08             	mov    0x8(%ebp),%edx
80104cd7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104cda:	53                   	push   %ebx
80104cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104cde:	89 d7                	mov    %edx,%edi
80104ce0:	09 cf                	or     %ecx,%edi
80104ce2:	83 e7 03             	and    $0x3,%edi
80104ce5:	75 29                	jne    80104d10 <memset+0x40>
    c &= 0xFF;
80104ce7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104cea:	c1 e0 18             	shl    $0x18,%eax
80104ced:	89 fb                	mov    %edi,%ebx
80104cef:	c1 e9 02             	shr    $0x2,%ecx
80104cf2:	c1 e3 10             	shl    $0x10,%ebx
80104cf5:	09 d8                	or     %ebx,%eax
80104cf7:	09 f8                	or     %edi,%eax
80104cf9:	c1 e7 08             	shl    $0x8,%edi
80104cfc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104cfe:	89 d7                	mov    %edx,%edi
80104d00:	fc                   	cld    
80104d01:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104d03:	5b                   	pop    %ebx
80104d04:	89 d0                	mov    %edx,%eax
80104d06:	5f                   	pop    %edi
80104d07:	5d                   	pop    %ebp
80104d08:	c3                   	ret    
80104d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104d10:	89 d7                	mov    %edx,%edi
80104d12:	fc                   	cld    
80104d13:	f3 aa                	rep stos %al,%es:(%edi)
80104d15:	5b                   	pop    %ebx
80104d16:	89 d0                	mov    %edx,%eax
80104d18:	5f                   	pop    %edi
80104d19:	5d                   	pop    %ebp
80104d1a:	c3                   	ret    
80104d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d1f:	90                   	nop

80104d20 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	56                   	push   %esi
80104d24:	8b 75 10             	mov    0x10(%ebp),%esi
80104d27:	8b 55 08             	mov    0x8(%ebp),%edx
80104d2a:	53                   	push   %ebx
80104d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d2e:	85 f6                	test   %esi,%esi
80104d30:	74 2e                	je     80104d60 <memcmp+0x40>
80104d32:	01 c6                	add    %eax,%esi
80104d34:	eb 14                	jmp    80104d4a <memcmp+0x2a>
80104d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104d40:	83 c0 01             	add    $0x1,%eax
80104d43:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104d46:	39 f0                	cmp    %esi,%eax
80104d48:	74 16                	je     80104d60 <memcmp+0x40>
    if(*s1 != *s2)
80104d4a:	0f b6 0a             	movzbl (%edx),%ecx
80104d4d:	0f b6 18             	movzbl (%eax),%ebx
80104d50:	38 d9                	cmp    %bl,%cl
80104d52:	74 ec                	je     80104d40 <memcmp+0x20>
      return *s1 - *s2;
80104d54:	0f b6 c1             	movzbl %cl,%eax
80104d57:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104d59:	5b                   	pop    %ebx
80104d5a:	5e                   	pop    %esi
80104d5b:	5d                   	pop    %ebp
80104d5c:	c3                   	ret    
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi
80104d60:	5b                   	pop    %ebx
  return 0;
80104d61:	31 c0                	xor    %eax,%eax
}
80104d63:	5e                   	pop    %esi
80104d64:	5d                   	pop    %ebp
80104d65:	c3                   	ret    
80104d66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6d:	8d 76 00             	lea    0x0(%esi),%esi

80104d70 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	57                   	push   %edi
80104d74:	8b 55 08             	mov    0x8(%ebp),%edx
80104d77:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d7a:	56                   	push   %esi
80104d7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d7e:	39 d6                	cmp    %edx,%esi
80104d80:	73 26                	jae    80104da8 <memmove+0x38>
80104d82:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104d85:	39 fa                	cmp    %edi,%edx
80104d87:	73 1f                	jae    80104da8 <memmove+0x38>
80104d89:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104d8c:	85 c9                	test   %ecx,%ecx
80104d8e:	74 0c                	je     80104d9c <memmove+0x2c>
      *--d = *--s;
80104d90:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104d94:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104d97:	83 e8 01             	sub    $0x1,%eax
80104d9a:	73 f4                	jae    80104d90 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104d9c:	5e                   	pop    %esi
80104d9d:	89 d0                	mov    %edx,%eax
80104d9f:	5f                   	pop    %edi
80104da0:	5d                   	pop    %ebp
80104da1:	c3                   	ret    
80104da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104da8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104dab:	89 d7                	mov    %edx,%edi
80104dad:	85 c9                	test   %ecx,%ecx
80104daf:	74 eb                	je     80104d9c <memmove+0x2c>
80104db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104db8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104db9:	39 c6                	cmp    %eax,%esi
80104dbb:	75 fb                	jne    80104db8 <memmove+0x48>
}
80104dbd:	5e                   	pop    %esi
80104dbe:	89 d0                	mov    %edx,%eax
80104dc0:	5f                   	pop    %edi
80104dc1:	5d                   	pop    %ebp
80104dc2:	c3                   	ret    
80104dc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dd0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104dd0:	eb 9e                	jmp    80104d70 <memmove>
80104dd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104de0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	56                   	push   %esi
80104de4:	8b 75 10             	mov    0x10(%ebp),%esi
80104de7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dea:	53                   	push   %ebx
80104deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104dee:	85 f6                	test   %esi,%esi
80104df0:	74 2e                	je     80104e20 <strncmp+0x40>
80104df2:	01 d6                	add    %edx,%esi
80104df4:	eb 18                	jmp    80104e0e <strncmp+0x2e>
80104df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dfd:	8d 76 00             	lea    0x0(%esi),%esi
80104e00:	38 d8                	cmp    %bl,%al
80104e02:	75 14                	jne    80104e18 <strncmp+0x38>
    n--, p++, q++;
80104e04:	83 c2 01             	add    $0x1,%edx
80104e07:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e0a:	39 f2                	cmp    %esi,%edx
80104e0c:	74 12                	je     80104e20 <strncmp+0x40>
80104e0e:	0f b6 01             	movzbl (%ecx),%eax
80104e11:	0f b6 1a             	movzbl (%edx),%ebx
80104e14:	84 c0                	test   %al,%al
80104e16:	75 e8                	jne    80104e00 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104e18:	29 d8                	sub    %ebx,%eax
}
80104e1a:	5b                   	pop    %ebx
80104e1b:	5e                   	pop    %esi
80104e1c:	5d                   	pop    %ebp
80104e1d:	c3                   	ret    
80104e1e:	66 90                	xchg   %ax,%ax
80104e20:	5b                   	pop    %ebx
    return 0;
80104e21:	31 c0                	xor    %eax,%eax
}
80104e23:	5e                   	pop    %esi
80104e24:	5d                   	pop    %ebp
80104e25:	c3                   	ret    
80104e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2d:	8d 76 00             	lea    0x0(%esi),%esi

80104e30 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	57                   	push   %edi
80104e34:	56                   	push   %esi
80104e35:	8b 75 08             	mov    0x8(%ebp),%esi
80104e38:	53                   	push   %ebx
80104e39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e3c:	89 f0                	mov    %esi,%eax
80104e3e:	eb 15                	jmp    80104e55 <strncpy+0x25>
80104e40:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104e44:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104e47:	83 c0 01             	add    $0x1,%eax
80104e4a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104e4e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104e51:	84 d2                	test   %dl,%dl
80104e53:	74 09                	je     80104e5e <strncpy+0x2e>
80104e55:	89 cb                	mov    %ecx,%ebx
80104e57:	83 e9 01             	sub    $0x1,%ecx
80104e5a:	85 db                	test   %ebx,%ebx
80104e5c:	7f e2                	jg     80104e40 <strncpy+0x10>
    ;
  while(n-- > 0)
80104e5e:	89 c2                	mov    %eax,%edx
80104e60:	85 c9                	test   %ecx,%ecx
80104e62:	7e 17                	jle    80104e7b <strncpy+0x4b>
80104e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104e68:	83 c2 01             	add    $0x1,%edx
80104e6b:	89 c1                	mov    %eax,%ecx
80104e6d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104e71:	29 d1                	sub    %edx,%ecx
80104e73:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104e77:	85 c9                	test   %ecx,%ecx
80104e79:	7f ed                	jg     80104e68 <strncpy+0x38>
  return os;
}
80104e7b:	5b                   	pop    %ebx
80104e7c:	89 f0                	mov    %esi,%eax
80104e7e:	5e                   	pop    %esi
80104e7f:	5f                   	pop    %edi
80104e80:	5d                   	pop    %ebp
80104e81:	c3                   	ret    
80104e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e90 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	8b 55 10             	mov    0x10(%ebp),%edx
80104e97:	8b 75 08             	mov    0x8(%ebp),%esi
80104e9a:	53                   	push   %ebx
80104e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104e9e:	85 d2                	test   %edx,%edx
80104ea0:	7e 25                	jle    80104ec7 <safestrcpy+0x37>
80104ea2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104ea6:	89 f2                	mov    %esi,%edx
80104ea8:	eb 16                	jmp    80104ec0 <safestrcpy+0x30>
80104eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104eb0:	0f b6 08             	movzbl (%eax),%ecx
80104eb3:	83 c0 01             	add    $0x1,%eax
80104eb6:	83 c2 01             	add    $0x1,%edx
80104eb9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ebc:	84 c9                	test   %cl,%cl
80104ebe:	74 04                	je     80104ec4 <safestrcpy+0x34>
80104ec0:	39 d8                	cmp    %ebx,%eax
80104ec2:	75 ec                	jne    80104eb0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ec4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104ec7:	89 f0                	mov    %esi,%eax
80104ec9:	5b                   	pop    %ebx
80104eca:	5e                   	pop    %esi
80104ecb:	5d                   	pop    %ebp
80104ecc:	c3                   	ret    
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi

80104ed0 <strlen>:

int
strlen(const char *s)
{
80104ed0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ed1:	31 c0                	xor    %eax,%eax
{
80104ed3:	89 e5                	mov    %esp,%ebp
80104ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ed8:	80 3a 00             	cmpb   $0x0,(%edx)
80104edb:	74 0c                	je     80104ee9 <strlen+0x19>
80104edd:	8d 76 00             	lea    0x0(%esi),%esi
80104ee0:	83 c0 01             	add    $0x1,%eax
80104ee3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ee7:	75 f7                	jne    80104ee0 <strlen+0x10>
    ;
  return n;
}
80104ee9:	5d                   	pop    %ebp
80104eea:	c3                   	ret    

80104eeb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104eeb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104eef:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ef3:	55                   	push   %ebp
  pushl %ebx
80104ef4:	53                   	push   %ebx
  pushl %esi
80104ef5:	56                   	push   %esi
  pushl %edi
80104ef6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ef7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ef9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104efb:	5f                   	pop    %edi
  popl %esi
80104efc:	5e                   	pop    %esi
  popl %ebx
80104efd:	5b                   	pop    %ebx
  popl %ebp
80104efe:	5d                   	pop    %ebp
  ret
80104eff:	c3                   	ret    

80104f00 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	53                   	push   %ebx
80104f04:	83 ec 04             	sub    $0x4,%esp
80104f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f0a:	e8 21 eb ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->mthread->sz || addr+4 > curproc->mthread->sz)
80104f0f:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104f15:	8b 00                	mov    (%eax),%eax
80104f17:	39 d8                	cmp    %ebx,%eax
80104f19:	76 15                	jbe    80104f30 <fetchint+0x30>
80104f1b:	8d 53 04             	lea    0x4(%ebx),%edx
80104f1e:	39 d0                	cmp    %edx,%eax
80104f20:	72 0e                	jb     80104f30 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f22:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f25:	8b 13                	mov    (%ebx),%edx
80104f27:	89 10                	mov    %edx,(%eax)
  return 0;
80104f29:	31 c0                	xor    %eax,%eax
}
80104f2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f2e:	c9                   	leave  
80104f2f:	c3                   	ret    
    return -1;
80104f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f35:	eb f4                	jmp    80104f2b <fetchint+0x2b>
80104f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3e:	66 90                	xchg   %ax,%ax

80104f40 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	53                   	push   %ebx
80104f44:	83 ec 04             	sub    $0x4,%esp
80104f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f4a:	e8 e1 ea ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->mthread->sz)
80104f4f:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80104f55:	39 1a                	cmp    %ebx,(%edx)
80104f57:	76 2f                	jbe    80104f88 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104f59:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f5c:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->mthread->sz;
80104f5e:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104f64:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104f66:	39 d3                	cmp    %edx,%ebx
80104f68:	73 1e                	jae    80104f88 <fetchstr+0x48>
80104f6a:	89 d8                	mov    %ebx,%eax
80104f6c:	eb 09                	jmp    80104f77 <fetchstr+0x37>
80104f6e:	66 90                	xchg   %ax,%ax
80104f70:	83 c0 01             	add    $0x1,%eax
80104f73:	39 c2                	cmp    %eax,%edx
80104f75:	76 11                	jbe    80104f88 <fetchstr+0x48>
    if(*s == 0)
80104f77:	80 38 00             	cmpb   $0x0,(%eax)
80104f7a:	75 f4                	jne    80104f70 <fetchstr+0x30>
      return s - *pp;
80104f7c:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104f7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f81:	c9                   	leave  
80104f82:	c3                   	ret    
80104f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f87:	90                   	nop
80104f88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104f8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f90:	c9                   	leave  
80104f91:	c3                   	ret    
80104f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fa0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fa5:	e8 86 ea ff ff       	call   80103a30 <myproc>
80104faa:	8b 55 08             	mov    0x8(%ebp),%edx
80104fad:	8b 40 18             	mov    0x18(%eax),%eax
80104fb0:	8b 40 44             	mov    0x44(%eax),%eax
80104fb3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104fb6:	e8 75 ea ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fbb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->mthread->sz || addr+4 > curproc->mthread->sz)
80104fbe:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104fc4:	8b 00                	mov    (%eax),%eax
80104fc6:	39 c6                	cmp    %eax,%esi
80104fc8:	73 16                	jae    80104fe0 <argint+0x40>
80104fca:	8d 53 08             	lea    0x8(%ebx),%edx
80104fcd:	39 d0                	cmp    %edx,%eax
80104fcf:	72 0f                	jb     80104fe0 <argint+0x40>
  *ip = *(int*)(addr);
80104fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fd4:	8b 53 04             	mov    0x4(%ebx),%edx
80104fd7:	89 10                	mov    %edx,(%eax)
  return 0;
80104fd9:	31 c0                	xor    %eax,%eax
}
80104fdb:	5b                   	pop    %ebx
80104fdc:	5e                   	pop    %esi
80104fdd:	5d                   	pop    %ebp
80104fde:	c3                   	ret    
80104fdf:	90                   	nop
    return -1;
80104fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fe5:	eb f4                	jmp    80104fdb <argint+0x3b>
80104fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fee:	66 90                	xchg   %ax,%ax

80104ff0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	57                   	push   %edi
80104ff4:	56                   	push   %esi
80104ff5:	53                   	push   %ebx
80104ff6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104ff9:	e8 32 ea ff ff       	call   80103a30 <myproc>
80104ffe:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105000:	e8 2b ea ff ff       	call   80103a30 <myproc>
80105005:	8b 55 08             	mov    0x8(%ebp),%edx
80105008:	8b 40 18             	mov    0x18(%eax),%eax
8010500b:	8b 40 44             	mov    0x44(%eax),%eax
8010500e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105011:	e8 1a ea ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105016:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->mthread->sz || addr+4 > curproc->mthread->sz)
80105019:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010501f:	8b 00                	mov    (%eax),%eax
80105021:	39 c7                	cmp    %eax,%edi
80105023:	73 3b                	jae    80105060 <argptr+0x70>
80105025:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105028:	39 c8                	cmp    %ecx,%eax
8010502a:	72 34                	jb     80105060 <argptr+0x70>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->mthread->sz || (uint)i+size > curproc->mthread->sz)
8010502c:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
8010502f:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->mthread->sz || (uint)i+size > curproc->mthread->sz)
80105032:	85 d2                	test   %edx,%edx
80105034:	78 2a                	js     80105060 <argptr+0x70>
80105036:	8b 96 88 00 00 00    	mov    0x88(%esi),%edx
8010503c:	8b 12                	mov    (%edx),%edx
8010503e:	39 c2                	cmp    %eax,%edx
80105040:	76 1e                	jbe    80105060 <argptr+0x70>
80105042:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105045:	01 c3                	add    %eax,%ebx
80105047:	39 da                	cmp    %ebx,%edx
80105049:	72 15                	jb     80105060 <argptr+0x70>
    return -1;
  *pp = (char*)i;
8010504b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010504e:	89 02                	mov    %eax,(%edx)
  return 0;
80105050:	31 c0                	xor    %eax,%eax
}
80105052:	83 c4 0c             	add    $0xc,%esp
80105055:	5b                   	pop    %ebx
80105056:	5e                   	pop    %esi
80105057:	5f                   	pop    %edi
80105058:	5d                   	pop    %ebp
80105059:	c3                   	ret    
8010505a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105065:	eb eb                	jmp    80105052 <argptr+0x62>
80105067:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010506e:	66 90                	xchg   %ax,%ax

80105070 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	56                   	push   %esi
80105074:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105075:	e8 b6 e9 ff ff       	call   80103a30 <myproc>
8010507a:	8b 55 08             	mov    0x8(%ebp),%edx
8010507d:	8b 40 18             	mov    0x18(%eax),%eax
80105080:	8b 40 44             	mov    0x44(%eax),%eax
80105083:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105086:	e8 a5 e9 ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010508b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->mthread->sz || addr+4 > curproc->mthread->sz)
8010508e:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105094:	8b 00                	mov    (%eax),%eax
80105096:	39 c6                	cmp    %eax,%esi
80105098:	73 4e                	jae    801050e8 <argstr+0x78>
8010509a:	8d 53 08             	lea    0x8(%ebx),%edx
8010509d:	39 d0                	cmp    %edx,%eax
8010509f:	72 47                	jb     801050e8 <argstr+0x78>
  *ip = *(int*)(addr);
801050a1:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801050a4:	e8 87 e9 ff ff       	call   80103a30 <myproc>
  if(addr >= curproc->mthread->sz)
801050a9:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
801050af:	3b 1a                	cmp    (%edx),%ebx
801050b1:	73 35                	jae    801050e8 <argstr+0x78>
  *pp = (char*)addr;
801050b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801050b6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->mthread->sz;
801050b8:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801050be:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801050c0:	39 d3                	cmp    %edx,%ebx
801050c2:	73 24                	jae    801050e8 <argstr+0x78>
801050c4:	89 d8                	mov    %ebx,%eax
801050c6:	eb 0f                	jmp    801050d7 <argstr+0x67>
801050c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050cf:	90                   	nop
801050d0:	83 c0 01             	add    $0x1,%eax
801050d3:	39 c2                	cmp    %eax,%edx
801050d5:	76 11                	jbe    801050e8 <argstr+0x78>
    if(*s == 0)
801050d7:	80 38 00             	cmpb   $0x0,(%eax)
801050da:	75 f4                	jne    801050d0 <argstr+0x60>
      return s - *pp;
801050dc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801050de:	5b                   	pop    %ebx
801050df:	5e                   	pop    %esi
801050e0:	5d                   	pop    %ebp
801050e1:	c3                   	ret    
801050e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050e8:	5b                   	pop    %ebx
    return -1;
801050e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050ee:	5e                   	pop    %esi
801050ef:	5d                   	pop    %ebp
801050f0:	c3                   	ret    
801050f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ff:	90                   	nop

80105100 <syscall>:
[SYS_thread_join]    sys_thread_join,
};

void
syscall(void)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	53                   	push   %ebx
80105104:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105107:	e8 24 e9 ff ff       	call   80103a30 <myproc>
8010510c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010510e:	8b 40 18             	mov    0x18(%eax),%eax
80105111:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105114:	8d 50 ff             	lea    -0x1(%eax),%edx
80105117:	83 fa 17             	cmp    $0x17,%edx
8010511a:	77 24                	ja     80105140 <syscall+0x40>
8010511c:	8b 14 85 c0 80 10 80 	mov    -0x7fef7f40(,%eax,4),%edx
80105123:	85 d2                	test   %edx,%edx
80105125:	74 19                	je     80105140 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105127:	ff d2                	call   *%edx
80105129:	89 c2                	mov    %eax,%edx
8010512b:	8b 43 18             	mov    0x18(%ebx),%eax
8010512e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105134:	c9                   	leave  
80105135:	c3                   	ret    
80105136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010513d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105140:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105141:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105144:	50                   	push   %eax
80105145:	ff 73 10             	push   0x10(%ebx)
80105148:	68 a1 80 10 80       	push   $0x801080a1
8010514d:	e8 4e b5 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80105152:	8b 43 18             	mov    0x18(%ebx),%eax
80105155:	83 c4 10             	add    $0x10,%esp
80105158:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010515f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105162:	c9                   	leave  
80105163:	c3                   	ret    
80105164:	66 90                	xchg   %ax,%ax
80105166:	66 90                	xchg   %ax,%ax
80105168:	66 90                	xchg   %ax,%ax
8010516a:	66 90                	xchg   %ax,%ax
8010516c:	66 90                	xchg   %ax,%ax
8010516e:	66 90                	xchg   %ax,%ax

80105170 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	57                   	push   %edi
80105174:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105175:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105178:	53                   	push   %ebx
80105179:	83 ec 34             	sub    $0x34,%esp
8010517c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010517f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105182:	57                   	push   %edi
80105183:	50                   	push   %eax
{
80105184:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105187:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010518a:	e8 51 cf ff ff       	call   801020e0 <nameiparent>
8010518f:	83 c4 10             	add    $0x10,%esp
80105192:	85 c0                	test   %eax,%eax
80105194:	0f 84 46 01 00 00    	je     801052e0 <create+0x170>
    return 0;
  ilock(dp);
8010519a:	83 ec 0c             	sub    $0xc,%esp
8010519d:	89 c3                	mov    %eax,%ebx
8010519f:	50                   	push   %eax
801051a0:	e8 fb c5 ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801051a5:	83 c4 0c             	add    $0xc,%esp
801051a8:	6a 00                	push   $0x0
801051aa:	57                   	push   %edi
801051ab:	53                   	push   %ebx
801051ac:	e8 4f cb ff ff       	call   80101d00 <dirlookup>
801051b1:	83 c4 10             	add    $0x10,%esp
801051b4:	89 c6                	mov    %eax,%esi
801051b6:	85 c0                	test   %eax,%eax
801051b8:	74 56                	je     80105210 <create+0xa0>
    iunlockput(dp);
801051ba:	83 ec 0c             	sub    $0xc,%esp
801051bd:	53                   	push   %ebx
801051be:	e8 6d c8 ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
801051c3:	89 34 24             	mov    %esi,(%esp)
801051c6:	e8 d5 c5 ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801051cb:	83 c4 10             	add    $0x10,%esp
801051ce:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801051d3:	75 1b                	jne    801051f0 <create+0x80>
801051d5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801051da:	75 14                	jne    801051f0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801051dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051df:	89 f0                	mov    %esi,%eax
801051e1:	5b                   	pop    %ebx
801051e2:	5e                   	pop    %esi
801051e3:	5f                   	pop    %edi
801051e4:	5d                   	pop    %ebp
801051e5:	c3                   	ret    
801051e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801051f0:	83 ec 0c             	sub    $0xc,%esp
801051f3:	56                   	push   %esi
    return 0;
801051f4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801051f6:	e8 35 c8 ff ff       	call   80101a30 <iunlockput>
    return 0;
801051fb:	83 c4 10             	add    $0x10,%esp
}
801051fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105201:	89 f0                	mov    %esi,%eax
80105203:	5b                   	pop    %ebx
80105204:	5e                   	pop    %esi
80105205:	5f                   	pop    %edi
80105206:	5d                   	pop    %ebp
80105207:	c3                   	ret    
80105208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105210:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105214:	83 ec 08             	sub    $0x8,%esp
80105217:	50                   	push   %eax
80105218:	ff 33                	push   (%ebx)
8010521a:	e8 11 c4 ff ff       	call   80101630 <ialloc>
8010521f:	83 c4 10             	add    $0x10,%esp
80105222:	89 c6                	mov    %eax,%esi
80105224:	85 c0                	test   %eax,%eax
80105226:	0f 84 cd 00 00 00    	je     801052f9 <create+0x189>
  ilock(ip);
8010522c:	83 ec 0c             	sub    $0xc,%esp
8010522f:	50                   	push   %eax
80105230:	e8 6b c5 ff ff       	call   801017a0 <ilock>
  ip->major = major;
80105235:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105239:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010523d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105241:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105245:	b8 01 00 00 00       	mov    $0x1,%eax
8010524a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010524e:	89 34 24             	mov    %esi,(%esp)
80105251:	e8 9a c4 ff ff       	call   801016f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105256:	83 c4 10             	add    $0x10,%esp
80105259:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010525e:	74 30                	je     80105290 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105260:	83 ec 04             	sub    $0x4,%esp
80105263:	ff 76 04             	push   0x4(%esi)
80105266:	57                   	push   %edi
80105267:	53                   	push   %ebx
80105268:	e8 93 cd ff ff       	call   80102000 <dirlink>
8010526d:	83 c4 10             	add    $0x10,%esp
80105270:	85 c0                	test   %eax,%eax
80105272:	78 78                	js     801052ec <create+0x17c>
  iunlockput(dp);
80105274:	83 ec 0c             	sub    $0xc,%esp
80105277:	53                   	push   %ebx
80105278:	e8 b3 c7 ff ff       	call   80101a30 <iunlockput>
  return ip;
8010527d:	83 c4 10             	add    $0x10,%esp
}
80105280:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105283:	89 f0                	mov    %esi,%eax
80105285:	5b                   	pop    %ebx
80105286:	5e                   	pop    %esi
80105287:	5f                   	pop    %edi
80105288:	5d                   	pop    %ebp
80105289:	c3                   	ret    
8010528a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105290:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105293:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105298:	53                   	push   %ebx
80105299:	e8 52 c4 ff ff       	call   801016f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010529e:	83 c4 0c             	add    $0xc,%esp
801052a1:	ff 76 04             	push   0x4(%esi)
801052a4:	68 40 81 10 80       	push   $0x80108140
801052a9:	56                   	push   %esi
801052aa:	e8 51 cd ff ff       	call   80102000 <dirlink>
801052af:	83 c4 10             	add    $0x10,%esp
801052b2:	85 c0                	test   %eax,%eax
801052b4:	78 18                	js     801052ce <create+0x15e>
801052b6:	83 ec 04             	sub    $0x4,%esp
801052b9:	ff 73 04             	push   0x4(%ebx)
801052bc:	68 3f 81 10 80       	push   $0x8010813f
801052c1:	56                   	push   %esi
801052c2:	e8 39 cd ff ff       	call   80102000 <dirlink>
801052c7:	83 c4 10             	add    $0x10,%esp
801052ca:	85 c0                	test   %eax,%eax
801052cc:	79 92                	jns    80105260 <create+0xf0>
      panic("create dots");
801052ce:	83 ec 0c             	sub    $0xc,%esp
801052d1:	68 33 81 10 80       	push   $0x80108133
801052d6:	e8 a5 b0 ff ff       	call   80100380 <panic>
801052db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052df:	90                   	nop
}
801052e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801052e3:	31 f6                	xor    %esi,%esi
}
801052e5:	5b                   	pop    %ebx
801052e6:	89 f0                	mov    %esi,%eax
801052e8:	5e                   	pop    %esi
801052e9:	5f                   	pop    %edi
801052ea:	5d                   	pop    %ebp
801052eb:	c3                   	ret    
    panic("create: dirlink");
801052ec:	83 ec 0c             	sub    $0xc,%esp
801052ef:	68 42 81 10 80       	push   $0x80108142
801052f4:	e8 87 b0 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
801052f9:	83 ec 0c             	sub    $0xc,%esp
801052fc:	68 24 81 10 80       	push   $0x80108124
80105301:	e8 7a b0 ff ff       	call   80100380 <panic>
80105306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010530d:	8d 76 00             	lea    0x0(%esi),%esi

80105310 <sys_dup>:
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	56                   	push   %esi
80105314:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105315:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105318:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010531b:	50                   	push   %eax
8010531c:	6a 00                	push   $0x0
8010531e:	e8 7d fc ff ff       	call   80104fa0 <argint>
80105323:	83 c4 10             	add    $0x10,%esp
80105326:	85 c0                	test   %eax,%eax
80105328:	78 36                	js     80105360 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010532a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010532e:	77 30                	ja     80105360 <sys_dup+0x50>
80105330:	e8 fb e6 ff ff       	call   80103a30 <myproc>
80105335:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105338:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010533c:	85 f6                	test   %esi,%esi
8010533e:	74 20                	je     80105360 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105340:	e8 eb e6 ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105345:	31 db                	xor    %ebx,%ebx
80105347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010534e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105350:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105354:	85 d2                	test   %edx,%edx
80105356:	74 18                	je     80105370 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105358:	83 c3 01             	add    $0x1,%ebx
8010535b:	83 fb 10             	cmp    $0x10,%ebx
8010535e:	75 f0                	jne    80105350 <sys_dup+0x40>
}
80105360:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105363:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105368:	89 d8                	mov    %ebx,%eax
8010536a:	5b                   	pop    %ebx
8010536b:	5e                   	pop    %esi
8010536c:	5d                   	pop    %ebp
8010536d:	c3                   	ret    
8010536e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105370:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105373:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105377:	56                   	push   %esi
80105378:	e8 43 bb ff ff       	call   80100ec0 <filedup>
  return fd;
8010537d:	83 c4 10             	add    $0x10,%esp
}
80105380:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105383:	89 d8                	mov    %ebx,%eax
80105385:	5b                   	pop    %ebx
80105386:	5e                   	pop    %esi
80105387:	5d                   	pop    %ebp
80105388:	c3                   	ret    
80105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105390 <sys_read>:
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	56                   	push   %esi
80105394:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105395:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105398:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010539b:	53                   	push   %ebx
8010539c:	6a 00                	push   $0x0
8010539e:	e8 fd fb ff ff       	call   80104fa0 <argint>
801053a3:	83 c4 10             	add    $0x10,%esp
801053a6:	85 c0                	test   %eax,%eax
801053a8:	78 5e                	js     80105408 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801053aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053ae:	77 58                	ja     80105408 <sys_read+0x78>
801053b0:	e8 7b e6 ff ff       	call   80103a30 <myproc>
801053b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053b8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801053bc:	85 f6                	test   %esi,%esi
801053be:	74 48                	je     80105408 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053c0:	83 ec 08             	sub    $0x8,%esp
801053c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053c6:	50                   	push   %eax
801053c7:	6a 02                	push   $0x2
801053c9:	e8 d2 fb ff ff       	call   80104fa0 <argint>
801053ce:	83 c4 10             	add    $0x10,%esp
801053d1:	85 c0                	test   %eax,%eax
801053d3:	78 33                	js     80105408 <sys_read+0x78>
801053d5:	83 ec 04             	sub    $0x4,%esp
801053d8:	ff 75 f0             	push   -0x10(%ebp)
801053db:	53                   	push   %ebx
801053dc:	6a 01                	push   $0x1
801053de:	e8 0d fc ff ff       	call   80104ff0 <argptr>
801053e3:	83 c4 10             	add    $0x10,%esp
801053e6:	85 c0                	test   %eax,%eax
801053e8:	78 1e                	js     80105408 <sys_read+0x78>
  return fileread(f, p, n);
801053ea:	83 ec 04             	sub    $0x4,%esp
801053ed:	ff 75 f0             	push   -0x10(%ebp)
801053f0:	ff 75 f4             	push   -0xc(%ebp)
801053f3:	56                   	push   %esi
801053f4:	e8 47 bc ff ff       	call   80101040 <fileread>
801053f9:	83 c4 10             	add    $0x10,%esp
}
801053fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053ff:	5b                   	pop    %ebx
80105400:	5e                   	pop    %esi
80105401:	5d                   	pop    %ebp
80105402:	c3                   	ret    
80105403:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105407:	90                   	nop
    return -1;
80105408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010540d:	eb ed                	jmp    801053fc <sys_read+0x6c>
8010540f:	90                   	nop

80105410 <sys_write>:
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	56                   	push   %esi
80105414:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105415:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105418:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010541b:	53                   	push   %ebx
8010541c:	6a 00                	push   $0x0
8010541e:	e8 7d fb ff ff       	call   80104fa0 <argint>
80105423:	83 c4 10             	add    $0x10,%esp
80105426:	85 c0                	test   %eax,%eax
80105428:	78 5e                	js     80105488 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010542a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010542e:	77 58                	ja     80105488 <sys_write+0x78>
80105430:	e8 fb e5 ff ff       	call   80103a30 <myproc>
80105435:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105438:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010543c:	85 f6                	test   %esi,%esi
8010543e:	74 48                	je     80105488 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105440:	83 ec 08             	sub    $0x8,%esp
80105443:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105446:	50                   	push   %eax
80105447:	6a 02                	push   $0x2
80105449:	e8 52 fb ff ff       	call   80104fa0 <argint>
8010544e:	83 c4 10             	add    $0x10,%esp
80105451:	85 c0                	test   %eax,%eax
80105453:	78 33                	js     80105488 <sys_write+0x78>
80105455:	83 ec 04             	sub    $0x4,%esp
80105458:	ff 75 f0             	push   -0x10(%ebp)
8010545b:	53                   	push   %ebx
8010545c:	6a 01                	push   $0x1
8010545e:	e8 8d fb ff ff       	call   80104ff0 <argptr>
80105463:	83 c4 10             	add    $0x10,%esp
80105466:	85 c0                	test   %eax,%eax
80105468:	78 1e                	js     80105488 <sys_write+0x78>
  return filewrite(f, p, n);
8010546a:	83 ec 04             	sub    $0x4,%esp
8010546d:	ff 75 f0             	push   -0x10(%ebp)
80105470:	ff 75 f4             	push   -0xc(%ebp)
80105473:	56                   	push   %esi
80105474:	e8 57 bc ff ff       	call   801010d0 <filewrite>
80105479:	83 c4 10             	add    $0x10,%esp
}
8010547c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010547f:	5b                   	pop    %ebx
80105480:	5e                   	pop    %esi
80105481:	5d                   	pop    %ebp
80105482:	c3                   	ret    
80105483:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105487:	90                   	nop
    return -1;
80105488:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010548d:	eb ed                	jmp    8010547c <sys_write+0x6c>
8010548f:	90                   	nop

80105490 <sys_close>:
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	56                   	push   %esi
80105494:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105495:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105498:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010549b:	50                   	push   %eax
8010549c:	6a 00                	push   $0x0
8010549e:	e8 fd fa ff ff       	call   80104fa0 <argint>
801054a3:	83 c4 10             	add    $0x10,%esp
801054a6:	85 c0                	test   %eax,%eax
801054a8:	78 3e                	js     801054e8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054ae:	77 38                	ja     801054e8 <sys_close+0x58>
801054b0:	e8 7b e5 ff ff       	call   80103a30 <myproc>
801054b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054b8:	8d 5a 08             	lea    0x8(%edx),%ebx
801054bb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801054bf:	85 f6                	test   %esi,%esi
801054c1:	74 25                	je     801054e8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801054c3:	e8 68 e5 ff ff       	call   80103a30 <myproc>
  fileclose(f);
801054c8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801054cb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801054d2:	00 
  fileclose(f);
801054d3:	56                   	push   %esi
801054d4:	e8 37 ba ff ff       	call   80100f10 <fileclose>
  return 0;
801054d9:	83 c4 10             	add    $0x10,%esp
801054dc:	31 c0                	xor    %eax,%eax
}
801054de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054e1:	5b                   	pop    %ebx
801054e2:	5e                   	pop    %esi
801054e3:	5d                   	pop    %ebp
801054e4:	c3                   	ret    
801054e5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801054e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ed:	eb ef                	jmp    801054de <sys_close+0x4e>
801054ef:	90                   	nop

801054f0 <sys_fstat>:
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	56                   	push   %esi
801054f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801054f5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801054f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054fb:	53                   	push   %ebx
801054fc:	6a 00                	push   $0x0
801054fe:	e8 9d fa ff ff       	call   80104fa0 <argint>
80105503:	83 c4 10             	add    $0x10,%esp
80105506:	85 c0                	test   %eax,%eax
80105508:	78 46                	js     80105550 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010550a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010550e:	77 40                	ja     80105550 <sys_fstat+0x60>
80105510:	e8 1b e5 ff ff       	call   80103a30 <myproc>
80105515:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105518:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010551c:	85 f6                	test   %esi,%esi
8010551e:	74 30                	je     80105550 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105520:	83 ec 04             	sub    $0x4,%esp
80105523:	6a 14                	push   $0x14
80105525:	53                   	push   %ebx
80105526:	6a 01                	push   $0x1
80105528:	e8 c3 fa ff ff       	call   80104ff0 <argptr>
8010552d:	83 c4 10             	add    $0x10,%esp
80105530:	85 c0                	test   %eax,%eax
80105532:	78 1c                	js     80105550 <sys_fstat+0x60>
  return filestat(f, st);
80105534:	83 ec 08             	sub    $0x8,%esp
80105537:	ff 75 f4             	push   -0xc(%ebp)
8010553a:	56                   	push   %esi
8010553b:	e8 b0 ba ff ff       	call   80100ff0 <filestat>
80105540:	83 c4 10             	add    $0x10,%esp
}
80105543:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105546:	5b                   	pop    %ebx
80105547:	5e                   	pop    %esi
80105548:	5d                   	pop    %ebp
80105549:	c3                   	ret    
8010554a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105555:	eb ec                	jmp    80105543 <sys_fstat+0x53>
80105557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010555e:	66 90                	xchg   %ax,%ax

80105560 <sys_link>:
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	57                   	push   %edi
80105564:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105565:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105568:	53                   	push   %ebx
80105569:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010556c:	50                   	push   %eax
8010556d:	6a 00                	push   $0x0
8010556f:	e8 fc fa ff ff       	call   80105070 <argstr>
80105574:	83 c4 10             	add    $0x10,%esp
80105577:	85 c0                	test   %eax,%eax
80105579:	0f 88 fb 00 00 00    	js     8010567a <sys_link+0x11a>
8010557f:	83 ec 08             	sub    $0x8,%esp
80105582:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105585:	50                   	push   %eax
80105586:	6a 01                	push   $0x1
80105588:	e8 e3 fa ff ff       	call   80105070 <argstr>
8010558d:	83 c4 10             	add    $0x10,%esp
80105590:	85 c0                	test   %eax,%eax
80105592:	0f 88 e2 00 00 00    	js     8010567a <sys_link+0x11a>
  begin_op();
80105598:	e8 e3 d7 ff ff       	call   80102d80 <begin_op>
  if((ip = namei(old)) == 0){
8010559d:	83 ec 0c             	sub    $0xc,%esp
801055a0:	ff 75 d4             	push   -0x2c(%ebp)
801055a3:	e8 18 cb ff ff       	call   801020c0 <namei>
801055a8:	83 c4 10             	add    $0x10,%esp
801055ab:	89 c3                	mov    %eax,%ebx
801055ad:	85 c0                	test   %eax,%eax
801055af:	0f 84 e4 00 00 00    	je     80105699 <sys_link+0x139>
  ilock(ip);
801055b5:	83 ec 0c             	sub    $0xc,%esp
801055b8:	50                   	push   %eax
801055b9:	e8 e2 c1 ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
801055be:	83 c4 10             	add    $0x10,%esp
801055c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055c6:	0f 84 b5 00 00 00    	je     80105681 <sys_link+0x121>
  iupdate(ip);
801055cc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801055cf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801055d4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801055d7:	53                   	push   %ebx
801055d8:	e8 13 c1 ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
801055dd:	89 1c 24             	mov    %ebx,(%esp)
801055e0:	e8 9b c2 ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801055e5:	58                   	pop    %eax
801055e6:	5a                   	pop    %edx
801055e7:	57                   	push   %edi
801055e8:	ff 75 d0             	push   -0x30(%ebp)
801055eb:	e8 f0 ca ff ff       	call   801020e0 <nameiparent>
801055f0:	83 c4 10             	add    $0x10,%esp
801055f3:	89 c6                	mov    %eax,%esi
801055f5:	85 c0                	test   %eax,%eax
801055f7:	74 5b                	je     80105654 <sys_link+0xf4>
  ilock(dp);
801055f9:	83 ec 0c             	sub    $0xc,%esp
801055fc:	50                   	push   %eax
801055fd:	e8 9e c1 ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105602:	8b 03                	mov    (%ebx),%eax
80105604:	83 c4 10             	add    $0x10,%esp
80105607:	39 06                	cmp    %eax,(%esi)
80105609:	75 3d                	jne    80105648 <sys_link+0xe8>
8010560b:	83 ec 04             	sub    $0x4,%esp
8010560e:	ff 73 04             	push   0x4(%ebx)
80105611:	57                   	push   %edi
80105612:	56                   	push   %esi
80105613:	e8 e8 c9 ff ff       	call   80102000 <dirlink>
80105618:	83 c4 10             	add    $0x10,%esp
8010561b:	85 c0                	test   %eax,%eax
8010561d:	78 29                	js     80105648 <sys_link+0xe8>
  iunlockput(dp);
8010561f:	83 ec 0c             	sub    $0xc,%esp
80105622:	56                   	push   %esi
80105623:	e8 08 c4 ff ff       	call   80101a30 <iunlockput>
  iput(ip);
80105628:	89 1c 24             	mov    %ebx,(%esp)
8010562b:	e8 a0 c2 ff ff       	call   801018d0 <iput>
  end_op();
80105630:	e8 bb d7 ff ff       	call   80102df0 <end_op>
  return 0;
80105635:	83 c4 10             	add    $0x10,%esp
80105638:	31 c0                	xor    %eax,%eax
}
8010563a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010563d:	5b                   	pop    %ebx
8010563e:	5e                   	pop    %esi
8010563f:	5f                   	pop    %edi
80105640:	5d                   	pop    %ebp
80105641:	c3                   	ret    
80105642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	56                   	push   %esi
8010564c:	e8 df c3 ff ff       	call   80101a30 <iunlockput>
    goto bad;
80105651:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105654:	83 ec 0c             	sub    $0xc,%esp
80105657:	53                   	push   %ebx
80105658:	e8 43 c1 ff ff       	call   801017a0 <ilock>
  ip->nlink--;
8010565d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105662:	89 1c 24             	mov    %ebx,(%esp)
80105665:	e8 86 c0 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
8010566a:	89 1c 24             	mov    %ebx,(%esp)
8010566d:	e8 be c3 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105672:	e8 79 d7 ff ff       	call   80102df0 <end_op>
  return -1;
80105677:	83 c4 10             	add    $0x10,%esp
8010567a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010567f:	eb b9                	jmp    8010563a <sys_link+0xda>
    iunlockput(ip);
80105681:	83 ec 0c             	sub    $0xc,%esp
80105684:	53                   	push   %ebx
80105685:	e8 a6 c3 ff ff       	call   80101a30 <iunlockput>
    end_op();
8010568a:	e8 61 d7 ff ff       	call   80102df0 <end_op>
    return -1;
8010568f:	83 c4 10             	add    $0x10,%esp
80105692:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105697:	eb a1                	jmp    8010563a <sys_link+0xda>
    end_op();
80105699:	e8 52 d7 ff ff       	call   80102df0 <end_op>
    return -1;
8010569e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a3:	eb 95                	jmp    8010563a <sys_link+0xda>
801056a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056b0 <sys_unlink>:
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	57                   	push   %edi
801056b4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801056b5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801056b8:	53                   	push   %ebx
801056b9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801056bc:	50                   	push   %eax
801056bd:	6a 00                	push   $0x0
801056bf:	e8 ac f9 ff ff       	call   80105070 <argstr>
801056c4:	83 c4 10             	add    $0x10,%esp
801056c7:	85 c0                	test   %eax,%eax
801056c9:	0f 88 7a 01 00 00    	js     80105849 <sys_unlink+0x199>
  begin_op();
801056cf:	e8 ac d6 ff ff       	call   80102d80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801056d4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801056d7:	83 ec 08             	sub    $0x8,%esp
801056da:	53                   	push   %ebx
801056db:	ff 75 c0             	push   -0x40(%ebp)
801056de:	e8 fd c9 ff ff       	call   801020e0 <nameiparent>
801056e3:	83 c4 10             	add    $0x10,%esp
801056e6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801056e9:	85 c0                	test   %eax,%eax
801056eb:	0f 84 62 01 00 00    	je     80105853 <sys_unlink+0x1a3>
  ilock(dp);
801056f1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801056f4:	83 ec 0c             	sub    $0xc,%esp
801056f7:	57                   	push   %edi
801056f8:	e8 a3 c0 ff ff       	call   801017a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801056fd:	58                   	pop    %eax
801056fe:	5a                   	pop    %edx
801056ff:	68 40 81 10 80       	push   $0x80108140
80105704:	53                   	push   %ebx
80105705:	e8 d6 c5 ff ff       	call   80101ce0 <namecmp>
8010570a:	83 c4 10             	add    $0x10,%esp
8010570d:	85 c0                	test   %eax,%eax
8010570f:	0f 84 fb 00 00 00    	je     80105810 <sys_unlink+0x160>
80105715:	83 ec 08             	sub    $0x8,%esp
80105718:	68 3f 81 10 80       	push   $0x8010813f
8010571d:	53                   	push   %ebx
8010571e:	e8 bd c5 ff ff       	call   80101ce0 <namecmp>
80105723:	83 c4 10             	add    $0x10,%esp
80105726:	85 c0                	test   %eax,%eax
80105728:	0f 84 e2 00 00 00    	je     80105810 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010572e:	83 ec 04             	sub    $0x4,%esp
80105731:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105734:	50                   	push   %eax
80105735:	53                   	push   %ebx
80105736:	57                   	push   %edi
80105737:	e8 c4 c5 ff ff       	call   80101d00 <dirlookup>
8010573c:	83 c4 10             	add    $0x10,%esp
8010573f:	89 c3                	mov    %eax,%ebx
80105741:	85 c0                	test   %eax,%eax
80105743:	0f 84 c7 00 00 00    	je     80105810 <sys_unlink+0x160>
  ilock(ip);
80105749:	83 ec 0c             	sub    $0xc,%esp
8010574c:	50                   	push   %eax
8010574d:	e8 4e c0 ff ff       	call   801017a0 <ilock>
  if(ip->nlink < 1)
80105752:	83 c4 10             	add    $0x10,%esp
80105755:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010575a:	0f 8e 1c 01 00 00    	jle    8010587c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105760:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105765:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105768:	74 66                	je     801057d0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010576a:	83 ec 04             	sub    $0x4,%esp
8010576d:	6a 10                	push   $0x10
8010576f:	6a 00                	push   $0x0
80105771:	57                   	push   %edi
80105772:	e8 59 f5 ff ff       	call   80104cd0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105777:	6a 10                	push   $0x10
80105779:	ff 75 c4             	push   -0x3c(%ebp)
8010577c:	57                   	push   %edi
8010577d:	ff 75 b4             	push   -0x4c(%ebp)
80105780:	e8 2b c4 ff ff       	call   80101bb0 <writei>
80105785:	83 c4 20             	add    $0x20,%esp
80105788:	83 f8 10             	cmp    $0x10,%eax
8010578b:	0f 85 de 00 00 00    	jne    8010586f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105791:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105796:	0f 84 94 00 00 00    	je     80105830 <sys_unlink+0x180>
  iunlockput(dp);
8010579c:	83 ec 0c             	sub    $0xc,%esp
8010579f:	ff 75 b4             	push   -0x4c(%ebp)
801057a2:	e8 89 c2 ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
801057a7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057ac:	89 1c 24             	mov    %ebx,(%esp)
801057af:	e8 3c bf ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
801057b4:	89 1c 24             	mov    %ebx,(%esp)
801057b7:	e8 74 c2 ff ff       	call   80101a30 <iunlockput>
  end_op();
801057bc:	e8 2f d6 ff ff       	call   80102df0 <end_op>
  return 0;
801057c1:	83 c4 10             	add    $0x10,%esp
801057c4:	31 c0                	xor    %eax,%eax
}
801057c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057c9:	5b                   	pop    %ebx
801057ca:	5e                   	pop    %esi
801057cb:	5f                   	pop    %edi
801057cc:	5d                   	pop    %ebp
801057cd:	c3                   	ret    
801057ce:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057d0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801057d4:	76 94                	jbe    8010576a <sys_unlink+0xba>
801057d6:	be 20 00 00 00       	mov    $0x20,%esi
801057db:	eb 0b                	jmp    801057e8 <sys_unlink+0x138>
801057dd:	8d 76 00             	lea    0x0(%esi),%esi
801057e0:	83 c6 10             	add    $0x10,%esi
801057e3:	3b 73 58             	cmp    0x58(%ebx),%esi
801057e6:	73 82                	jae    8010576a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057e8:	6a 10                	push   $0x10
801057ea:	56                   	push   %esi
801057eb:	57                   	push   %edi
801057ec:	53                   	push   %ebx
801057ed:	e8 be c2 ff ff       	call   80101ab0 <readi>
801057f2:	83 c4 10             	add    $0x10,%esp
801057f5:	83 f8 10             	cmp    $0x10,%eax
801057f8:	75 68                	jne    80105862 <sys_unlink+0x1b2>
    if(de.inum != 0)
801057fa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801057ff:	74 df                	je     801057e0 <sys_unlink+0x130>
    iunlockput(ip);
80105801:	83 ec 0c             	sub    $0xc,%esp
80105804:	53                   	push   %ebx
80105805:	e8 26 c2 ff ff       	call   80101a30 <iunlockput>
    goto bad;
8010580a:	83 c4 10             	add    $0x10,%esp
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105810:	83 ec 0c             	sub    $0xc,%esp
80105813:	ff 75 b4             	push   -0x4c(%ebp)
80105816:	e8 15 c2 ff ff       	call   80101a30 <iunlockput>
  end_op();
8010581b:	e8 d0 d5 ff ff       	call   80102df0 <end_op>
  return -1;
80105820:	83 c4 10             	add    $0x10,%esp
80105823:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105828:	eb 9c                	jmp    801057c6 <sys_unlink+0x116>
8010582a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105830:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105833:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105836:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010583b:	50                   	push   %eax
8010583c:	e8 af be ff ff       	call   801016f0 <iupdate>
80105841:	83 c4 10             	add    $0x10,%esp
80105844:	e9 53 ff ff ff       	jmp    8010579c <sys_unlink+0xec>
    return -1;
80105849:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584e:	e9 73 ff ff ff       	jmp    801057c6 <sys_unlink+0x116>
    end_op();
80105853:	e8 98 d5 ff ff       	call   80102df0 <end_op>
    return -1;
80105858:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585d:	e9 64 ff ff ff       	jmp    801057c6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105862:	83 ec 0c             	sub    $0xc,%esp
80105865:	68 64 81 10 80       	push   $0x80108164
8010586a:	e8 11 ab ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010586f:	83 ec 0c             	sub    $0xc,%esp
80105872:	68 76 81 10 80       	push   $0x80108176
80105877:	e8 04 ab ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010587c:	83 ec 0c             	sub    $0xc,%esp
8010587f:	68 52 81 10 80       	push   $0x80108152
80105884:	e8 f7 aa ff ff       	call   80100380 <panic>
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105890 <sys_open>:

int
sys_open(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	57                   	push   %edi
80105894:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105895:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105898:	53                   	push   %ebx
80105899:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010589c:	50                   	push   %eax
8010589d:	6a 00                	push   $0x0
8010589f:	e8 cc f7 ff ff       	call   80105070 <argstr>
801058a4:	83 c4 10             	add    $0x10,%esp
801058a7:	85 c0                	test   %eax,%eax
801058a9:	0f 88 8e 00 00 00    	js     8010593d <sys_open+0xad>
801058af:	83 ec 08             	sub    $0x8,%esp
801058b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058b5:	50                   	push   %eax
801058b6:	6a 01                	push   $0x1
801058b8:	e8 e3 f6 ff ff       	call   80104fa0 <argint>
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	85 c0                	test   %eax,%eax
801058c2:	78 79                	js     8010593d <sys_open+0xad>
    return -1;

  begin_op();
801058c4:	e8 b7 d4 ff ff       	call   80102d80 <begin_op>

  if(omode & O_CREATE){
801058c9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801058cd:	75 79                	jne    80105948 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801058cf:	83 ec 0c             	sub    $0xc,%esp
801058d2:	ff 75 e0             	push   -0x20(%ebp)
801058d5:	e8 e6 c7 ff ff       	call   801020c0 <namei>
801058da:	83 c4 10             	add    $0x10,%esp
801058dd:	89 c6                	mov    %eax,%esi
801058df:	85 c0                	test   %eax,%eax
801058e1:	0f 84 7e 00 00 00    	je     80105965 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801058e7:	83 ec 0c             	sub    $0xc,%esp
801058ea:	50                   	push   %eax
801058eb:	e8 b0 be ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801058f0:	83 c4 10             	add    $0x10,%esp
801058f3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801058f8:	0f 84 c2 00 00 00    	je     801059c0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058fe:	e8 4d b5 ff ff       	call   80100e50 <filealloc>
80105903:	89 c7                	mov    %eax,%edi
80105905:	85 c0                	test   %eax,%eax
80105907:	74 23                	je     8010592c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105909:	e8 22 e1 ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010590e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105910:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105914:	85 d2                	test   %edx,%edx
80105916:	74 60                	je     80105978 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105918:	83 c3 01             	add    $0x1,%ebx
8010591b:	83 fb 10             	cmp    $0x10,%ebx
8010591e:	75 f0                	jne    80105910 <sys_open+0x80>
    if(f)
      fileclose(f);
80105920:	83 ec 0c             	sub    $0xc,%esp
80105923:	57                   	push   %edi
80105924:	e8 e7 b5 ff ff       	call   80100f10 <fileclose>
80105929:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010592c:	83 ec 0c             	sub    $0xc,%esp
8010592f:	56                   	push   %esi
80105930:	e8 fb c0 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105935:	e8 b6 d4 ff ff       	call   80102df0 <end_op>
    return -1;
8010593a:	83 c4 10             	add    $0x10,%esp
8010593d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105942:	eb 6d                	jmp    801059b1 <sys_open+0x121>
80105944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105948:	83 ec 0c             	sub    $0xc,%esp
8010594b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010594e:	31 c9                	xor    %ecx,%ecx
80105950:	ba 02 00 00 00       	mov    $0x2,%edx
80105955:	6a 00                	push   $0x0
80105957:	e8 14 f8 ff ff       	call   80105170 <create>
    if(ip == 0){
8010595c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010595f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105961:	85 c0                	test   %eax,%eax
80105963:	75 99                	jne    801058fe <sys_open+0x6e>
      end_op();
80105965:	e8 86 d4 ff ff       	call   80102df0 <end_op>
      return -1;
8010596a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010596f:	eb 40                	jmp    801059b1 <sys_open+0x121>
80105971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105978:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010597b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010597f:	56                   	push   %esi
80105980:	e8 fb be ff ff       	call   80101880 <iunlock>
  end_op();
80105985:	e8 66 d4 ff ff       	call   80102df0 <end_op>

  f->type = FD_INODE;
8010598a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105990:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105993:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105996:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105999:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010599b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801059a2:	f7 d0                	not    %eax
801059a4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059a7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801059aa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059ad:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801059b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059b4:	89 d8                	mov    %ebx,%eax
801059b6:	5b                   	pop    %ebx
801059b7:	5e                   	pop    %esi
801059b8:	5f                   	pop    %edi
801059b9:	5d                   	pop    %ebp
801059ba:	c3                   	ret    
801059bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059bf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801059c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801059c3:	85 c9                	test   %ecx,%ecx
801059c5:	0f 84 33 ff ff ff    	je     801058fe <sys_open+0x6e>
801059cb:	e9 5c ff ff ff       	jmp    8010592c <sys_open+0x9c>

801059d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059d6:	e8 a5 d3 ff ff       	call   80102d80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059db:	83 ec 08             	sub    $0x8,%esp
801059de:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059e1:	50                   	push   %eax
801059e2:	6a 00                	push   $0x0
801059e4:	e8 87 f6 ff ff       	call   80105070 <argstr>
801059e9:	83 c4 10             	add    $0x10,%esp
801059ec:	85 c0                	test   %eax,%eax
801059ee:	78 30                	js     80105a20 <sys_mkdir+0x50>
801059f0:	83 ec 0c             	sub    $0xc,%esp
801059f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059f6:	31 c9                	xor    %ecx,%ecx
801059f8:	ba 01 00 00 00       	mov    $0x1,%edx
801059fd:	6a 00                	push   $0x0
801059ff:	e8 6c f7 ff ff       	call   80105170 <create>
80105a04:	83 c4 10             	add    $0x10,%esp
80105a07:	85 c0                	test   %eax,%eax
80105a09:	74 15                	je     80105a20 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a0b:	83 ec 0c             	sub    $0xc,%esp
80105a0e:	50                   	push   %eax
80105a0f:	e8 1c c0 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105a14:	e8 d7 d3 ff ff       	call   80102df0 <end_op>
  return 0;
80105a19:	83 c4 10             	add    $0x10,%esp
80105a1c:	31 c0                	xor    %eax,%eax
}
80105a1e:	c9                   	leave  
80105a1f:	c3                   	ret    
    end_op();
80105a20:	e8 cb d3 ff ff       	call   80102df0 <end_op>
    return -1;
80105a25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a2a:	c9                   	leave  
80105a2b:	c3                   	ret    
80105a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a30 <sys_mknod>:

int
sys_mknod(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a36:	e8 45 d3 ff ff       	call   80102d80 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a3b:	83 ec 08             	sub    $0x8,%esp
80105a3e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a41:	50                   	push   %eax
80105a42:	6a 00                	push   $0x0
80105a44:	e8 27 f6 ff ff       	call   80105070 <argstr>
80105a49:	83 c4 10             	add    $0x10,%esp
80105a4c:	85 c0                	test   %eax,%eax
80105a4e:	78 60                	js     80105ab0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a50:	83 ec 08             	sub    $0x8,%esp
80105a53:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a56:	50                   	push   %eax
80105a57:	6a 01                	push   $0x1
80105a59:	e8 42 f5 ff ff       	call   80104fa0 <argint>
  if((argstr(0, &path)) < 0 ||
80105a5e:	83 c4 10             	add    $0x10,%esp
80105a61:	85 c0                	test   %eax,%eax
80105a63:	78 4b                	js     80105ab0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105a65:	83 ec 08             	sub    $0x8,%esp
80105a68:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a6b:	50                   	push   %eax
80105a6c:	6a 02                	push   $0x2
80105a6e:	e8 2d f5 ff ff       	call   80104fa0 <argint>
     argint(1, &major) < 0 ||
80105a73:	83 c4 10             	add    $0x10,%esp
80105a76:	85 c0                	test   %eax,%eax
80105a78:	78 36                	js     80105ab0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a7a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105a7e:	83 ec 0c             	sub    $0xc,%esp
80105a81:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105a85:	ba 03 00 00 00       	mov    $0x3,%edx
80105a8a:	50                   	push   %eax
80105a8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a8e:	e8 dd f6 ff ff       	call   80105170 <create>
     argint(2, &minor) < 0 ||
80105a93:	83 c4 10             	add    $0x10,%esp
80105a96:	85 c0                	test   %eax,%eax
80105a98:	74 16                	je     80105ab0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a9a:	83 ec 0c             	sub    $0xc,%esp
80105a9d:	50                   	push   %eax
80105a9e:	e8 8d bf ff ff       	call   80101a30 <iunlockput>
  end_op();
80105aa3:	e8 48 d3 ff ff       	call   80102df0 <end_op>
  return 0;
80105aa8:	83 c4 10             	add    $0x10,%esp
80105aab:	31 c0                	xor    %eax,%eax
}
80105aad:	c9                   	leave  
80105aae:	c3                   	ret    
80105aaf:	90                   	nop
    end_op();
80105ab0:	e8 3b d3 ff ff       	call   80102df0 <end_op>
    return -1;
80105ab5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aba:	c9                   	leave  
80105abb:	c3                   	ret    
80105abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ac0 <sys_chdir>:

int
sys_chdir(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	56                   	push   %esi
80105ac4:	53                   	push   %ebx
80105ac5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ac8:	e8 63 df ff ff       	call   80103a30 <myproc>
80105acd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105acf:	e8 ac d2 ff ff       	call   80102d80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ad4:	83 ec 08             	sub    $0x8,%esp
80105ad7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ada:	50                   	push   %eax
80105adb:	6a 00                	push   $0x0
80105add:	e8 8e f5 ff ff       	call   80105070 <argstr>
80105ae2:	83 c4 10             	add    $0x10,%esp
80105ae5:	85 c0                	test   %eax,%eax
80105ae7:	78 77                	js     80105b60 <sys_chdir+0xa0>
80105ae9:	83 ec 0c             	sub    $0xc,%esp
80105aec:	ff 75 f4             	push   -0xc(%ebp)
80105aef:	e8 cc c5 ff ff       	call   801020c0 <namei>
80105af4:	83 c4 10             	add    $0x10,%esp
80105af7:	89 c3                	mov    %eax,%ebx
80105af9:	85 c0                	test   %eax,%eax
80105afb:	74 63                	je     80105b60 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105afd:	83 ec 0c             	sub    $0xc,%esp
80105b00:	50                   	push   %eax
80105b01:	e8 9a bc ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
80105b06:	83 c4 10             	add    $0x10,%esp
80105b09:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b0e:	75 30                	jne    80105b40 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b10:	83 ec 0c             	sub    $0xc,%esp
80105b13:	53                   	push   %ebx
80105b14:	e8 67 bd ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
80105b19:	58                   	pop    %eax
80105b1a:	ff 76 68             	push   0x68(%esi)
80105b1d:	e8 ae bd ff ff       	call   801018d0 <iput>
  end_op();
80105b22:	e8 c9 d2 ff ff       	call   80102df0 <end_op>
  curproc->cwd = ip;
80105b27:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b2a:	83 c4 10             	add    $0x10,%esp
80105b2d:	31 c0                	xor    %eax,%eax
}
80105b2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b32:	5b                   	pop    %ebx
80105b33:	5e                   	pop    %esi
80105b34:	5d                   	pop    %ebp
80105b35:	c3                   	ret    
80105b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b3d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105b40:	83 ec 0c             	sub    $0xc,%esp
80105b43:	53                   	push   %ebx
80105b44:	e8 e7 be ff ff       	call   80101a30 <iunlockput>
    end_op();
80105b49:	e8 a2 d2 ff ff       	call   80102df0 <end_op>
    return -1;
80105b4e:	83 c4 10             	add    $0x10,%esp
80105b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b56:	eb d7                	jmp    80105b2f <sys_chdir+0x6f>
80105b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5f:	90                   	nop
    end_op();
80105b60:	e8 8b d2 ff ff       	call   80102df0 <end_op>
    return -1;
80105b65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6a:	eb c3                	jmp    80105b2f <sys_chdir+0x6f>
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b70 <sys_exec>:

int
sys_exec(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	57                   	push   %edi
80105b74:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b75:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b7b:	53                   	push   %ebx
80105b7c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b82:	50                   	push   %eax
80105b83:	6a 00                	push   $0x0
80105b85:	e8 e6 f4 ff ff       	call   80105070 <argstr>
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	85 c0                	test   %eax,%eax
80105b8f:	0f 88 87 00 00 00    	js     80105c1c <sys_exec+0xac>
80105b95:	83 ec 08             	sub    $0x8,%esp
80105b98:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b9e:	50                   	push   %eax
80105b9f:	6a 01                	push   $0x1
80105ba1:	e8 fa f3 ff ff       	call   80104fa0 <argint>
80105ba6:	83 c4 10             	add    $0x10,%esp
80105ba9:	85 c0                	test   %eax,%eax
80105bab:	78 6f                	js     80105c1c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105bad:	83 ec 04             	sub    $0x4,%esp
80105bb0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105bb6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105bb8:	68 80 00 00 00       	push   $0x80
80105bbd:	6a 00                	push   $0x0
80105bbf:	56                   	push   %esi
80105bc0:	e8 0b f1 ff ff       	call   80104cd0 <memset>
80105bc5:	83 c4 10             	add    $0x10,%esp
80105bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bcf:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105bd0:	83 ec 08             	sub    $0x8,%esp
80105bd3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105bd9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105be0:	50                   	push   %eax
80105be1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105be7:	01 f8                	add    %edi,%eax
80105be9:	50                   	push   %eax
80105bea:	e8 11 f3 ff ff       	call   80104f00 <fetchint>
80105bef:	83 c4 10             	add    $0x10,%esp
80105bf2:	85 c0                	test   %eax,%eax
80105bf4:	78 26                	js     80105c1c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105bf6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105bfc:	85 c0                	test   %eax,%eax
80105bfe:	74 30                	je     80105c30 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105c00:	83 ec 08             	sub    $0x8,%esp
80105c03:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105c06:	52                   	push   %edx
80105c07:	50                   	push   %eax
80105c08:	e8 33 f3 ff ff       	call   80104f40 <fetchstr>
80105c0d:	83 c4 10             	add    $0x10,%esp
80105c10:	85 c0                	test   %eax,%eax
80105c12:	78 08                	js     80105c1c <sys_exec+0xac>
  for(i=0;; i++){
80105c14:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105c17:	83 fb 20             	cmp    $0x20,%ebx
80105c1a:	75 b4                	jne    80105bd0 <sys_exec+0x60>
      return -1;
  }
  merge(myproc());
  return exec(path, argv);
}
80105c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c24:	5b                   	pop    %ebx
80105c25:	5e                   	pop    %esi
80105c26:	5f                   	pop    %edi
80105c27:	5d                   	pop    %ebp
80105c28:	c3                   	ret    
80105c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105c30:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c37:	00 00 00 00 
  merge(myproc());
80105c3b:	e8 f0 dd ff ff       	call   80103a30 <myproc>
80105c40:	83 ec 0c             	sub    $0xc,%esp
80105c43:	50                   	push   %eax
80105c44:	e8 77 ec ff ff       	call   801048c0 <merge>
  return exec(path, argv);
80105c49:	58                   	pop    %eax
80105c4a:	5a                   	pop    %edx
80105c4b:	56                   	push   %esi
80105c4c:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105c52:	e8 59 ae ff ff       	call   80100ab0 <exec>
80105c57:	83 c4 10             	add    $0x10,%esp
}
80105c5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c5d:	5b                   	pop    %ebx
80105c5e:	5e                   	pop    %esi
80105c5f:	5f                   	pop    %edi
80105c60:	5d                   	pop    %ebp
80105c61:	c3                   	ret    
80105c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c70 <sys_pipe>:

int
sys_pipe(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	57                   	push   %edi
80105c74:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c75:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c78:	53                   	push   %ebx
80105c79:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c7c:	6a 08                	push   $0x8
80105c7e:	50                   	push   %eax
80105c7f:	6a 00                	push   $0x0
80105c81:	e8 6a f3 ff ff       	call   80104ff0 <argptr>
80105c86:	83 c4 10             	add    $0x10,%esp
80105c89:	85 c0                	test   %eax,%eax
80105c8b:	78 4a                	js     80105cd7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c8d:	83 ec 08             	sub    $0x8,%esp
80105c90:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c93:	50                   	push   %eax
80105c94:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c97:	50                   	push   %eax
80105c98:	e8 b3 d7 ff ff       	call   80103450 <pipealloc>
80105c9d:	83 c4 10             	add    $0x10,%esp
80105ca0:	85 c0                	test   %eax,%eax
80105ca2:	78 33                	js     80105cd7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ca4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105ca7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105ca9:	e8 82 dd ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105cb0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105cb4:	85 f6                	test   %esi,%esi
80105cb6:	74 28                	je     80105ce0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105cb8:	83 c3 01             	add    $0x1,%ebx
80105cbb:	83 fb 10             	cmp    $0x10,%ebx
80105cbe:	75 f0                	jne    80105cb0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105cc0:	83 ec 0c             	sub    $0xc,%esp
80105cc3:	ff 75 e0             	push   -0x20(%ebp)
80105cc6:	e8 45 b2 ff ff       	call   80100f10 <fileclose>
    fileclose(wf);
80105ccb:	58                   	pop    %eax
80105ccc:	ff 75 e4             	push   -0x1c(%ebp)
80105ccf:	e8 3c b2 ff ff       	call   80100f10 <fileclose>
    return -1;
80105cd4:	83 c4 10             	add    $0x10,%esp
80105cd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cdc:	eb 53                	jmp    80105d31 <sys_pipe+0xc1>
80105cde:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105ce0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ce3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ce7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105cea:	e8 41 dd ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cef:	31 d2                	xor    %edx,%edx
80105cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105cf8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105cfc:	85 c9                	test   %ecx,%ecx
80105cfe:	74 20                	je     80105d20 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105d00:	83 c2 01             	add    $0x1,%edx
80105d03:	83 fa 10             	cmp    $0x10,%edx
80105d06:	75 f0                	jne    80105cf8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105d08:	e8 23 dd ff ff       	call   80103a30 <myproc>
80105d0d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d14:	00 
80105d15:	eb a9                	jmp    80105cc0 <sys_pipe+0x50>
80105d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105d20:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105d24:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d27:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d29:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d2c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105d2f:	31 c0                	xor    %eax,%eax
}
80105d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d34:	5b                   	pop    %ebx
80105d35:	5e                   	pop    %esi
80105d36:	5f                   	pop    %edi
80105d37:	5d                   	pop    %ebp
80105d38:	c3                   	ret    
80105d39:	66 90                	xchg   %ax,%ax
80105d3b:	66 90                	xchg   %ax,%ax
80105d3d:	66 90                	xchg   %ax,%ax
80105d3f:	90                   	nop

80105d40 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105d40:	e9 9b de ff ff       	jmp    80103be0 <fork>
80105d45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d50 <sys_exit>:
}

int
sys_exit(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	83 ec 08             	sub    $0x8,%esp
  merge(myproc());
80105d56:	e8 d5 dc ff ff       	call   80103a30 <myproc>
80105d5b:	83 ec 0c             	sub    $0xc,%esp
80105d5e:	50                   	push   %eax
80105d5f:	e8 5c eb ff ff       	call   801048c0 <merge>
  if (myproc()->tid == 1)
80105d64:	e8 c7 dc ff ff       	call   80103a30 <myproc>
80105d69:	83 c4 10             	add    $0x10,%esp
80105d6c:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
80105d73:	74 1b                	je     80105d90 <sys_exit+0x40>
    exit();
  else
    thread_exit(0);
80105d75:	83 ec 0c             	sub    $0xc,%esp
80105d78:	6a 00                	push   $0x0
80105d7a:	e8 f1 e0 ff ff       	call   80103e70 <thread_exit>
80105d7f:	83 c4 10             	add    $0x10,%esp
  return 0;  // not reached
}
80105d82:	31 c0                	xor    %eax,%eax
80105d84:	c9                   	leave  
80105d85:	c3                   	ret    
80105d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d8d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105d90:	e8 2b ea ff ff       	call   801047c0 <exit>
}
80105d95:	31 c0                	xor    %eax,%eax
80105d97:	c9                   	leave  
80105d98:	c3                   	ret    
80105d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105da0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105da0:	e9 cb e1 ff ff       	jmp    80103f70 <wait>
80105da5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105db0 <sys_kill>:
}

int
sys_kill(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105db6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105db9:	50                   	push   %eax
80105dba:	6a 00                	push   $0x0
80105dbc:	e8 df f1 ff ff       	call   80104fa0 <argint>
80105dc1:	83 c4 10             	add    $0x10,%esp
80105dc4:	85 c0                	test   %eax,%eax
80105dc6:	78 18                	js     80105de0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105dc8:	83 ec 0c             	sub    $0xc,%esp
80105dcb:	ff 75 f4             	push   -0xc(%ebp)
80105dce:	e8 6d e4 ff ff       	call   80104240 <kill>
80105dd3:	83 c4 10             	add    $0x10,%esp
}
80105dd6:	c9                   	leave  
80105dd7:	c3                   	ret    
80105dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ddf:	90                   	nop
80105de0:	c9                   	leave  
    return -1;
80105de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105de6:	c3                   	ret    
80105de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dee:	66 90                	xchg   %ax,%ax

80105df0 <sys_getpid>:

int
sys_getpid(void)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105df6:	e8 35 dc ff ff       	call   80103a30 <myproc>
80105dfb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105dfe:	c9                   	leave  
80105dff:	c3                   	ret    

80105e00 <sys_sbrk>:

int
sys_sbrk(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105e04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e0a:	50                   	push   %eax
80105e0b:	6a 00                	push   $0x0
80105e0d:	e8 8e f1 ff ff       	call   80104fa0 <argint>
80105e12:	83 c4 10             	add    $0x10,%esp
80105e15:	85 c0                	test   %eax,%eax
80105e17:	78 27                	js     80105e40 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->mthread->sz;
80105e19:	e8 12 dc ff ff       	call   80103a30 <myproc>
  if(growproc(n) < 0)
80105e1e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->mthread->sz;
80105e21:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105e27:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105e29:	ff 75 f4             	push   -0xc(%ebp)
80105e2c:	e8 1f dd ff ff       	call   80103b50 <growproc>
80105e31:	83 c4 10             	add    $0x10,%esp
80105e34:	85 c0                	test   %eax,%eax
80105e36:	78 08                	js     80105e40 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105e38:	89 d8                	mov    %ebx,%eax
80105e3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e3d:	c9                   	leave  
80105e3e:	c3                   	ret    
80105e3f:	90                   	nop
    return -1;
80105e40:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e45:	eb f1                	jmp    80105e38 <sys_sbrk+0x38>
80105e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4e:	66 90                	xchg   %ax,%ax

80105e50 <sys_sleep>:

int
sys_sleep(void)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e5a:	50                   	push   %eax
80105e5b:	6a 00                	push   $0x0
80105e5d:	e8 3e f1 ff ff       	call   80104fa0 <argint>
80105e62:	83 c4 10             	add    $0x10,%esp
80105e65:	85 c0                	test   %eax,%eax
80105e67:	0f 88 8a 00 00 00    	js     80105ef7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e6d:	83 ec 0c             	sub    $0xc,%esp
80105e70:	68 80 51 11 80       	push   $0x80115180
80105e75:	e8 96 ed ff ff       	call   80104c10 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105e7d:	8b 1d 60 51 11 80    	mov    0x80115160,%ebx
  while(ticks - ticks0 < n){
80105e83:	83 c4 10             	add    $0x10,%esp
80105e86:	85 d2                	test   %edx,%edx
80105e88:	75 27                	jne    80105eb1 <sys_sleep+0x61>
80105e8a:	eb 54                	jmp    80105ee0 <sys_sleep+0x90>
80105e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e90:	83 ec 08             	sub    $0x8,%esp
80105e93:	68 80 51 11 80       	push   $0x80115180
80105e98:	68 60 51 11 80       	push   $0x80115160
80105e9d:	e8 7e e2 ff ff       	call   80104120 <sleep>
  while(ticks - ticks0 < n){
80105ea2:	a1 60 51 11 80       	mov    0x80115160,%eax
80105ea7:	83 c4 10             	add    $0x10,%esp
80105eaa:	29 d8                	sub    %ebx,%eax
80105eac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105eaf:	73 2f                	jae    80105ee0 <sys_sleep+0x90>
    if(myproc()->killed){
80105eb1:	e8 7a db ff ff       	call   80103a30 <myproc>
80105eb6:	8b 40 24             	mov    0x24(%eax),%eax
80105eb9:	85 c0                	test   %eax,%eax
80105ebb:	74 d3                	je     80105e90 <sys_sleep+0x40>
      release(&tickslock);
80105ebd:	83 ec 0c             	sub    $0xc,%esp
80105ec0:	68 80 51 11 80       	push   $0x80115180
80105ec5:	e8 e6 ec ff ff       	call   80104bb0 <release>
  }
  release(&tickslock);
  return 0;
}
80105eca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105ecd:	83 c4 10             	add    $0x10,%esp
80105ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ed5:	c9                   	leave  
80105ed6:	c3                   	ret    
80105ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ede:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105ee0:	83 ec 0c             	sub    $0xc,%esp
80105ee3:	68 80 51 11 80       	push   $0x80115180
80105ee8:	e8 c3 ec ff ff       	call   80104bb0 <release>
  return 0;
80105eed:	83 c4 10             	add    $0x10,%esp
80105ef0:	31 c0                	xor    %eax,%eax
}
80105ef2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ef5:	c9                   	leave  
80105ef6:	c3                   	ret    
    return -1;
80105ef7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105efc:	eb f4                	jmp    80105ef2 <sys_sleep+0xa2>
80105efe:	66 90                	xchg   %ax,%ax

80105f00 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	53                   	push   %ebx
80105f04:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105f07:	68 80 51 11 80       	push   $0x80115180
80105f0c:	e8 ff ec ff ff       	call   80104c10 <acquire>
  xticks = ticks;
80105f11:	8b 1d 60 51 11 80    	mov    0x80115160,%ebx
  release(&tickslock);
80105f17:	c7 04 24 80 51 11 80 	movl   $0x80115180,(%esp)
80105f1e:	e8 8d ec ff ff       	call   80104bb0 <release>
  return xticks;
}
80105f23:	89 d8                	mov    %ebx,%eax
80105f25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f28:	c9                   	leave  
80105f29:	c3                   	ret    
80105f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f30 <sys_thread_create>:

int 
sys_thread_create(void)
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	83 ec 1c             	sub    $0x1c,%esp
  char *thread;
  char *start_routine;
  char *arg;

  if (argptr(0, &thread, sizeof(thread_t*)) < 0) 
80105f36:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f39:	6a 04                	push   $0x4
80105f3b:	50                   	push   %eax
80105f3c:	6a 00                	push   $0x0
80105f3e:	e8 ad f0 ff ff       	call   80104ff0 <argptr>
80105f43:	83 c4 10             	add    $0x10,%esp
80105f46:	85 c0                	test   %eax,%eax
80105f48:	78 46                	js     80105f90 <sys_thread_create+0x60>
    return -1;
  if (argptr(1, &start_routine, sizeof(void*(*)(void*))) < 0)
80105f4a:	83 ec 04             	sub    $0x4,%esp
80105f4d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f50:	6a 04                	push   $0x4
80105f52:	50                   	push   %eax
80105f53:	6a 01                	push   $0x1
80105f55:	e8 96 f0 ff ff       	call   80104ff0 <argptr>
80105f5a:	83 c4 10             	add    $0x10,%esp
80105f5d:	85 c0                	test   %eax,%eax
80105f5f:	78 2f                	js     80105f90 <sys_thread_create+0x60>
    return -1;
  if (argptr(2, &arg, sizeof(void*)) < 0) 
80105f61:	83 ec 04             	sub    $0x4,%esp
80105f64:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f67:	6a 04                	push   $0x4
80105f69:	50                   	push   %eax
80105f6a:	6a 02                	push   $0x2
80105f6c:	e8 7f f0 ff ff       	call   80104ff0 <argptr>
80105f71:	83 c4 10             	add    $0x10,%esp
80105f74:	85 c0                	test   %eax,%eax
80105f76:	78 18                	js     80105f90 <sys_thread_create+0x60>
    return -1;
  return thread_create((thread_t*)thread, (void*(*)(void*))start_routine, (void*)arg);
80105f78:	83 ec 04             	sub    $0x4,%esp
80105f7b:	ff 75 f4             	push   -0xc(%ebp)
80105f7e:	ff 75 f0             	push   -0x10(%ebp)
80105f81:	ff 75 ec             	push   -0x14(%ebp)
80105f84:	e8 17 e4 ff ff       	call   801043a0 <thread_create>
80105f89:	83 c4 10             	add    $0x10,%esp
}
80105f8c:	c9                   	leave  
80105f8d:	c3                   	ret    
80105f8e:	66 90                	xchg   %ax,%ax
80105f90:	c9                   	leave  
    return -1;
80105f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f96:	c3                   	ret    
80105f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f9e:	66 90                	xchg   %ax,%ax

80105fa0 <sys_thread_exit>:

int 
sys_thread_exit(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	83 ec 1c             	sub    $0x1c,%esp
  char *retval;
  if (argptr(0, &retval, sizeof(void*)) < 0)
80105fa6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fa9:	6a 04                	push   $0x4
80105fab:	50                   	push   %eax
80105fac:	6a 00                	push   $0x0
80105fae:	e8 3d f0 ff ff       	call   80104ff0 <argptr>
80105fb3:	83 c4 10             	add    $0x10,%esp
80105fb6:	85 c0                	test   %eax,%eax
80105fb8:	78 16                	js     80105fd0 <sys_thread_exit+0x30>
    return -1;
  thread_exit((void*)retval);
80105fba:	83 ec 0c             	sub    $0xc,%esp
80105fbd:	ff 75 f4             	push   -0xc(%ebp)
80105fc0:	e8 ab de ff ff       	call   80103e70 <thread_exit>
  return 0;
80105fc5:	83 c4 10             	add    $0x10,%esp
80105fc8:	31 c0                	xor    %eax,%eax
}
80105fca:	c9                   	leave  
80105fcb:	c3                   	ret    
80105fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fd0:	c9                   	leave  
    return -1;
80105fd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fd6:	c3                   	ret    
80105fd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fde:	66 90                	xchg   %ax,%ax

80105fe0 <sys_thread_join>:

int
sys_thread_join(void)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	83 ec 20             	sub    $0x20,%esp
  int thread;
  char *retval;
  if (argint(0, &thread) < 0)
80105fe6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fe9:	50                   	push   %eax
80105fea:	6a 00                	push   $0x0
80105fec:	e8 af ef ff ff       	call   80104fa0 <argint>
80105ff1:	83 c4 10             	add    $0x10,%esp
80105ff4:	85 c0                	test   %eax,%eax
80105ff6:	78 30                	js     80106028 <sys_thread_join+0x48>
    return -1;
  if (argptr(1, &retval, sizeof(void**)) < 0)
80105ff8:	83 ec 04             	sub    $0x4,%esp
80105ffb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ffe:	6a 04                	push   $0x4
80106000:	50                   	push   %eax
80106001:	6a 01                	push   $0x1
80106003:	e8 e8 ef ff ff       	call   80104ff0 <argptr>
80106008:	83 c4 10             	add    $0x10,%esp
8010600b:	85 c0                	test   %eax,%eax
8010600d:	78 19                	js     80106028 <sys_thread_join+0x48>
    return -1;
  return thread_join((thread_t)thread, (void**)retval);
8010600f:	83 ec 08             	sub    $0x8,%esp
80106012:	ff 75 f4             	push   -0xc(%ebp)
80106015:	ff 75 f0             	push   -0x10(%ebp)
80106018:	e8 03 e5 ff ff       	call   80104520 <thread_join>
8010601d:	83 c4 10             	add    $0x10,%esp
80106020:	c9                   	leave  
80106021:	c3                   	ret    
80106022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106028:	c9                   	leave  
    return -1;
80106029:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010602e:	c3                   	ret    

8010602f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010602f:	1e                   	push   %ds
  pushl %es
80106030:	06                   	push   %es
  pushl %fs
80106031:	0f a0                	push   %fs
  pushl %gs
80106033:	0f a8                	push   %gs
  pushal
80106035:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106036:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010603a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010603c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010603e:	54                   	push   %esp
  call trap
8010603f:	e8 cc 00 00 00       	call   80106110 <trap>
  addl $4, %esp
80106044:	83 c4 04             	add    $0x4,%esp

80106047 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106047:	61                   	popa   
  popl %gs
80106048:	0f a9                	pop    %gs
  popl %fs
8010604a:	0f a1                	pop    %fs
  popl %es
8010604c:	07                   	pop    %es
  popl %ds
8010604d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010604e:	83 c4 08             	add    $0x8,%esp
  iret
80106051:	cf                   	iret   
80106052:	66 90                	xchg   %ax,%ax
80106054:	66 90                	xchg   %ax,%ax
80106056:	66 90                	xchg   %ax,%ax
80106058:	66 90                	xchg   %ax,%ax
8010605a:	66 90                	xchg   %ax,%ax
8010605c:	66 90                	xchg   %ax,%ax
8010605e:	66 90                	xchg   %ax,%ax

80106060 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106060:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106061:	31 c0                	xor    %eax,%eax
{
80106063:	89 e5                	mov    %esp,%ebp
80106065:	83 ec 08             	sub    $0x8,%esp
80106068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010606f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106070:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106077:	c7 04 c5 c2 51 11 80 	movl   $0x8e000008,-0x7feeae3e(,%eax,8)
8010607e:	08 00 00 8e 
80106082:	66 89 14 c5 c0 51 11 	mov    %dx,-0x7feeae40(,%eax,8)
80106089:	80 
8010608a:	c1 ea 10             	shr    $0x10,%edx
8010608d:	66 89 14 c5 c6 51 11 	mov    %dx,-0x7feeae3a(,%eax,8)
80106094:	80 
  for(i = 0; i < 256; i++)
80106095:	83 c0 01             	add    $0x1,%eax
80106098:	3d 00 01 00 00       	cmp    $0x100,%eax
8010609d:	75 d1                	jne    80106070 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010609f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060a2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801060a7:	c7 05 c2 53 11 80 08 	movl   $0xef000008,0x801153c2
801060ae:	00 00 ef 
  initlock(&tickslock, "time");
801060b1:	68 85 81 10 80       	push   $0x80108185
801060b6:	68 80 51 11 80       	push   $0x80115180
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060bb:	66 a3 c0 53 11 80    	mov    %ax,0x801153c0
801060c1:	c1 e8 10             	shr    $0x10,%eax
801060c4:	66 a3 c6 53 11 80    	mov    %ax,0x801153c6
  initlock(&tickslock, "time");
801060ca:	e8 71 e9 ff ff       	call   80104a40 <initlock>
}
801060cf:	83 c4 10             	add    $0x10,%esp
801060d2:	c9                   	leave  
801060d3:	c3                   	ret    
801060d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060df:	90                   	nop

801060e0 <idtinit>:

void
idtinit(void)
{
801060e0:	55                   	push   %ebp
  pd[0] = size-1;
801060e1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801060e6:	89 e5                	mov    %esp,%ebp
801060e8:	83 ec 10             	sub    $0x10,%esp
801060eb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801060ef:	b8 c0 51 11 80       	mov    $0x801151c0,%eax
801060f4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801060f8:	c1 e8 10             	shr    $0x10,%eax
801060fb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801060ff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106102:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106105:	c9                   	leave  
80106106:	c3                   	ret    
80106107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010610e:	66 90                	xchg   %ax,%ax

80106110 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106110:	55                   	push   %ebp
80106111:	89 e5                	mov    %esp,%ebp
80106113:	57                   	push   %edi
80106114:	56                   	push   %esi
80106115:	53                   	push   %ebx
80106116:	83 ec 1c             	sub    $0x1c,%esp
80106119:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010611c:	8b 43 30             	mov    0x30(%ebx),%eax
8010611f:	83 f8 40             	cmp    $0x40,%eax
80106122:	0f 84 68 01 00 00    	je     80106290 <trap+0x180>
      else thread_exit(0);
    }
    return;
  }

  switch(tf->trapno){
80106128:	83 e8 20             	sub    $0x20,%eax
8010612b:	83 f8 1f             	cmp    $0x1f,%eax
8010612e:	0f 87 8c 00 00 00    	ja     801061c0 <trap+0xb0>
80106134:	ff 24 85 2c 82 10 80 	jmp    *-0x7fef7dd4(,%eax,4)
8010613b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010613f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106140:	e8 1b c1 ff ff       	call   80102260 <ideintr>
    lapiceoi();
80106145:	e8 e6 c7 ff ff       	call   80102930 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER){
8010614a:	e8 e1 d8 ff ff       	call   80103a30 <myproc>
8010614f:	85 c0                	test   %eax,%eax
80106151:	74 1d                	je     80106170 <trap+0x60>
80106153:	e8 d8 d8 ff ff       	call   80103a30 <myproc>
80106158:	8b 50 24             	mov    0x24(%eax),%edx
8010615b:	85 d2                	test   %edx,%edx
8010615d:	74 11                	je     80106170 <trap+0x60>
8010615f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106163:	83 e0 03             	and    $0x3,%eax
80106166:	66 83 f8 03          	cmp    $0x3,%ax
8010616a:	0f 84 00 02 00 00    	je     80106370 <trap+0x260>
    else thread_exit(0);
  }

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106170:	e8 bb d8 ff ff       	call   80103a30 <myproc>
80106175:	85 c0                	test   %eax,%eax
80106177:	74 0f                	je     80106188 <trap+0x78>
80106179:	e8 b2 d8 ff ff       	call   80103a30 <myproc>
8010617e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106182:	0f 84 b8 00 00 00    	je     80106240 <trap+0x130>
      // procdump();
      yield();
    }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER){
80106188:	e8 a3 d8 ff ff       	call   80103a30 <myproc>
8010618d:	85 c0                	test   %eax,%eax
8010618f:	74 1d                	je     801061ae <trap+0x9e>
80106191:	e8 9a d8 ff ff       	call   80103a30 <myproc>
80106196:	8b 40 24             	mov    0x24(%eax),%eax
80106199:	85 c0                	test   %eax,%eax
8010619b:	74 11                	je     801061ae <trap+0x9e>
8010619d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801061a1:	83 e0 03             	and    $0x3,%eax
801061a4:	66 83 f8 03          	cmp    $0x3,%ax
801061a8:	0f 84 0f 01 00 00    	je     801062bd <trap+0x1ad>
    if (myproc()->tid == 1) exit();
    else thread_exit(0);
  }

}
801061ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061b1:	5b                   	pop    %ebx
801061b2:	5e                   	pop    %esi
801061b3:	5f                   	pop    %edi
801061b4:	5d                   	pop    %ebp
801061b5:	c3                   	ret    
801061b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
801061c0:	e8 6b d8 ff ff       	call   80103a30 <myproc>
801061c5:	8b 7b 38             	mov    0x38(%ebx),%edi
801061c8:	85 c0                	test   %eax,%eax
801061ca:	0f 84 0a 02 00 00    	je     801063da <trap+0x2ca>
801061d0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801061d4:	0f 84 00 02 00 00    	je     801063da <trap+0x2ca>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801061da:	0f 20 d1             	mov    %cr2,%ecx
801061dd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061e0:	e8 2b d8 ff ff       	call   80103a10 <cpuid>
801061e5:	8b 73 30             	mov    0x30(%ebx),%esi
801061e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801061eb:	8b 43 34             	mov    0x34(%ebx),%eax
801061ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801061f1:	e8 3a d8 ff ff       	call   80103a30 <myproc>
801061f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801061f9:	e8 32 d8 ff ff       	call   80103a30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061fe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106201:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106204:	51                   	push   %ecx
80106205:	57                   	push   %edi
80106206:	52                   	push   %edx
80106207:	ff 75 e4             	push   -0x1c(%ebp)
8010620a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010620b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010620e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106211:	56                   	push   %esi
80106212:	ff 70 10             	push   0x10(%eax)
80106215:	68 e8 81 10 80       	push   $0x801081e8
8010621a:	e8 81 a4 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
8010621f:	83 c4 20             	add    $0x20,%esp
80106222:	e8 09 d8 ff ff       	call   80103a30 <myproc>
80106227:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER){
8010622e:	e8 fd d7 ff ff       	call   80103a30 <myproc>
80106233:	85 c0                	test   %eax,%eax
80106235:	0f 85 18 ff ff ff    	jne    80106153 <trap+0x43>
8010623b:	e9 30 ff ff ff       	jmp    80106170 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106240:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106244:	0f 85 3e ff ff ff    	jne    80106188 <trap+0x78>
      yield();
8010624a:	e8 81 de ff ff       	call   801040d0 <yield>
8010624f:	e9 34 ff ff ff       	jmp    80106188 <trap+0x78>
80106254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106258:	8b 7b 38             	mov    0x38(%ebx),%edi
8010625b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010625f:	e8 ac d7 ff ff       	call   80103a10 <cpuid>
80106264:	57                   	push   %edi
80106265:	56                   	push   %esi
80106266:	50                   	push   %eax
80106267:	68 90 81 10 80       	push   $0x80108190
8010626c:	e8 2f a4 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106271:	e8 ba c6 ff ff       	call   80102930 <lapiceoi>
    break;
80106276:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER){
80106279:	e8 b2 d7 ff ff       	call   80103a30 <myproc>
8010627e:	85 c0                	test   %eax,%eax
80106280:	0f 85 cd fe ff ff    	jne    80106153 <trap+0x43>
80106286:	e9 e5 fe ff ff       	jmp    80106170 <trap+0x60>
8010628b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010628f:	90                   	nop
    if(myproc()->killed){
80106290:	e8 9b d7 ff ff       	call   80103a30 <myproc>
80106295:	8b 70 24             	mov    0x24(%eax),%esi
80106298:	85 f6                	test   %esi,%esi
8010629a:	0f 85 f0 00 00 00    	jne    80106390 <trap+0x280>
    myproc()->tf = tf;
801062a0:	e8 8b d7 ff ff       	call   80103a30 <myproc>
801062a5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801062a8:	e8 53 ee ff ff       	call   80105100 <syscall>
    if(myproc()->killed){
801062ad:	e8 7e d7 ff ff       	call   80103a30 <myproc>
801062b2:	8b 48 24             	mov    0x24(%eax),%ecx
801062b5:	85 c9                	test   %ecx,%ecx
801062b7:	0f 84 f1 fe ff ff    	je     801061ae <trap+0x9e>
      if(myproc()->tid == 1) exit();
801062bd:	e8 6e d7 ff ff       	call   80103a30 <myproc>
801062c2:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
801062c9:	0f 84 e1 00 00 00    	je     801063b0 <trap+0x2a0>
      else thread_exit(0);
801062cf:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
801062d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062d9:	5b                   	pop    %ebx
801062da:	5e                   	pop    %esi
801062db:	5f                   	pop    %edi
801062dc:	5d                   	pop    %ebp
      else thread_exit(0);
801062dd:	e9 8e db ff ff       	jmp    80103e70 <thread_exit>
801062e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartintr();
801062e8:	e8 93 02 00 00       	call   80106580 <uartintr>
    lapiceoi();
801062ed:	e8 3e c6 ff ff       	call   80102930 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER){
801062f2:	e8 39 d7 ff ff       	call   80103a30 <myproc>
801062f7:	85 c0                	test   %eax,%eax
801062f9:	0f 85 54 fe ff ff    	jne    80106153 <trap+0x43>
801062ff:	e9 6c fe ff ff       	jmp    80106170 <trap+0x60>
80106304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106308:	e8 e3 c4 ff ff       	call   801027f0 <kbdintr>
    lapiceoi();
8010630d:	e8 1e c6 ff ff       	call   80102930 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER){
80106312:	e8 19 d7 ff ff       	call   80103a30 <myproc>
80106317:	85 c0                	test   %eax,%eax
80106319:	0f 85 34 fe ff ff    	jne    80106153 <trap+0x43>
8010631f:	e9 4c fe ff ff       	jmp    80106170 <trap+0x60>
80106324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106328:	e8 e3 d6 ff ff       	call   80103a10 <cpuid>
8010632d:	85 c0                	test   %eax,%eax
8010632f:	0f 85 10 fe ff ff    	jne    80106145 <trap+0x35>
      acquire(&tickslock);
80106335:	83 ec 0c             	sub    $0xc,%esp
80106338:	68 80 51 11 80       	push   $0x80115180
8010633d:	e8 ce e8 ff ff       	call   80104c10 <acquire>
      wakeup(&ticks);
80106342:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
      ticks++;
80106349:	83 05 60 51 11 80 01 	addl   $0x1,0x80115160
      wakeup(&ticks);
80106350:	e8 8b de ff ff       	call   801041e0 <wakeup>
      release(&tickslock);
80106355:	c7 04 24 80 51 11 80 	movl   $0x80115180,(%esp)
8010635c:	e8 4f e8 ff ff       	call   80104bb0 <release>
80106361:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106364:	e9 dc fd ff ff       	jmp    80106145 <trap+0x35>
80106369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->tid == 1) exit();
80106370:	e8 bb d6 ff ff       	call   80103a30 <myproc>
80106375:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
8010637c:	74 42                	je     801063c0 <trap+0x2b0>
    else thread_exit(0);
8010637e:	83 ec 0c             	sub    $0xc,%esp
80106381:	6a 00                	push   $0x0
80106383:	e8 e8 da ff ff       	call   80103e70 <thread_exit>
80106388:	83 c4 10             	add    $0x10,%esp
8010638b:	e9 e0 fd ff ff       	jmp    80106170 <trap+0x60>
      if(myproc()->tid == 1) exit();
80106390:	e8 9b d6 ff ff       	call   80103a30 <myproc>
80106395:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
8010639c:	74 32                	je     801063d0 <trap+0x2c0>
      else thread_exit(0);
8010639e:	83 ec 0c             	sub    $0xc,%esp
801063a1:	6a 00                	push   $0x0
801063a3:	e8 c8 da ff ff       	call   80103e70 <thread_exit>
801063a8:	83 c4 10             	add    $0x10,%esp
801063ab:	e9 f0 fe ff ff       	jmp    801062a0 <trap+0x190>
}
801063b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063b3:	5b                   	pop    %ebx
801063b4:	5e                   	pop    %esi
801063b5:	5f                   	pop    %edi
801063b6:	5d                   	pop    %ebp
      if(myproc()->tid == 1) exit();
801063b7:	e9 04 e4 ff ff       	jmp    801047c0 <exit>
801063bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->tid == 1) exit();
801063c0:	e8 fb e3 ff ff       	call   801047c0 <exit>
801063c5:	e9 a6 fd ff ff       	jmp    80106170 <trap+0x60>
801063ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(myproc()->tid == 1) exit();
801063d0:	e8 eb e3 ff ff       	call   801047c0 <exit>
801063d5:	e9 c6 fe ff ff       	jmp    801062a0 <trap+0x190>
801063da:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801063dd:	e8 2e d6 ff ff       	call   80103a10 <cpuid>
801063e2:	83 ec 0c             	sub    $0xc,%esp
801063e5:	56                   	push   %esi
801063e6:	57                   	push   %edi
801063e7:	50                   	push   %eax
801063e8:	ff 73 30             	push   0x30(%ebx)
801063eb:	68 b4 81 10 80       	push   $0x801081b4
801063f0:	e8 ab a2 ff ff       	call   801006a0 <cprintf>
      panic("trap");
801063f5:	83 c4 14             	add    $0x14,%esp
801063f8:	68 8a 81 10 80       	push   $0x8010818a
801063fd:	e8 7e 9f ff ff       	call   80100380 <panic>
80106402:	66 90                	xchg   %ax,%ax
80106404:	66 90                	xchg   %ax,%ax
80106406:	66 90                	xchg   %ax,%ax
80106408:	66 90                	xchg   %ax,%ax
8010640a:	66 90                	xchg   %ax,%ax
8010640c:	66 90                	xchg   %ax,%ax
8010640e:	66 90                	xchg   %ax,%ax

80106410 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106410:	a1 c0 59 11 80       	mov    0x801159c0,%eax
80106415:	85 c0                	test   %eax,%eax
80106417:	74 17                	je     80106430 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106419:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010641e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010641f:	a8 01                	test   $0x1,%al
80106421:	74 0d                	je     80106430 <uartgetc+0x20>
80106423:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106428:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106429:	0f b6 c0             	movzbl %al,%eax
8010642c:	c3                   	ret    
8010642d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106435:	c3                   	ret    
80106436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010643d:	8d 76 00             	lea    0x0(%esi),%esi

80106440 <uartinit>:
{
80106440:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106441:	31 c9                	xor    %ecx,%ecx
80106443:	89 c8                	mov    %ecx,%eax
80106445:	89 e5                	mov    %esp,%ebp
80106447:	57                   	push   %edi
80106448:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010644d:	56                   	push   %esi
8010644e:	89 fa                	mov    %edi,%edx
80106450:	53                   	push   %ebx
80106451:	83 ec 1c             	sub    $0x1c,%esp
80106454:	ee                   	out    %al,(%dx)
80106455:	be fb 03 00 00       	mov    $0x3fb,%esi
8010645a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010645f:	89 f2                	mov    %esi,%edx
80106461:	ee                   	out    %al,(%dx)
80106462:	b8 0c 00 00 00       	mov    $0xc,%eax
80106467:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010646c:	ee                   	out    %al,(%dx)
8010646d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106472:	89 c8                	mov    %ecx,%eax
80106474:	89 da                	mov    %ebx,%edx
80106476:	ee                   	out    %al,(%dx)
80106477:	b8 03 00 00 00       	mov    $0x3,%eax
8010647c:	89 f2                	mov    %esi,%edx
8010647e:	ee                   	out    %al,(%dx)
8010647f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106484:	89 c8                	mov    %ecx,%eax
80106486:	ee                   	out    %al,(%dx)
80106487:	b8 01 00 00 00       	mov    $0x1,%eax
8010648c:	89 da                	mov    %ebx,%edx
8010648e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010648f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106494:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106495:	3c ff                	cmp    $0xff,%al
80106497:	74 78                	je     80106511 <uartinit+0xd1>
  uart = 1;
80106499:	c7 05 c0 59 11 80 01 	movl   $0x1,0x801159c0
801064a0:	00 00 00 
801064a3:	89 fa                	mov    %edi,%edx
801064a5:	ec                   	in     (%dx),%al
801064a6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064ab:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801064ac:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801064af:	bf ac 82 10 80       	mov    $0x801082ac,%edi
801064b4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801064b9:	6a 00                	push   $0x0
801064bb:	6a 04                	push   $0x4
801064bd:	e8 de bf ff ff       	call   801024a0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801064c2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801064c6:	83 c4 10             	add    $0x10,%esp
801064c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801064d0:	a1 c0 59 11 80       	mov    0x801159c0,%eax
801064d5:	bb 80 00 00 00       	mov    $0x80,%ebx
801064da:	85 c0                	test   %eax,%eax
801064dc:	75 14                	jne    801064f2 <uartinit+0xb2>
801064de:	eb 23                	jmp    80106503 <uartinit+0xc3>
    microdelay(10);
801064e0:	83 ec 0c             	sub    $0xc,%esp
801064e3:	6a 0a                	push   $0xa
801064e5:	e8 66 c4 ff ff       	call   80102950 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064ea:	83 c4 10             	add    $0x10,%esp
801064ed:	83 eb 01             	sub    $0x1,%ebx
801064f0:	74 07                	je     801064f9 <uartinit+0xb9>
801064f2:	89 f2                	mov    %esi,%edx
801064f4:	ec                   	in     (%dx),%al
801064f5:	a8 20                	test   $0x20,%al
801064f7:	74 e7                	je     801064e0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064f9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801064fd:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106502:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106503:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106507:	83 c7 01             	add    $0x1,%edi
8010650a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010650d:	84 c0                	test   %al,%al
8010650f:	75 bf                	jne    801064d0 <uartinit+0x90>
}
80106511:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106514:	5b                   	pop    %ebx
80106515:	5e                   	pop    %esi
80106516:	5f                   	pop    %edi
80106517:	5d                   	pop    %ebp
80106518:	c3                   	ret    
80106519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106520 <uartputc>:
  if(!uart)
80106520:	a1 c0 59 11 80       	mov    0x801159c0,%eax
80106525:	85 c0                	test   %eax,%eax
80106527:	74 47                	je     80106570 <uartputc+0x50>
{
80106529:	55                   	push   %ebp
8010652a:	89 e5                	mov    %esp,%ebp
8010652c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010652d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106532:	53                   	push   %ebx
80106533:	bb 80 00 00 00       	mov    $0x80,%ebx
80106538:	eb 18                	jmp    80106552 <uartputc+0x32>
8010653a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106540:	83 ec 0c             	sub    $0xc,%esp
80106543:	6a 0a                	push   $0xa
80106545:	e8 06 c4 ff ff       	call   80102950 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010654a:	83 c4 10             	add    $0x10,%esp
8010654d:	83 eb 01             	sub    $0x1,%ebx
80106550:	74 07                	je     80106559 <uartputc+0x39>
80106552:	89 f2                	mov    %esi,%edx
80106554:	ec                   	in     (%dx),%al
80106555:	a8 20                	test   $0x20,%al
80106557:	74 e7                	je     80106540 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106559:	8b 45 08             	mov    0x8(%ebp),%eax
8010655c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106561:	ee                   	out    %al,(%dx)
}
80106562:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106565:	5b                   	pop    %ebx
80106566:	5e                   	pop    %esi
80106567:	5d                   	pop    %ebp
80106568:	c3                   	ret    
80106569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106570:	c3                   	ret    
80106571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106578:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010657f:	90                   	nop

80106580 <uartintr>:

void
uartintr(void)
{
80106580:	55                   	push   %ebp
80106581:	89 e5                	mov    %esp,%ebp
80106583:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106586:	68 10 64 10 80       	push   $0x80106410
8010658b:	e8 f0 a2 ff ff       	call   80100880 <consoleintr>
}
80106590:	83 c4 10             	add    $0x10,%esp
80106593:	c9                   	leave  
80106594:	c3                   	ret    

80106595 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106595:	6a 00                	push   $0x0
  pushl $0
80106597:	6a 00                	push   $0x0
  jmp alltraps
80106599:	e9 91 fa ff ff       	jmp    8010602f <alltraps>

8010659e <vector1>:
.globl vector1
vector1:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $1
801065a0:	6a 01                	push   $0x1
  jmp alltraps
801065a2:	e9 88 fa ff ff       	jmp    8010602f <alltraps>

801065a7 <vector2>:
.globl vector2
vector2:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $2
801065a9:	6a 02                	push   $0x2
  jmp alltraps
801065ab:	e9 7f fa ff ff       	jmp    8010602f <alltraps>

801065b0 <vector3>:
.globl vector3
vector3:
  pushl $0
801065b0:	6a 00                	push   $0x0
  pushl $3
801065b2:	6a 03                	push   $0x3
  jmp alltraps
801065b4:	e9 76 fa ff ff       	jmp    8010602f <alltraps>

801065b9 <vector4>:
.globl vector4
vector4:
  pushl $0
801065b9:	6a 00                	push   $0x0
  pushl $4
801065bb:	6a 04                	push   $0x4
  jmp alltraps
801065bd:	e9 6d fa ff ff       	jmp    8010602f <alltraps>

801065c2 <vector5>:
.globl vector5
vector5:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $5
801065c4:	6a 05                	push   $0x5
  jmp alltraps
801065c6:	e9 64 fa ff ff       	jmp    8010602f <alltraps>

801065cb <vector6>:
.globl vector6
vector6:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $6
801065cd:	6a 06                	push   $0x6
  jmp alltraps
801065cf:	e9 5b fa ff ff       	jmp    8010602f <alltraps>

801065d4 <vector7>:
.globl vector7
vector7:
  pushl $0
801065d4:	6a 00                	push   $0x0
  pushl $7
801065d6:	6a 07                	push   $0x7
  jmp alltraps
801065d8:	e9 52 fa ff ff       	jmp    8010602f <alltraps>

801065dd <vector8>:
.globl vector8
vector8:
  pushl $8
801065dd:	6a 08                	push   $0x8
  jmp alltraps
801065df:	e9 4b fa ff ff       	jmp    8010602f <alltraps>

801065e4 <vector9>:
.globl vector9
vector9:
  pushl $0
801065e4:	6a 00                	push   $0x0
  pushl $9
801065e6:	6a 09                	push   $0x9
  jmp alltraps
801065e8:	e9 42 fa ff ff       	jmp    8010602f <alltraps>

801065ed <vector10>:
.globl vector10
vector10:
  pushl $10
801065ed:	6a 0a                	push   $0xa
  jmp alltraps
801065ef:	e9 3b fa ff ff       	jmp    8010602f <alltraps>

801065f4 <vector11>:
.globl vector11
vector11:
  pushl $11
801065f4:	6a 0b                	push   $0xb
  jmp alltraps
801065f6:	e9 34 fa ff ff       	jmp    8010602f <alltraps>

801065fb <vector12>:
.globl vector12
vector12:
  pushl $12
801065fb:	6a 0c                	push   $0xc
  jmp alltraps
801065fd:	e9 2d fa ff ff       	jmp    8010602f <alltraps>

80106602 <vector13>:
.globl vector13
vector13:
  pushl $13
80106602:	6a 0d                	push   $0xd
  jmp alltraps
80106604:	e9 26 fa ff ff       	jmp    8010602f <alltraps>

80106609 <vector14>:
.globl vector14
vector14:
  pushl $14
80106609:	6a 0e                	push   $0xe
  jmp alltraps
8010660b:	e9 1f fa ff ff       	jmp    8010602f <alltraps>

80106610 <vector15>:
.globl vector15
vector15:
  pushl $0
80106610:	6a 00                	push   $0x0
  pushl $15
80106612:	6a 0f                	push   $0xf
  jmp alltraps
80106614:	e9 16 fa ff ff       	jmp    8010602f <alltraps>

80106619 <vector16>:
.globl vector16
vector16:
  pushl $0
80106619:	6a 00                	push   $0x0
  pushl $16
8010661b:	6a 10                	push   $0x10
  jmp alltraps
8010661d:	e9 0d fa ff ff       	jmp    8010602f <alltraps>

80106622 <vector17>:
.globl vector17
vector17:
  pushl $17
80106622:	6a 11                	push   $0x11
  jmp alltraps
80106624:	e9 06 fa ff ff       	jmp    8010602f <alltraps>

80106629 <vector18>:
.globl vector18
vector18:
  pushl $0
80106629:	6a 00                	push   $0x0
  pushl $18
8010662b:	6a 12                	push   $0x12
  jmp alltraps
8010662d:	e9 fd f9 ff ff       	jmp    8010602f <alltraps>

80106632 <vector19>:
.globl vector19
vector19:
  pushl $0
80106632:	6a 00                	push   $0x0
  pushl $19
80106634:	6a 13                	push   $0x13
  jmp alltraps
80106636:	e9 f4 f9 ff ff       	jmp    8010602f <alltraps>

8010663b <vector20>:
.globl vector20
vector20:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $20
8010663d:	6a 14                	push   $0x14
  jmp alltraps
8010663f:	e9 eb f9 ff ff       	jmp    8010602f <alltraps>

80106644 <vector21>:
.globl vector21
vector21:
  pushl $0
80106644:	6a 00                	push   $0x0
  pushl $21
80106646:	6a 15                	push   $0x15
  jmp alltraps
80106648:	e9 e2 f9 ff ff       	jmp    8010602f <alltraps>

8010664d <vector22>:
.globl vector22
vector22:
  pushl $0
8010664d:	6a 00                	push   $0x0
  pushl $22
8010664f:	6a 16                	push   $0x16
  jmp alltraps
80106651:	e9 d9 f9 ff ff       	jmp    8010602f <alltraps>

80106656 <vector23>:
.globl vector23
vector23:
  pushl $0
80106656:	6a 00                	push   $0x0
  pushl $23
80106658:	6a 17                	push   $0x17
  jmp alltraps
8010665a:	e9 d0 f9 ff ff       	jmp    8010602f <alltraps>

8010665f <vector24>:
.globl vector24
vector24:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $24
80106661:	6a 18                	push   $0x18
  jmp alltraps
80106663:	e9 c7 f9 ff ff       	jmp    8010602f <alltraps>

80106668 <vector25>:
.globl vector25
vector25:
  pushl $0
80106668:	6a 00                	push   $0x0
  pushl $25
8010666a:	6a 19                	push   $0x19
  jmp alltraps
8010666c:	e9 be f9 ff ff       	jmp    8010602f <alltraps>

80106671 <vector26>:
.globl vector26
vector26:
  pushl $0
80106671:	6a 00                	push   $0x0
  pushl $26
80106673:	6a 1a                	push   $0x1a
  jmp alltraps
80106675:	e9 b5 f9 ff ff       	jmp    8010602f <alltraps>

8010667a <vector27>:
.globl vector27
vector27:
  pushl $0
8010667a:	6a 00                	push   $0x0
  pushl $27
8010667c:	6a 1b                	push   $0x1b
  jmp alltraps
8010667e:	e9 ac f9 ff ff       	jmp    8010602f <alltraps>

80106683 <vector28>:
.globl vector28
vector28:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $28
80106685:	6a 1c                	push   $0x1c
  jmp alltraps
80106687:	e9 a3 f9 ff ff       	jmp    8010602f <alltraps>

8010668c <vector29>:
.globl vector29
vector29:
  pushl $0
8010668c:	6a 00                	push   $0x0
  pushl $29
8010668e:	6a 1d                	push   $0x1d
  jmp alltraps
80106690:	e9 9a f9 ff ff       	jmp    8010602f <alltraps>

80106695 <vector30>:
.globl vector30
vector30:
  pushl $0
80106695:	6a 00                	push   $0x0
  pushl $30
80106697:	6a 1e                	push   $0x1e
  jmp alltraps
80106699:	e9 91 f9 ff ff       	jmp    8010602f <alltraps>

8010669e <vector31>:
.globl vector31
vector31:
  pushl $0
8010669e:	6a 00                	push   $0x0
  pushl $31
801066a0:	6a 1f                	push   $0x1f
  jmp alltraps
801066a2:	e9 88 f9 ff ff       	jmp    8010602f <alltraps>

801066a7 <vector32>:
.globl vector32
vector32:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $32
801066a9:	6a 20                	push   $0x20
  jmp alltraps
801066ab:	e9 7f f9 ff ff       	jmp    8010602f <alltraps>

801066b0 <vector33>:
.globl vector33
vector33:
  pushl $0
801066b0:	6a 00                	push   $0x0
  pushl $33
801066b2:	6a 21                	push   $0x21
  jmp alltraps
801066b4:	e9 76 f9 ff ff       	jmp    8010602f <alltraps>

801066b9 <vector34>:
.globl vector34
vector34:
  pushl $0
801066b9:	6a 00                	push   $0x0
  pushl $34
801066bb:	6a 22                	push   $0x22
  jmp alltraps
801066bd:	e9 6d f9 ff ff       	jmp    8010602f <alltraps>

801066c2 <vector35>:
.globl vector35
vector35:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $35
801066c4:	6a 23                	push   $0x23
  jmp alltraps
801066c6:	e9 64 f9 ff ff       	jmp    8010602f <alltraps>

801066cb <vector36>:
.globl vector36
vector36:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $36
801066cd:	6a 24                	push   $0x24
  jmp alltraps
801066cf:	e9 5b f9 ff ff       	jmp    8010602f <alltraps>

801066d4 <vector37>:
.globl vector37
vector37:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $37
801066d6:	6a 25                	push   $0x25
  jmp alltraps
801066d8:	e9 52 f9 ff ff       	jmp    8010602f <alltraps>

801066dd <vector38>:
.globl vector38
vector38:
  pushl $0
801066dd:	6a 00                	push   $0x0
  pushl $38
801066df:	6a 26                	push   $0x26
  jmp alltraps
801066e1:	e9 49 f9 ff ff       	jmp    8010602f <alltraps>

801066e6 <vector39>:
.globl vector39
vector39:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $39
801066e8:	6a 27                	push   $0x27
  jmp alltraps
801066ea:	e9 40 f9 ff ff       	jmp    8010602f <alltraps>

801066ef <vector40>:
.globl vector40
vector40:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $40
801066f1:	6a 28                	push   $0x28
  jmp alltraps
801066f3:	e9 37 f9 ff ff       	jmp    8010602f <alltraps>

801066f8 <vector41>:
.globl vector41
vector41:
  pushl $0
801066f8:	6a 00                	push   $0x0
  pushl $41
801066fa:	6a 29                	push   $0x29
  jmp alltraps
801066fc:	e9 2e f9 ff ff       	jmp    8010602f <alltraps>

80106701 <vector42>:
.globl vector42
vector42:
  pushl $0
80106701:	6a 00                	push   $0x0
  pushl $42
80106703:	6a 2a                	push   $0x2a
  jmp alltraps
80106705:	e9 25 f9 ff ff       	jmp    8010602f <alltraps>

8010670a <vector43>:
.globl vector43
vector43:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $43
8010670c:	6a 2b                	push   $0x2b
  jmp alltraps
8010670e:	e9 1c f9 ff ff       	jmp    8010602f <alltraps>

80106713 <vector44>:
.globl vector44
vector44:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $44
80106715:	6a 2c                	push   $0x2c
  jmp alltraps
80106717:	e9 13 f9 ff ff       	jmp    8010602f <alltraps>

8010671c <vector45>:
.globl vector45
vector45:
  pushl $0
8010671c:	6a 00                	push   $0x0
  pushl $45
8010671e:	6a 2d                	push   $0x2d
  jmp alltraps
80106720:	e9 0a f9 ff ff       	jmp    8010602f <alltraps>

80106725 <vector46>:
.globl vector46
vector46:
  pushl $0
80106725:	6a 00                	push   $0x0
  pushl $46
80106727:	6a 2e                	push   $0x2e
  jmp alltraps
80106729:	e9 01 f9 ff ff       	jmp    8010602f <alltraps>

8010672e <vector47>:
.globl vector47
vector47:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $47
80106730:	6a 2f                	push   $0x2f
  jmp alltraps
80106732:	e9 f8 f8 ff ff       	jmp    8010602f <alltraps>

80106737 <vector48>:
.globl vector48
vector48:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $48
80106739:	6a 30                	push   $0x30
  jmp alltraps
8010673b:	e9 ef f8 ff ff       	jmp    8010602f <alltraps>

80106740 <vector49>:
.globl vector49
vector49:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $49
80106742:	6a 31                	push   $0x31
  jmp alltraps
80106744:	e9 e6 f8 ff ff       	jmp    8010602f <alltraps>

80106749 <vector50>:
.globl vector50
vector50:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $50
8010674b:	6a 32                	push   $0x32
  jmp alltraps
8010674d:	e9 dd f8 ff ff       	jmp    8010602f <alltraps>

80106752 <vector51>:
.globl vector51
vector51:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $51
80106754:	6a 33                	push   $0x33
  jmp alltraps
80106756:	e9 d4 f8 ff ff       	jmp    8010602f <alltraps>

8010675b <vector52>:
.globl vector52
vector52:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $52
8010675d:	6a 34                	push   $0x34
  jmp alltraps
8010675f:	e9 cb f8 ff ff       	jmp    8010602f <alltraps>

80106764 <vector53>:
.globl vector53
vector53:
  pushl $0
80106764:	6a 00                	push   $0x0
  pushl $53
80106766:	6a 35                	push   $0x35
  jmp alltraps
80106768:	e9 c2 f8 ff ff       	jmp    8010602f <alltraps>

8010676d <vector54>:
.globl vector54
vector54:
  pushl $0
8010676d:	6a 00                	push   $0x0
  pushl $54
8010676f:	6a 36                	push   $0x36
  jmp alltraps
80106771:	e9 b9 f8 ff ff       	jmp    8010602f <alltraps>

80106776 <vector55>:
.globl vector55
vector55:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $55
80106778:	6a 37                	push   $0x37
  jmp alltraps
8010677a:	e9 b0 f8 ff ff       	jmp    8010602f <alltraps>

8010677f <vector56>:
.globl vector56
vector56:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $56
80106781:	6a 38                	push   $0x38
  jmp alltraps
80106783:	e9 a7 f8 ff ff       	jmp    8010602f <alltraps>

80106788 <vector57>:
.globl vector57
vector57:
  pushl $0
80106788:	6a 00                	push   $0x0
  pushl $57
8010678a:	6a 39                	push   $0x39
  jmp alltraps
8010678c:	e9 9e f8 ff ff       	jmp    8010602f <alltraps>

80106791 <vector58>:
.globl vector58
vector58:
  pushl $0
80106791:	6a 00                	push   $0x0
  pushl $58
80106793:	6a 3a                	push   $0x3a
  jmp alltraps
80106795:	e9 95 f8 ff ff       	jmp    8010602f <alltraps>

8010679a <vector59>:
.globl vector59
vector59:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $59
8010679c:	6a 3b                	push   $0x3b
  jmp alltraps
8010679e:	e9 8c f8 ff ff       	jmp    8010602f <alltraps>

801067a3 <vector60>:
.globl vector60
vector60:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $60
801067a5:	6a 3c                	push   $0x3c
  jmp alltraps
801067a7:	e9 83 f8 ff ff       	jmp    8010602f <alltraps>

801067ac <vector61>:
.globl vector61
vector61:
  pushl $0
801067ac:	6a 00                	push   $0x0
  pushl $61
801067ae:	6a 3d                	push   $0x3d
  jmp alltraps
801067b0:	e9 7a f8 ff ff       	jmp    8010602f <alltraps>

801067b5 <vector62>:
.globl vector62
vector62:
  pushl $0
801067b5:	6a 00                	push   $0x0
  pushl $62
801067b7:	6a 3e                	push   $0x3e
  jmp alltraps
801067b9:	e9 71 f8 ff ff       	jmp    8010602f <alltraps>

801067be <vector63>:
.globl vector63
vector63:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $63
801067c0:	6a 3f                	push   $0x3f
  jmp alltraps
801067c2:	e9 68 f8 ff ff       	jmp    8010602f <alltraps>

801067c7 <vector64>:
.globl vector64
vector64:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $64
801067c9:	6a 40                	push   $0x40
  jmp alltraps
801067cb:	e9 5f f8 ff ff       	jmp    8010602f <alltraps>

801067d0 <vector65>:
.globl vector65
vector65:
  pushl $0
801067d0:	6a 00                	push   $0x0
  pushl $65
801067d2:	6a 41                	push   $0x41
  jmp alltraps
801067d4:	e9 56 f8 ff ff       	jmp    8010602f <alltraps>

801067d9 <vector66>:
.globl vector66
vector66:
  pushl $0
801067d9:	6a 00                	push   $0x0
  pushl $66
801067db:	6a 42                	push   $0x42
  jmp alltraps
801067dd:	e9 4d f8 ff ff       	jmp    8010602f <alltraps>

801067e2 <vector67>:
.globl vector67
vector67:
  pushl $0
801067e2:	6a 00                	push   $0x0
  pushl $67
801067e4:	6a 43                	push   $0x43
  jmp alltraps
801067e6:	e9 44 f8 ff ff       	jmp    8010602f <alltraps>

801067eb <vector68>:
.globl vector68
vector68:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $68
801067ed:	6a 44                	push   $0x44
  jmp alltraps
801067ef:	e9 3b f8 ff ff       	jmp    8010602f <alltraps>

801067f4 <vector69>:
.globl vector69
vector69:
  pushl $0
801067f4:	6a 00                	push   $0x0
  pushl $69
801067f6:	6a 45                	push   $0x45
  jmp alltraps
801067f8:	e9 32 f8 ff ff       	jmp    8010602f <alltraps>

801067fd <vector70>:
.globl vector70
vector70:
  pushl $0
801067fd:	6a 00                	push   $0x0
  pushl $70
801067ff:	6a 46                	push   $0x46
  jmp alltraps
80106801:	e9 29 f8 ff ff       	jmp    8010602f <alltraps>

80106806 <vector71>:
.globl vector71
vector71:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $71
80106808:	6a 47                	push   $0x47
  jmp alltraps
8010680a:	e9 20 f8 ff ff       	jmp    8010602f <alltraps>

8010680f <vector72>:
.globl vector72
vector72:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $72
80106811:	6a 48                	push   $0x48
  jmp alltraps
80106813:	e9 17 f8 ff ff       	jmp    8010602f <alltraps>

80106818 <vector73>:
.globl vector73
vector73:
  pushl $0
80106818:	6a 00                	push   $0x0
  pushl $73
8010681a:	6a 49                	push   $0x49
  jmp alltraps
8010681c:	e9 0e f8 ff ff       	jmp    8010602f <alltraps>

80106821 <vector74>:
.globl vector74
vector74:
  pushl $0
80106821:	6a 00                	push   $0x0
  pushl $74
80106823:	6a 4a                	push   $0x4a
  jmp alltraps
80106825:	e9 05 f8 ff ff       	jmp    8010602f <alltraps>

8010682a <vector75>:
.globl vector75
vector75:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $75
8010682c:	6a 4b                	push   $0x4b
  jmp alltraps
8010682e:	e9 fc f7 ff ff       	jmp    8010602f <alltraps>

80106833 <vector76>:
.globl vector76
vector76:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $76
80106835:	6a 4c                	push   $0x4c
  jmp alltraps
80106837:	e9 f3 f7 ff ff       	jmp    8010602f <alltraps>

8010683c <vector77>:
.globl vector77
vector77:
  pushl $0
8010683c:	6a 00                	push   $0x0
  pushl $77
8010683e:	6a 4d                	push   $0x4d
  jmp alltraps
80106840:	e9 ea f7 ff ff       	jmp    8010602f <alltraps>

80106845 <vector78>:
.globl vector78
vector78:
  pushl $0
80106845:	6a 00                	push   $0x0
  pushl $78
80106847:	6a 4e                	push   $0x4e
  jmp alltraps
80106849:	e9 e1 f7 ff ff       	jmp    8010602f <alltraps>

8010684e <vector79>:
.globl vector79
vector79:
  pushl $0
8010684e:	6a 00                	push   $0x0
  pushl $79
80106850:	6a 4f                	push   $0x4f
  jmp alltraps
80106852:	e9 d8 f7 ff ff       	jmp    8010602f <alltraps>

80106857 <vector80>:
.globl vector80
vector80:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $80
80106859:	6a 50                	push   $0x50
  jmp alltraps
8010685b:	e9 cf f7 ff ff       	jmp    8010602f <alltraps>

80106860 <vector81>:
.globl vector81
vector81:
  pushl $0
80106860:	6a 00                	push   $0x0
  pushl $81
80106862:	6a 51                	push   $0x51
  jmp alltraps
80106864:	e9 c6 f7 ff ff       	jmp    8010602f <alltraps>

80106869 <vector82>:
.globl vector82
vector82:
  pushl $0
80106869:	6a 00                	push   $0x0
  pushl $82
8010686b:	6a 52                	push   $0x52
  jmp alltraps
8010686d:	e9 bd f7 ff ff       	jmp    8010602f <alltraps>

80106872 <vector83>:
.globl vector83
vector83:
  pushl $0
80106872:	6a 00                	push   $0x0
  pushl $83
80106874:	6a 53                	push   $0x53
  jmp alltraps
80106876:	e9 b4 f7 ff ff       	jmp    8010602f <alltraps>

8010687b <vector84>:
.globl vector84
vector84:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $84
8010687d:	6a 54                	push   $0x54
  jmp alltraps
8010687f:	e9 ab f7 ff ff       	jmp    8010602f <alltraps>

80106884 <vector85>:
.globl vector85
vector85:
  pushl $0
80106884:	6a 00                	push   $0x0
  pushl $85
80106886:	6a 55                	push   $0x55
  jmp alltraps
80106888:	e9 a2 f7 ff ff       	jmp    8010602f <alltraps>

8010688d <vector86>:
.globl vector86
vector86:
  pushl $0
8010688d:	6a 00                	push   $0x0
  pushl $86
8010688f:	6a 56                	push   $0x56
  jmp alltraps
80106891:	e9 99 f7 ff ff       	jmp    8010602f <alltraps>

80106896 <vector87>:
.globl vector87
vector87:
  pushl $0
80106896:	6a 00                	push   $0x0
  pushl $87
80106898:	6a 57                	push   $0x57
  jmp alltraps
8010689a:	e9 90 f7 ff ff       	jmp    8010602f <alltraps>

8010689f <vector88>:
.globl vector88
vector88:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $88
801068a1:	6a 58                	push   $0x58
  jmp alltraps
801068a3:	e9 87 f7 ff ff       	jmp    8010602f <alltraps>

801068a8 <vector89>:
.globl vector89
vector89:
  pushl $0
801068a8:	6a 00                	push   $0x0
  pushl $89
801068aa:	6a 59                	push   $0x59
  jmp alltraps
801068ac:	e9 7e f7 ff ff       	jmp    8010602f <alltraps>

801068b1 <vector90>:
.globl vector90
vector90:
  pushl $0
801068b1:	6a 00                	push   $0x0
  pushl $90
801068b3:	6a 5a                	push   $0x5a
  jmp alltraps
801068b5:	e9 75 f7 ff ff       	jmp    8010602f <alltraps>

801068ba <vector91>:
.globl vector91
vector91:
  pushl $0
801068ba:	6a 00                	push   $0x0
  pushl $91
801068bc:	6a 5b                	push   $0x5b
  jmp alltraps
801068be:	e9 6c f7 ff ff       	jmp    8010602f <alltraps>

801068c3 <vector92>:
.globl vector92
vector92:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $92
801068c5:	6a 5c                	push   $0x5c
  jmp alltraps
801068c7:	e9 63 f7 ff ff       	jmp    8010602f <alltraps>

801068cc <vector93>:
.globl vector93
vector93:
  pushl $0
801068cc:	6a 00                	push   $0x0
  pushl $93
801068ce:	6a 5d                	push   $0x5d
  jmp alltraps
801068d0:	e9 5a f7 ff ff       	jmp    8010602f <alltraps>

801068d5 <vector94>:
.globl vector94
vector94:
  pushl $0
801068d5:	6a 00                	push   $0x0
  pushl $94
801068d7:	6a 5e                	push   $0x5e
  jmp alltraps
801068d9:	e9 51 f7 ff ff       	jmp    8010602f <alltraps>

801068de <vector95>:
.globl vector95
vector95:
  pushl $0
801068de:	6a 00                	push   $0x0
  pushl $95
801068e0:	6a 5f                	push   $0x5f
  jmp alltraps
801068e2:	e9 48 f7 ff ff       	jmp    8010602f <alltraps>

801068e7 <vector96>:
.globl vector96
vector96:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $96
801068e9:	6a 60                	push   $0x60
  jmp alltraps
801068eb:	e9 3f f7 ff ff       	jmp    8010602f <alltraps>

801068f0 <vector97>:
.globl vector97
vector97:
  pushl $0
801068f0:	6a 00                	push   $0x0
  pushl $97
801068f2:	6a 61                	push   $0x61
  jmp alltraps
801068f4:	e9 36 f7 ff ff       	jmp    8010602f <alltraps>

801068f9 <vector98>:
.globl vector98
vector98:
  pushl $0
801068f9:	6a 00                	push   $0x0
  pushl $98
801068fb:	6a 62                	push   $0x62
  jmp alltraps
801068fd:	e9 2d f7 ff ff       	jmp    8010602f <alltraps>

80106902 <vector99>:
.globl vector99
vector99:
  pushl $0
80106902:	6a 00                	push   $0x0
  pushl $99
80106904:	6a 63                	push   $0x63
  jmp alltraps
80106906:	e9 24 f7 ff ff       	jmp    8010602f <alltraps>

8010690b <vector100>:
.globl vector100
vector100:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $100
8010690d:	6a 64                	push   $0x64
  jmp alltraps
8010690f:	e9 1b f7 ff ff       	jmp    8010602f <alltraps>

80106914 <vector101>:
.globl vector101
vector101:
  pushl $0
80106914:	6a 00                	push   $0x0
  pushl $101
80106916:	6a 65                	push   $0x65
  jmp alltraps
80106918:	e9 12 f7 ff ff       	jmp    8010602f <alltraps>

8010691d <vector102>:
.globl vector102
vector102:
  pushl $0
8010691d:	6a 00                	push   $0x0
  pushl $102
8010691f:	6a 66                	push   $0x66
  jmp alltraps
80106921:	e9 09 f7 ff ff       	jmp    8010602f <alltraps>

80106926 <vector103>:
.globl vector103
vector103:
  pushl $0
80106926:	6a 00                	push   $0x0
  pushl $103
80106928:	6a 67                	push   $0x67
  jmp alltraps
8010692a:	e9 00 f7 ff ff       	jmp    8010602f <alltraps>

8010692f <vector104>:
.globl vector104
vector104:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $104
80106931:	6a 68                	push   $0x68
  jmp alltraps
80106933:	e9 f7 f6 ff ff       	jmp    8010602f <alltraps>

80106938 <vector105>:
.globl vector105
vector105:
  pushl $0
80106938:	6a 00                	push   $0x0
  pushl $105
8010693a:	6a 69                	push   $0x69
  jmp alltraps
8010693c:	e9 ee f6 ff ff       	jmp    8010602f <alltraps>

80106941 <vector106>:
.globl vector106
vector106:
  pushl $0
80106941:	6a 00                	push   $0x0
  pushl $106
80106943:	6a 6a                	push   $0x6a
  jmp alltraps
80106945:	e9 e5 f6 ff ff       	jmp    8010602f <alltraps>

8010694a <vector107>:
.globl vector107
vector107:
  pushl $0
8010694a:	6a 00                	push   $0x0
  pushl $107
8010694c:	6a 6b                	push   $0x6b
  jmp alltraps
8010694e:	e9 dc f6 ff ff       	jmp    8010602f <alltraps>

80106953 <vector108>:
.globl vector108
vector108:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $108
80106955:	6a 6c                	push   $0x6c
  jmp alltraps
80106957:	e9 d3 f6 ff ff       	jmp    8010602f <alltraps>

8010695c <vector109>:
.globl vector109
vector109:
  pushl $0
8010695c:	6a 00                	push   $0x0
  pushl $109
8010695e:	6a 6d                	push   $0x6d
  jmp alltraps
80106960:	e9 ca f6 ff ff       	jmp    8010602f <alltraps>

80106965 <vector110>:
.globl vector110
vector110:
  pushl $0
80106965:	6a 00                	push   $0x0
  pushl $110
80106967:	6a 6e                	push   $0x6e
  jmp alltraps
80106969:	e9 c1 f6 ff ff       	jmp    8010602f <alltraps>

8010696e <vector111>:
.globl vector111
vector111:
  pushl $0
8010696e:	6a 00                	push   $0x0
  pushl $111
80106970:	6a 6f                	push   $0x6f
  jmp alltraps
80106972:	e9 b8 f6 ff ff       	jmp    8010602f <alltraps>

80106977 <vector112>:
.globl vector112
vector112:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $112
80106979:	6a 70                	push   $0x70
  jmp alltraps
8010697b:	e9 af f6 ff ff       	jmp    8010602f <alltraps>

80106980 <vector113>:
.globl vector113
vector113:
  pushl $0
80106980:	6a 00                	push   $0x0
  pushl $113
80106982:	6a 71                	push   $0x71
  jmp alltraps
80106984:	e9 a6 f6 ff ff       	jmp    8010602f <alltraps>

80106989 <vector114>:
.globl vector114
vector114:
  pushl $0
80106989:	6a 00                	push   $0x0
  pushl $114
8010698b:	6a 72                	push   $0x72
  jmp alltraps
8010698d:	e9 9d f6 ff ff       	jmp    8010602f <alltraps>

80106992 <vector115>:
.globl vector115
vector115:
  pushl $0
80106992:	6a 00                	push   $0x0
  pushl $115
80106994:	6a 73                	push   $0x73
  jmp alltraps
80106996:	e9 94 f6 ff ff       	jmp    8010602f <alltraps>

8010699b <vector116>:
.globl vector116
vector116:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $116
8010699d:	6a 74                	push   $0x74
  jmp alltraps
8010699f:	e9 8b f6 ff ff       	jmp    8010602f <alltraps>

801069a4 <vector117>:
.globl vector117
vector117:
  pushl $0
801069a4:	6a 00                	push   $0x0
  pushl $117
801069a6:	6a 75                	push   $0x75
  jmp alltraps
801069a8:	e9 82 f6 ff ff       	jmp    8010602f <alltraps>

801069ad <vector118>:
.globl vector118
vector118:
  pushl $0
801069ad:	6a 00                	push   $0x0
  pushl $118
801069af:	6a 76                	push   $0x76
  jmp alltraps
801069b1:	e9 79 f6 ff ff       	jmp    8010602f <alltraps>

801069b6 <vector119>:
.globl vector119
vector119:
  pushl $0
801069b6:	6a 00                	push   $0x0
  pushl $119
801069b8:	6a 77                	push   $0x77
  jmp alltraps
801069ba:	e9 70 f6 ff ff       	jmp    8010602f <alltraps>

801069bf <vector120>:
.globl vector120
vector120:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $120
801069c1:	6a 78                	push   $0x78
  jmp alltraps
801069c3:	e9 67 f6 ff ff       	jmp    8010602f <alltraps>

801069c8 <vector121>:
.globl vector121
vector121:
  pushl $0
801069c8:	6a 00                	push   $0x0
  pushl $121
801069ca:	6a 79                	push   $0x79
  jmp alltraps
801069cc:	e9 5e f6 ff ff       	jmp    8010602f <alltraps>

801069d1 <vector122>:
.globl vector122
vector122:
  pushl $0
801069d1:	6a 00                	push   $0x0
  pushl $122
801069d3:	6a 7a                	push   $0x7a
  jmp alltraps
801069d5:	e9 55 f6 ff ff       	jmp    8010602f <alltraps>

801069da <vector123>:
.globl vector123
vector123:
  pushl $0
801069da:	6a 00                	push   $0x0
  pushl $123
801069dc:	6a 7b                	push   $0x7b
  jmp alltraps
801069de:	e9 4c f6 ff ff       	jmp    8010602f <alltraps>

801069e3 <vector124>:
.globl vector124
vector124:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $124
801069e5:	6a 7c                	push   $0x7c
  jmp alltraps
801069e7:	e9 43 f6 ff ff       	jmp    8010602f <alltraps>

801069ec <vector125>:
.globl vector125
vector125:
  pushl $0
801069ec:	6a 00                	push   $0x0
  pushl $125
801069ee:	6a 7d                	push   $0x7d
  jmp alltraps
801069f0:	e9 3a f6 ff ff       	jmp    8010602f <alltraps>

801069f5 <vector126>:
.globl vector126
vector126:
  pushl $0
801069f5:	6a 00                	push   $0x0
  pushl $126
801069f7:	6a 7e                	push   $0x7e
  jmp alltraps
801069f9:	e9 31 f6 ff ff       	jmp    8010602f <alltraps>

801069fe <vector127>:
.globl vector127
vector127:
  pushl $0
801069fe:	6a 00                	push   $0x0
  pushl $127
80106a00:	6a 7f                	push   $0x7f
  jmp alltraps
80106a02:	e9 28 f6 ff ff       	jmp    8010602f <alltraps>

80106a07 <vector128>:
.globl vector128
vector128:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $128
80106a09:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a0e:	e9 1c f6 ff ff       	jmp    8010602f <alltraps>

80106a13 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $129
80106a15:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a1a:	e9 10 f6 ff ff       	jmp    8010602f <alltraps>

80106a1f <vector130>:
.globl vector130
vector130:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $130
80106a21:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a26:	e9 04 f6 ff ff       	jmp    8010602f <alltraps>

80106a2b <vector131>:
.globl vector131
vector131:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $131
80106a2d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a32:	e9 f8 f5 ff ff       	jmp    8010602f <alltraps>

80106a37 <vector132>:
.globl vector132
vector132:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $132
80106a39:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a3e:	e9 ec f5 ff ff       	jmp    8010602f <alltraps>

80106a43 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $133
80106a45:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a4a:	e9 e0 f5 ff ff       	jmp    8010602f <alltraps>

80106a4f <vector134>:
.globl vector134
vector134:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $134
80106a51:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a56:	e9 d4 f5 ff ff       	jmp    8010602f <alltraps>

80106a5b <vector135>:
.globl vector135
vector135:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $135
80106a5d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106a62:	e9 c8 f5 ff ff       	jmp    8010602f <alltraps>

80106a67 <vector136>:
.globl vector136
vector136:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $136
80106a69:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106a6e:	e9 bc f5 ff ff       	jmp    8010602f <alltraps>

80106a73 <vector137>:
.globl vector137
vector137:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $137
80106a75:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106a7a:	e9 b0 f5 ff ff       	jmp    8010602f <alltraps>

80106a7f <vector138>:
.globl vector138
vector138:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $138
80106a81:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106a86:	e9 a4 f5 ff ff       	jmp    8010602f <alltraps>

80106a8b <vector139>:
.globl vector139
vector139:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $139
80106a8d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106a92:	e9 98 f5 ff ff       	jmp    8010602f <alltraps>

80106a97 <vector140>:
.globl vector140
vector140:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $140
80106a99:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106a9e:	e9 8c f5 ff ff       	jmp    8010602f <alltraps>

80106aa3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $141
80106aa5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106aaa:	e9 80 f5 ff ff       	jmp    8010602f <alltraps>

80106aaf <vector142>:
.globl vector142
vector142:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $142
80106ab1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106ab6:	e9 74 f5 ff ff       	jmp    8010602f <alltraps>

80106abb <vector143>:
.globl vector143
vector143:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $143
80106abd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ac2:	e9 68 f5 ff ff       	jmp    8010602f <alltraps>

80106ac7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $144
80106ac9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106ace:	e9 5c f5 ff ff       	jmp    8010602f <alltraps>

80106ad3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $145
80106ad5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106ada:	e9 50 f5 ff ff       	jmp    8010602f <alltraps>

80106adf <vector146>:
.globl vector146
vector146:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $146
80106ae1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106ae6:	e9 44 f5 ff ff       	jmp    8010602f <alltraps>

80106aeb <vector147>:
.globl vector147
vector147:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $147
80106aed:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106af2:	e9 38 f5 ff ff       	jmp    8010602f <alltraps>

80106af7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $148
80106af9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106afe:	e9 2c f5 ff ff       	jmp    8010602f <alltraps>

80106b03 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $149
80106b05:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b0a:	e9 20 f5 ff ff       	jmp    8010602f <alltraps>

80106b0f <vector150>:
.globl vector150
vector150:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $150
80106b11:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b16:	e9 14 f5 ff ff       	jmp    8010602f <alltraps>

80106b1b <vector151>:
.globl vector151
vector151:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $151
80106b1d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b22:	e9 08 f5 ff ff       	jmp    8010602f <alltraps>

80106b27 <vector152>:
.globl vector152
vector152:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $152
80106b29:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b2e:	e9 fc f4 ff ff       	jmp    8010602f <alltraps>

80106b33 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $153
80106b35:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b3a:	e9 f0 f4 ff ff       	jmp    8010602f <alltraps>

80106b3f <vector154>:
.globl vector154
vector154:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $154
80106b41:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b46:	e9 e4 f4 ff ff       	jmp    8010602f <alltraps>

80106b4b <vector155>:
.globl vector155
vector155:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $155
80106b4d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b52:	e9 d8 f4 ff ff       	jmp    8010602f <alltraps>

80106b57 <vector156>:
.globl vector156
vector156:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $156
80106b59:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106b5e:	e9 cc f4 ff ff       	jmp    8010602f <alltraps>

80106b63 <vector157>:
.globl vector157
vector157:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $157
80106b65:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106b6a:	e9 c0 f4 ff ff       	jmp    8010602f <alltraps>

80106b6f <vector158>:
.globl vector158
vector158:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $158
80106b71:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106b76:	e9 b4 f4 ff ff       	jmp    8010602f <alltraps>

80106b7b <vector159>:
.globl vector159
vector159:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $159
80106b7d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106b82:	e9 a8 f4 ff ff       	jmp    8010602f <alltraps>

80106b87 <vector160>:
.globl vector160
vector160:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $160
80106b89:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106b8e:	e9 9c f4 ff ff       	jmp    8010602f <alltraps>

80106b93 <vector161>:
.globl vector161
vector161:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $161
80106b95:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106b9a:	e9 90 f4 ff ff       	jmp    8010602f <alltraps>

80106b9f <vector162>:
.globl vector162
vector162:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $162
80106ba1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106ba6:	e9 84 f4 ff ff       	jmp    8010602f <alltraps>

80106bab <vector163>:
.globl vector163
vector163:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $163
80106bad:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106bb2:	e9 78 f4 ff ff       	jmp    8010602f <alltraps>

80106bb7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $164
80106bb9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106bbe:	e9 6c f4 ff ff       	jmp    8010602f <alltraps>

80106bc3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $165
80106bc5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106bca:	e9 60 f4 ff ff       	jmp    8010602f <alltraps>

80106bcf <vector166>:
.globl vector166
vector166:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $166
80106bd1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106bd6:	e9 54 f4 ff ff       	jmp    8010602f <alltraps>

80106bdb <vector167>:
.globl vector167
vector167:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $167
80106bdd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106be2:	e9 48 f4 ff ff       	jmp    8010602f <alltraps>

80106be7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $168
80106be9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106bee:	e9 3c f4 ff ff       	jmp    8010602f <alltraps>

80106bf3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $169
80106bf5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106bfa:	e9 30 f4 ff ff       	jmp    8010602f <alltraps>

80106bff <vector170>:
.globl vector170
vector170:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $170
80106c01:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c06:	e9 24 f4 ff ff       	jmp    8010602f <alltraps>

80106c0b <vector171>:
.globl vector171
vector171:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $171
80106c0d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c12:	e9 18 f4 ff ff       	jmp    8010602f <alltraps>

80106c17 <vector172>:
.globl vector172
vector172:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $172
80106c19:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c1e:	e9 0c f4 ff ff       	jmp    8010602f <alltraps>

80106c23 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $173
80106c25:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c2a:	e9 00 f4 ff ff       	jmp    8010602f <alltraps>

80106c2f <vector174>:
.globl vector174
vector174:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $174
80106c31:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c36:	e9 f4 f3 ff ff       	jmp    8010602f <alltraps>

80106c3b <vector175>:
.globl vector175
vector175:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $175
80106c3d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c42:	e9 e8 f3 ff ff       	jmp    8010602f <alltraps>

80106c47 <vector176>:
.globl vector176
vector176:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $176
80106c49:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c4e:	e9 dc f3 ff ff       	jmp    8010602f <alltraps>

80106c53 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $177
80106c55:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c5a:	e9 d0 f3 ff ff       	jmp    8010602f <alltraps>

80106c5f <vector178>:
.globl vector178
vector178:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $178
80106c61:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106c66:	e9 c4 f3 ff ff       	jmp    8010602f <alltraps>

80106c6b <vector179>:
.globl vector179
vector179:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $179
80106c6d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106c72:	e9 b8 f3 ff ff       	jmp    8010602f <alltraps>

80106c77 <vector180>:
.globl vector180
vector180:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $180
80106c79:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106c7e:	e9 ac f3 ff ff       	jmp    8010602f <alltraps>

80106c83 <vector181>:
.globl vector181
vector181:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $181
80106c85:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106c8a:	e9 a0 f3 ff ff       	jmp    8010602f <alltraps>

80106c8f <vector182>:
.globl vector182
vector182:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $182
80106c91:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106c96:	e9 94 f3 ff ff       	jmp    8010602f <alltraps>

80106c9b <vector183>:
.globl vector183
vector183:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $183
80106c9d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ca2:	e9 88 f3 ff ff       	jmp    8010602f <alltraps>

80106ca7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $184
80106ca9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106cae:	e9 7c f3 ff ff       	jmp    8010602f <alltraps>

80106cb3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $185
80106cb5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106cba:	e9 70 f3 ff ff       	jmp    8010602f <alltraps>

80106cbf <vector186>:
.globl vector186
vector186:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $186
80106cc1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106cc6:	e9 64 f3 ff ff       	jmp    8010602f <alltraps>

80106ccb <vector187>:
.globl vector187
vector187:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $187
80106ccd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106cd2:	e9 58 f3 ff ff       	jmp    8010602f <alltraps>

80106cd7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $188
80106cd9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106cde:	e9 4c f3 ff ff       	jmp    8010602f <alltraps>

80106ce3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $189
80106ce5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106cea:	e9 40 f3 ff ff       	jmp    8010602f <alltraps>

80106cef <vector190>:
.globl vector190
vector190:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $190
80106cf1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106cf6:	e9 34 f3 ff ff       	jmp    8010602f <alltraps>

80106cfb <vector191>:
.globl vector191
vector191:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $191
80106cfd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d02:	e9 28 f3 ff ff       	jmp    8010602f <alltraps>

80106d07 <vector192>:
.globl vector192
vector192:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $192
80106d09:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d0e:	e9 1c f3 ff ff       	jmp    8010602f <alltraps>

80106d13 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $193
80106d15:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d1a:	e9 10 f3 ff ff       	jmp    8010602f <alltraps>

80106d1f <vector194>:
.globl vector194
vector194:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $194
80106d21:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d26:	e9 04 f3 ff ff       	jmp    8010602f <alltraps>

80106d2b <vector195>:
.globl vector195
vector195:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $195
80106d2d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d32:	e9 f8 f2 ff ff       	jmp    8010602f <alltraps>

80106d37 <vector196>:
.globl vector196
vector196:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $196
80106d39:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d3e:	e9 ec f2 ff ff       	jmp    8010602f <alltraps>

80106d43 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $197
80106d45:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d4a:	e9 e0 f2 ff ff       	jmp    8010602f <alltraps>

80106d4f <vector198>:
.globl vector198
vector198:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $198
80106d51:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d56:	e9 d4 f2 ff ff       	jmp    8010602f <alltraps>

80106d5b <vector199>:
.globl vector199
vector199:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $199
80106d5d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106d62:	e9 c8 f2 ff ff       	jmp    8010602f <alltraps>

80106d67 <vector200>:
.globl vector200
vector200:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $200
80106d69:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106d6e:	e9 bc f2 ff ff       	jmp    8010602f <alltraps>

80106d73 <vector201>:
.globl vector201
vector201:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $201
80106d75:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106d7a:	e9 b0 f2 ff ff       	jmp    8010602f <alltraps>

80106d7f <vector202>:
.globl vector202
vector202:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $202
80106d81:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106d86:	e9 a4 f2 ff ff       	jmp    8010602f <alltraps>

80106d8b <vector203>:
.globl vector203
vector203:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $203
80106d8d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106d92:	e9 98 f2 ff ff       	jmp    8010602f <alltraps>

80106d97 <vector204>:
.globl vector204
vector204:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $204
80106d99:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106d9e:	e9 8c f2 ff ff       	jmp    8010602f <alltraps>

80106da3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $205
80106da5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106daa:	e9 80 f2 ff ff       	jmp    8010602f <alltraps>

80106daf <vector206>:
.globl vector206
vector206:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $206
80106db1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106db6:	e9 74 f2 ff ff       	jmp    8010602f <alltraps>

80106dbb <vector207>:
.globl vector207
vector207:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $207
80106dbd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106dc2:	e9 68 f2 ff ff       	jmp    8010602f <alltraps>

80106dc7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $208
80106dc9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106dce:	e9 5c f2 ff ff       	jmp    8010602f <alltraps>

80106dd3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $209
80106dd5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106dda:	e9 50 f2 ff ff       	jmp    8010602f <alltraps>

80106ddf <vector210>:
.globl vector210
vector210:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $210
80106de1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106de6:	e9 44 f2 ff ff       	jmp    8010602f <alltraps>

80106deb <vector211>:
.globl vector211
vector211:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $211
80106ded:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106df2:	e9 38 f2 ff ff       	jmp    8010602f <alltraps>

80106df7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $212
80106df9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106dfe:	e9 2c f2 ff ff       	jmp    8010602f <alltraps>

80106e03 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $213
80106e05:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e0a:	e9 20 f2 ff ff       	jmp    8010602f <alltraps>

80106e0f <vector214>:
.globl vector214
vector214:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $214
80106e11:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e16:	e9 14 f2 ff ff       	jmp    8010602f <alltraps>

80106e1b <vector215>:
.globl vector215
vector215:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $215
80106e1d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e22:	e9 08 f2 ff ff       	jmp    8010602f <alltraps>

80106e27 <vector216>:
.globl vector216
vector216:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $216
80106e29:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e2e:	e9 fc f1 ff ff       	jmp    8010602f <alltraps>

80106e33 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $217
80106e35:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e3a:	e9 f0 f1 ff ff       	jmp    8010602f <alltraps>

80106e3f <vector218>:
.globl vector218
vector218:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $218
80106e41:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e46:	e9 e4 f1 ff ff       	jmp    8010602f <alltraps>

80106e4b <vector219>:
.globl vector219
vector219:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $219
80106e4d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e52:	e9 d8 f1 ff ff       	jmp    8010602f <alltraps>

80106e57 <vector220>:
.globl vector220
vector220:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $220
80106e59:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106e5e:	e9 cc f1 ff ff       	jmp    8010602f <alltraps>

80106e63 <vector221>:
.globl vector221
vector221:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $221
80106e65:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106e6a:	e9 c0 f1 ff ff       	jmp    8010602f <alltraps>

80106e6f <vector222>:
.globl vector222
vector222:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $222
80106e71:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106e76:	e9 b4 f1 ff ff       	jmp    8010602f <alltraps>

80106e7b <vector223>:
.globl vector223
vector223:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $223
80106e7d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106e82:	e9 a8 f1 ff ff       	jmp    8010602f <alltraps>

80106e87 <vector224>:
.globl vector224
vector224:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $224
80106e89:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106e8e:	e9 9c f1 ff ff       	jmp    8010602f <alltraps>

80106e93 <vector225>:
.globl vector225
vector225:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $225
80106e95:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106e9a:	e9 90 f1 ff ff       	jmp    8010602f <alltraps>

80106e9f <vector226>:
.globl vector226
vector226:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $226
80106ea1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ea6:	e9 84 f1 ff ff       	jmp    8010602f <alltraps>

80106eab <vector227>:
.globl vector227
vector227:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $227
80106ead:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106eb2:	e9 78 f1 ff ff       	jmp    8010602f <alltraps>

80106eb7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $228
80106eb9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106ebe:	e9 6c f1 ff ff       	jmp    8010602f <alltraps>

80106ec3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $229
80106ec5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106eca:	e9 60 f1 ff ff       	jmp    8010602f <alltraps>

80106ecf <vector230>:
.globl vector230
vector230:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $230
80106ed1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106ed6:	e9 54 f1 ff ff       	jmp    8010602f <alltraps>

80106edb <vector231>:
.globl vector231
vector231:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $231
80106edd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ee2:	e9 48 f1 ff ff       	jmp    8010602f <alltraps>

80106ee7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $232
80106ee9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106eee:	e9 3c f1 ff ff       	jmp    8010602f <alltraps>

80106ef3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $233
80106ef5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106efa:	e9 30 f1 ff ff       	jmp    8010602f <alltraps>

80106eff <vector234>:
.globl vector234
vector234:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $234
80106f01:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f06:	e9 24 f1 ff ff       	jmp    8010602f <alltraps>

80106f0b <vector235>:
.globl vector235
vector235:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $235
80106f0d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f12:	e9 18 f1 ff ff       	jmp    8010602f <alltraps>

80106f17 <vector236>:
.globl vector236
vector236:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $236
80106f19:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f1e:	e9 0c f1 ff ff       	jmp    8010602f <alltraps>

80106f23 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $237
80106f25:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f2a:	e9 00 f1 ff ff       	jmp    8010602f <alltraps>

80106f2f <vector238>:
.globl vector238
vector238:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $238
80106f31:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f36:	e9 f4 f0 ff ff       	jmp    8010602f <alltraps>

80106f3b <vector239>:
.globl vector239
vector239:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $239
80106f3d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f42:	e9 e8 f0 ff ff       	jmp    8010602f <alltraps>

80106f47 <vector240>:
.globl vector240
vector240:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $240
80106f49:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f4e:	e9 dc f0 ff ff       	jmp    8010602f <alltraps>

80106f53 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $241
80106f55:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f5a:	e9 d0 f0 ff ff       	jmp    8010602f <alltraps>

80106f5f <vector242>:
.globl vector242
vector242:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $242
80106f61:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106f66:	e9 c4 f0 ff ff       	jmp    8010602f <alltraps>

80106f6b <vector243>:
.globl vector243
vector243:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $243
80106f6d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106f72:	e9 b8 f0 ff ff       	jmp    8010602f <alltraps>

80106f77 <vector244>:
.globl vector244
vector244:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $244
80106f79:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106f7e:	e9 ac f0 ff ff       	jmp    8010602f <alltraps>

80106f83 <vector245>:
.globl vector245
vector245:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $245
80106f85:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106f8a:	e9 a0 f0 ff ff       	jmp    8010602f <alltraps>

80106f8f <vector246>:
.globl vector246
vector246:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $246
80106f91:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106f96:	e9 94 f0 ff ff       	jmp    8010602f <alltraps>

80106f9b <vector247>:
.globl vector247
vector247:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $247
80106f9d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106fa2:	e9 88 f0 ff ff       	jmp    8010602f <alltraps>

80106fa7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $248
80106fa9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106fae:	e9 7c f0 ff ff       	jmp    8010602f <alltraps>

80106fb3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $249
80106fb5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106fba:	e9 70 f0 ff ff       	jmp    8010602f <alltraps>

80106fbf <vector250>:
.globl vector250
vector250:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $250
80106fc1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106fc6:	e9 64 f0 ff ff       	jmp    8010602f <alltraps>

80106fcb <vector251>:
.globl vector251
vector251:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $251
80106fcd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106fd2:	e9 58 f0 ff ff       	jmp    8010602f <alltraps>

80106fd7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $252
80106fd9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106fde:	e9 4c f0 ff ff       	jmp    8010602f <alltraps>

80106fe3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $253
80106fe5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106fea:	e9 40 f0 ff ff       	jmp    8010602f <alltraps>

80106fef <vector254>:
.globl vector254
vector254:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $254
80106ff1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ff6:	e9 34 f0 ff ff       	jmp    8010602f <alltraps>

80106ffb <vector255>:
.globl vector255
vector255:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $255
80106ffd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107002:	e9 28 f0 ff ff       	jmp    8010602f <alltraps>
80107007:	66 90                	xchg   %ax,%ax
80107009:	66 90                	xchg   %ax,%ax
8010700b:	66 90                	xchg   %ax,%ax
8010700d:	66 90                	xchg   %ax,%ax
8010700f:	90                   	nop

80107010 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107016:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010701c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107022:	83 ec 1c             	sub    $0x1c,%esp
80107025:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107028:	39 d3                	cmp    %edx,%ebx
8010702a:	73 49                	jae    80107075 <deallocuvm.part.0+0x65>
8010702c:	89 c7                	mov    %eax,%edi
8010702e:	eb 0c                	jmp    8010703c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107030:	83 c0 01             	add    $0x1,%eax
80107033:	c1 e0 16             	shl    $0x16,%eax
80107036:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107038:	39 da                	cmp    %ebx,%edx
8010703a:	76 39                	jbe    80107075 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010703c:	89 d8                	mov    %ebx,%eax
8010703e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107041:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107044:	f6 c1 01             	test   $0x1,%cl
80107047:	74 e7                	je     80107030 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107049:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010704b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107051:	c1 ee 0a             	shr    $0xa,%esi
80107054:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010705a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107061:	85 f6                	test   %esi,%esi
80107063:	74 cb                	je     80107030 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107065:	8b 06                	mov    (%esi),%eax
80107067:	a8 01                	test   $0x1,%al
80107069:	75 15                	jne    80107080 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010706b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107071:	39 da                	cmp    %ebx,%edx
80107073:	77 c7                	ja     8010703c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107075:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107078:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010707b:	5b                   	pop    %ebx
8010707c:	5e                   	pop    %esi
8010707d:	5f                   	pop    %edi
8010707e:	5d                   	pop    %ebp
8010707f:	c3                   	ret    
      if(pa == 0)
80107080:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107085:	74 25                	je     801070ac <deallocuvm.part.0+0x9c>
      kfree(v);
80107087:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010708a:	05 00 00 00 80       	add    $0x80000000,%eax
8010708f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107092:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107098:	50                   	push   %eax
80107099:	e8 42 b4 ff ff       	call   801024e0 <kfree>
      *pte = 0;
8010709e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
801070a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801070a7:	83 c4 10             	add    $0x10,%esp
801070aa:	eb 8c                	jmp    80107038 <deallocuvm.part.0+0x28>
        panic("kfree");
801070ac:	83 ec 0c             	sub    $0xc,%esp
801070af:	68 66 7c 10 80       	push   $0x80107c66
801070b4:	e8 c7 92 ff ff       	call   80100380 <panic>
801070b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070c0 <mappages>:
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801070c6:	89 d3                	mov    %edx,%ebx
801070c8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801070ce:	83 ec 1c             	sub    $0x1c,%esp
801070d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070d4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801070d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801070e0:	8b 45 08             	mov    0x8(%ebp),%eax
801070e3:	29 d8                	sub    %ebx,%eax
801070e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070e8:	eb 3d                	jmp    80107127 <mappages+0x67>
801070ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801070f0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801070f7:	c1 ea 0a             	shr    $0xa,%edx
801070fa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107100:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107107:	85 c0                	test   %eax,%eax
80107109:	74 75                	je     80107180 <mappages+0xc0>
    if(*pte & PTE_P)
8010710b:	f6 00 01             	testb  $0x1,(%eax)
8010710e:	0f 85 86 00 00 00    	jne    8010719a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107114:	0b 75 0c             	or     0xc(%ebp),%esi
80107117:	83 ce 01             	or     $0x1,%esi
8010711a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010711c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010711f:	74 6f                	je     80107190 <mappages+0xd0>
    a += PGSIZE;
80107121:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010712a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010712d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107130:	89 d8                	mov    %ebx,%eax
80107132:	c1 e8 16             	shr    $0x16,%eax
80107135:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107138:	8b 07                	mov    (%edi),%eax
8010713a:	a8 01                	test   $0x1,%al
8010713c:	75 b2                	jne    801070f0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010713e:	e8 5d b5 ff ff       	call   801026a0 <kalloc>
80107143:	85 c0                	test   %eax,%eax
80107145:	74 39                	je     80107180 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107147:	83 ec 04             	sub    $0x4,%esp
8010714a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010714d:	68 00 10 00 00       	push   $0x1000
80107152:	6a 00                	push   $0x0
80107154:	50                   	push   %eax
80107155:	e8 76 db ff ff       	call   80104cd0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010715a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010715d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107160:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107166:	83 c8 07             	or     $0x7,%eax
80107169:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010716b:	89 d8                	mov    %ebx,%eax
8010716d:	c1 e8 0a             	shr    $0xa,%eax
80107170:	25 fc 0f 00 00       	and    $0xffc,%eax
80107175:	01 d0                	add    %edx,%eax
80107177:	eb 92                	jmp    8010710b <mappages+0x4b>
80107179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107180:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107183:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107188:	5b                   	pop    %ebx
80107189:	5e                   	pop    %esi
8010718a:	5f                   	pop    %edi
8010718b:	5d                   	pop    %ebp
8010718c:	c3                   	ret    
8010718d:	8d 76 00             	lea    0x0(%esi),%esi
80107190:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107193:	31 c0                	xor    %eax,%eax
}
80107195:	5b                   	pop    %ebx
80107196:	5e                   	pop    %esi
80107197:	5f                   	pop    %edi
80107198:	5d                   	pop    %ebp
80107199:	c3                   	ret    
      panic("remap");
8010719a:	83 ec 0c             	sub    $0xc,%esp
8010719d:	68 b4 82 10 80       	push   $0x801082b4
801071a2:	e8 d9 91 ff ff       	call   80100380 <panic>
801071a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ae:	66 90                	xchg   %ax,%ax

801071b0 <seginit>:
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801071b6:	e8 55 c8 ff ff       	call   80103a10 <cpuid>
  pd[0] = size-1;
801071bb:	ba 2f 00 00 00       	mov    $0x2f,%edx
801071c0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801071c6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801071ca:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
801071d1:	ff 00 00 
801071d4:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
801071db:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801071de:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
801071e5:	ff 00 00 
801071e8:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
801071ef:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801071f2:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
801071f9:	ff 00 00 
801071fc:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80107203:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107206:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
8010720d:	ff 00 00 
80107210:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80107217:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010721a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
8010721f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107223:	c1 e8 10             	shr    $0x10,%eax
80107226:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010722a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010722d:	0f 01 10             	lgdtl  (%eax)
}
80107230:	c9                   	leave  
80107231:	c3                   	ret    
80107232:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107240 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107240:	a1 c4 59 11 80       	mov    0x801159c4,%eax
80107245:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010724a:	0f 22 d8             	mov    %eax,%cr3
}
8010724d:	c3                   	ret    
8010724e:	66 90                	xchg   %ax,%ax

80107250 <switchuvm>:
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	57                   	push   %edi
80107254:	56                   	push   %esi
80107255:	53                   	push   %ebx
80107256:	83 ec 1c             	sub    $0x1c,%esp
80107259:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010725c:	85 f6                	test   %esi,%esi
8010725e:	0f 84 cb 00 00 00    	je     8010732f <switchuvm+0xdf>
  if(p->kstack == 0)
80107264:	8b 46 08             	mov    0x8(%esi),%eax
80107267:	85 c0                	test   %eax,%eax
80107269:	0f 84 da 00 00 00    	je     80107349 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010726f:	8b 46 04             	mov    0x4(%esi),%eax
80107272:	85 c0                	test   %eax,%eax
80107274:	0f 84 c2 00 00 00    	je     8010733c <switchuvm+0xec>
  pushcli();
8010727a:	e8 41 d8 ff ff       	call   80104ac0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010727f:	e8 2c c7 ff ff       	call   801039b0 <mycpu>
80107284:	89 c3                	mov    %eax,%ebx
80107286:	e8 25 c7 ff ff       	call   801039b0 <mycpu>
8010728b:	89 c7                	mov    %eax,%edi
8010728d:	e8 1e c7 ff ff       	call   801039b0 <mycpu>
80107292:	83 c7 08             	add    $0x8,%edi
80107295:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107298:	e8 13 c7 ff ff       	call   801039b0 <mycpu>
8010729d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801072a0:	ba 67 00 00 00       	mov    $0x67,%edx
801072a5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801072ac:	83 c0 08             	add    $0x8,%eax
801072af:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072b6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072bb:	83 c1 08             	add    $0x8,%ecx
801072be:	c1 e8 18             	shr    $0x18,%eax
801072c1:	c1 e9 10             	shr    $0x10,%ecx
801072c4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801072ca:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801072d0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801072d5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072dc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801072e1:	e8 ca c6 ff ff       	call   801039b0 <mycpu>
801072e6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072ed:	e8 be c6 ff ff       	call   801039b0 <mycpu>
801072f2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801072f6:	8b 5e 08             	mov    0x8(%esi),%ebx
801072f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072ff:	e8 ac c6 ff ff       	call   801039b0 <mycpu>
80107304:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107307:	e8 a4 c6 ff ff       	call   801039b0 <mycpu>
8010730c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107310:	b8 28 00 00 00       	mov    $0x28,%eax
80107315:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107318:	8b 46 04             	mov    0x4(%esi),%eax
8010731b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107320:	0f 22 d8             	mov    %eax,%cr3
}
80107323:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107326:	5b                   	pop    %ebx
80107327:	5e                   	pop    %esi
80107328:	5f                   	pop    %edi
80107329:	5d                   	pop    %ebp
  popcli();
8010732a:	e9 e1 d7 ff ff       	jmp    80104b10 <popcli>
    panic("switchuvm: no process");
8010732f:	83 ec 0c             	sub    $0xc,%esp
80107332:	68 ba 82 10 80       	push   $0x801082ba
80107337:	e8 44 90 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010733c:	83 ec 0c             	sub    $0xc,%esp
8010733f:	68 e5 82 10 80       	push   $0x801082e5
80107344:	e8 37 90 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107349:	83 ec 0c             	sub    $0xc,%esp
8010734c:	68 d0 82 10 80       	push   $0x801082d0
80107351:	e8 2a 90 ff ff       	call   80100380 <panic>
80107356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010735d:	8d 76 00             	lea    0x0(%esi),%esi

80107360 <inituvm>:
{
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	57                   	push   %edi
80107364:	56                   	push   %esi
80107365:	53                   	push   %ebx
80107366:	83 ec 1c             	sub    $0x1c,%esp
80107369:	8b 45 0c             	mov    0xc(%ebp),%eax
8010736c:	8b 75 10             	mov    0x10(%ebp),%esi
8010736f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107372:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107375:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010737b:	77 4b                	ja     801073c8 <inituvm+0x68>
  mem = kalloc();
8010737d:	e8 1e b3 ff ff       	call   801026a0 <kalloc>
  memset(mem, 0, PGSIZE);
80107382:	83 ec 04             	sub    $0x4,%esp
80107385:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010738a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010738c:	6a 00                	push   $0x0
8010738e:	50                   	push   %eax
8010738f:	e8 3c d9 ff ff       	call   80104cd0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107394:	58                   	pop    %eax
80107395:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010739b:	5a                   	pop    %edx
8010739c:	6a 06                	push   $0x6
8010739e:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073a3:	31 d2                	xor    %edx,%edx
801073a5:	50                   	push   %eax
801073a6:	89 f8                	mov    %edi,%eax
801073a8:	e8 13 fd ff ff       	call   801070c0 <mappages>
  memmove(mem, init, sz);
801073ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073b0:	89 75 10             	mov    %esi,0x10(%ebp)
801073b3:	83 c4 10             	add    $0x10,%esp
801073b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801073b9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801073bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073bf:	5b                   	pop    %ebx
801073c0:	5e                   	pop    %esi
801073c1:	5f                   	pop    %edi
801073c2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801073c3:	e9 a8 d9 ff ff       	jmp    80104d70 <memmove>
    panic("inituvm: more than a page");
801073c8:	83 ec 0c             	sub    $0xc,%esp
801073cb:	68 f9 82 10 80       	push   $0x801082f9
801073d0:	e8 ab 8f ff ff       	call   80100380 <panic>
801073d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801073e0 <loaduvm>:
{
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	57                   	push   %edi
801073e4:	56                   	push   %esi
801073e5:	53                   	push   %ebx
801073e6:	83 ec 1c             	sub    $0x1c,%esp
801073e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801073ec:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801073ef:	a9 ff 0f 00 00       	test   $0xfff,%eax
801073f4:	0f 85 bb 00 00 00    	jne    801074b5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801073fa:	01 f0                	add    %esi,%eax
801073fc:	89 f3                	mov    %esi,%ebx
801073fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107401:	8b 45 14             	mov    0x14(%ebp),%eax
80107404:	01 f0                	add    %esi,%eax
80107406:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107409:	85 f6                	test   %esi,%esi
8010740b:	0f 84 87 00 00 00    	je     80107498 <loaduvm+0xb8>
80107411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107418:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010741b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010741e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107420:	89 c2                	mov    %eax,%edx
80107422:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107425:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107428:	f6 c2 01             	test   $0x1,%dl
8010742b:	75 13                	jne    80107440 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010742d:	83 ec 0c             	sub    $0xc,%esp
80107430:	68 13 83 10 80       	push   $0x80108313
80107435:	e8 46 8f ff ff       	call   80100380 <panic>
8010743a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107440:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107443:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107449:	25 fc 0f 00 00       	and    $0xffc,%eax
8010744e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107455:	85 c0                	test   %eax,%eax
80107457:	74 d4                	je     8010742d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107459:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010745b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010745e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107463:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107468:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010746e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107471:	29 d9                	sub    %ebx,%ecx
80107473:	05 00 00 00 80       	add    $0x80000000,%eax
80107478:	57                   	push   %edi
80107479:	51                   	push   %ecx
8010747a:	50                   	push   %eax
8010747b:	ff 75 10             	push   0x10(%ebp)
8010747e:	e8 2d a6 ff ff       	call   80101ab0 <readi>
80107483:	83 c4 10             	add    $0x10,%esp
80107486:	39 f8                	cmp    %edi,%eax
80107488:	75 1e                	jne    801074a8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010748a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107490:	89 f0                	mov    %esi,%eax
80107492:	29 d8                	sub    %ebx,%eax
80107494:	39 c6                	cmp    %eax,%esi
80107496:	77 80                	ja     80107418 <loaduvm+0x38>
}
80107498:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010749b:	31 c0                	xor    %eax,%eax
}
8010749d:	5b                   	pop    %ebx
8010749e:	5e                   	pop    %esi
8010749f:	5f                   	pop    %edi
801074a0:	5d                   	pop    %ebp
801074a1:	c3                   	ret    
801074a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074b0:	5b                   	pop    %ebx
801074b1:	5e                   	pop    %esi
801074b2:	5f                   	pop    %edi
801074b3:	5d                   	pop    %ebp
801074b4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801074b5:	83 ec 0c             	sub    $0xc,%esp
801074b8:	68 b4 83 10 80       	push   $0x801083b4
801074bd:	e8 be 8e ff ff       	call   80100380 <panic>
801074c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074d0 <allocuvm>:
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	57                   	push   %edi
801074d4:	56                   	push   %esi
801074d5:	53                   	push   %ebx
801074d6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801074d9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801074dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801074df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074e2:	85 c0                	test   %eax,%eax
801074e4:	0f 88 b6 00 00 00    	js     801075a0 <allocuvm+0xd0>
  if(newsz < oldsz)
801074ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801074ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801074f0:	0f 82 9a 00 00 00    	jb     80107590 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801074f6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801074fc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107502:	39 75 10             	cmp    %esi,0x10(%ebp)
80107505:	77 44                	ja     8010754b <allocuvm+0x7b>
80107507:	e9 87 00 00 00       	jmp    80107593 <allocuvm+0xc3>
8010750c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107510:	83 ec 04             	sub    $0x4,%esp
80107513:	68 00 10 00 00       	push   $0x1000
80107518:	6a 00                	push   $0x0
8010751a:	50                   	push   %eax
8010751b:	e8 b0 d7 ff ff       	call   80104cd0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107520:	58                   	pop    %eax
80107521:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107527:	5a                   	pop    %edx
80107528:	6a 06                	push   $0x6
8010752a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010752f:	89 f2                	mov    %esi,%edx
80107531:	50                   	push   %eax
80107532:	89 f8                	mov    %edi,%eax
80107534:	e8 87 fb ff ff       	call   801070c0 <mappages>
80107539:	83 c4 10             	add    $0x10,%esp
8010753c:	85 c0                	test   %eax,%eax
8010753e:	78 78                	js     801075b8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107540:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107546:	39 75 10             	cmp    %esi,0x10(%ebp)
80107549:	76 48                	jbe    80107593 <allocuvm+0xc3>
    mem = kalloc();
8010754b:	e8 50 b1 ff ff       	call   801026a0 <kalloc>
80107550:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107552:	85 c0                	test   %eax,%eax
80107554:	75 ba                	jne    80107510 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107556:	83 ec 0c             	sub    $0xc,%esp
80107559:	68 31 83 10 80       	push   $0x80108331
8010755e:	e8 3d 91 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107563:	8b 45 0c             	mov    0xc(%ebp),%eax
80107566:	83 c4 10             	add    $0x10,%esp
80107569:	39 45 10             	cmp    %eax,0x10(%ebp)
8010756c:	74 32                	je     801075a0 <allocuvm+0xd0>
8010756e:	8b 55 10             	mov    0x10(%ebp),%edx
80107571:	89 c1                	mov    %eax,%ecx
80107573:	89 f8                	mov    %edi,%eax
80107575:	e8 96 fa ff ff       	call   80107010 <deallocuvm.part.0>
      return 0;
8010757a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107584:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107587:	5b                   	pop    %ebx
80107588:	5e                   	pop    %esi
80107589:	5f                   	pop    %edi
8010758a:	5d                   	pop    %ebp
8010758b:	c3                   	ret    
8010758c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107596:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107599:	5b                   	pop    %ebx
8010759a:	5e                   	pop    %esi
8010759b:	5f                   	pop    %edi
8010759c:	5d                   	pop    %ebp
8010759d:	c3                   	ret    
8010759e:	66 90                	xchg   %ax,%ax
    return 0;
801075a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801075a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075ad:	5b                   	pop    %ebx
801075ae:	5e                   	pop    %esi
801075af:	5f                   	pop    %edi
801075b0:	5d                   	pop    %ebp
801075b1:	c3                   	ret    
801075b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801075b8:	83 ec 0c             	sub    $0xc,%esp
801075bb:	68 49 83 10 80       	push   $0x80108349
801075c0:	e8 db 90 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801075c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801075c8:	83 c4 10             	add    $0x10,%esp
801075cb:	39 45 10             	cmp    %eax,0x10(%ebp)
801075ce:	74 0c                	je     801075dc <allocuvm+0x10c>
801075d0:	8b 55 10             	mov    0x10(%ebp),%edx
801075d3:	89 c1                	mov    %eax,%ecx
801075d5:	89 f8                	mov    %edi,%eax
801075d7:	e8 34 fa ff ff       	call   80107010 <deallocuvm.part.0>
      kfree(mem);
801075dc:	83 ec 0c             	sub    $0xc,%esp
801075df:	53                   	push   %ebx
801075e0:	e8 fb ae ff ff       	call   801024e0 <kfree>
      return 0;
801075e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801075ec:	83 c4 10             	add    $0x10,%esp
}
801075ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075f5:	5b                   	pop    %ebx
801075f6:	5e                   	pop    %esi
801075f7:	5f                   	pop    %edi
801075f8:	5d                   	pop    %ebp
801075f9:	c3                   	ret    
801075fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107600 <deallocuvm>:
{
80107600:	55                   	push   %ebp
80107601:	89 e5                	mov    %esp,%ebp
80107603:	8b 55 0c             	mov    0xc(%ebp),%edx
80107606:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107609:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010760c:	39 d1                	cmp    %edx,%ecx
8010760e:	73 10                	jae    80107620 <deallocuvm+0x20>
}
80107610:	5d                   	pop    %ebp
80107611:	e9 fa f9 ff ff       	jmp    80107010 <deallocuvm.part.0>
80107616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010761d:	8d 76 00             	lea    0x0(%esi),%esi
80107620:	89 d0                	mov    %edx,%eax
80107622:	5d                   	pop    %ebp
80107623:	c3                   	ret    
80107624:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010762b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010762f:	90                   	nop

80107630 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	57                   	push   %edi
80107634:	56                   	push   %esi
80107635:	53                   	push   %ebx
80107636:	83 ec 0c             	sub    $0xc,%esp
80107639:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010763c:	85 f6                	test   %esi,%esi
8010763e:	74 59                	je     80107699 <freevm+0x69>
  if(newsz >= oldsz)
80107640:	31 c9                	xor    %ecx,%ecx
80107642:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107647:	89 f0                	mov    %esi,%eax
80107649:	89 f3                	mov    %esi,%ebx
8010764b:	e8 c0 f9 ff ff       	call   80107010 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107650:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107656:	eb 0f                	jmp    80107667 <freevm+0x37>
80107658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010765f:	90                   	nop
80107660:	83 c3 04             	add    $0x4,%ebx
80107663:	39 df                	cmp    %ebx,%edi
80107665:	74 23                	je     8010768a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107667:	8b 03                	mov    (%ebx),%eax
80107669:	a8 01                	test   $0x1,%al
8010766b:	74 f3                	je     80107660 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010766d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107672:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107675:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107678:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010767d:	50                   	push   %eax
8010767e:	e8 5d ae ff ff       	call   801024e0 <kfree>
80107683:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107686:	39 df                	cmp    %ebx,%edi
80107688:	75 dd                	jne    80107667 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010768a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010768d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107690:	5b                   	pop    %ebx
80107691:	5e                   	pop    %esi
80107692:	5f                   	pop    %edi
80107693:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107694:	e9 47 ae ff ff       	jmp    801024e0 <kfree>
    panic("freevm: no pgdir");
80107699:	83 ec 0c             	sub    $0xc,%esp
8010769c:	68 65 83 10 80       	push   $0x80108365
801076a1:	e8 da 8c ff ff       	call   80100380 <panic>
801076a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ad:	8d 76 00             	lea    0x0(%esi),%esi

801076b0 <setupkvm>:
{
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	56                   	push   %esi
801076b4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801076b5:	e8 e6 af ff ff       	call   801026a0 <kalloc>
801076ba:	89 c6                	mov    %eax,%esi
801076bc:	85 c0                	test   %eax,%eax
801076be:	74 42                	je     80107702 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801076c0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076c3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801076c8:	68 00 10 00 00       	push   $0x1000
801076cd:	6a 00                	push   $0x0
801076cf:	50                   	push   %eax
801076d0:	e8 fb d5 ff ff       	call   80104cd0 <memset>
801076d5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801076d8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801076db:	83 ec 08             	sub    $0x8,%esp
801076de:	8b 4b 08             	mov    0x8(%ebx),%ecx
801076e1:	ff 73 0c             	push   0xc(%ebx)
801076e4:	8b 13                	mov    (%ebx),%edx
801076e6:	50                   	push   %eax
801076e7:	29 c1                	sub    %eax,%ecx
801076e9:	89 f0                	mov    %esi,%eax
801076eb:	e8 d0 f9 ff ff       	call   801070c0 <mappages>
801076f0:	83 c4 10             	add    $0x10,%esp
801076f3:	85 c0                	test   %eax,%eax
801076f5:	78 19                	js     80107710 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076f7:	83 c3 10             	add    $0x10,%ebx
801076fa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107700:	75 d6                	jne    801076d8 <setupkvm+0x28>
}
80107702:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107705:	89 f0                	mov    %esi,%eax
80107707:	5b                   	pop    %ebx
80107708:	5e                   	pop    %esi
80107709:	5d                   	pop    %ebp
8010770a:	c3                   	ret    
8010770b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010770f:	90                   	nop
      freevm(pgdir);
80107710:	83 ec 0c             	sub    $0xc,%esp
80107713:	56                   	push   %esi
      return 0;
80107714:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107716:	e8 15 ff ff ff       	call   80107630 <freevm>
      return 0;
8010771b:	83 c4 10             	add    $0x10,%esp
}
8010771e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107721:	89 f0                	mov    %esi,%eax
80107723:	5b                   	pop    %ebx
80107724:	5e                   	pop    %esi
80107725:	5d                   	pop    %ebp
80107726:	c3                   	ret    
80107727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010772e:	66 90                	xchg   %ax,%ax

80107730 <kvmalloc>:
{
80107730:	55                   	push   %ebp
80107731:	89 e5                	mov    %esp,%ebp
80107733:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107736:	e8 75 ff ff ff       	call   801076b0 <setupkvm>
8010773b:	a3 c4 59 11 80       	mov    %eax,0x801159c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107740:	05 00 00 00 80       	add    $0x80000000,%eax
80107745:	0f 22 d8             	mov    %eax,%cr3
}
80107748:	c9                   	leave  
80107749:	c3                   	ret    
8010774a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107750 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	83 ec 08             	sub    $0x8,%esp
80107756:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107759:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010775c:	89 c1                	mov    %eax,%ecx
8010775e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107761:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107764:	f6 c2 01             	test   $0x1,%dl
80107767:	75 17                	jne    80107780 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107769:	83 ec 0c             	sub    $0xc,%esp
8010776c:	68 76 83 10 80       	push   $0x80108376
80107771:	e8 0a 8c ff ff       	call   80100380 <panic>
80107776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010777d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107780:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107783:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107789:	25 fc 0f 00 00       	and    $0xffc,%eax
8010778e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107795:	85 c0                	test   %eax,%eax
80107797:	74 d0                	je     80107769 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107799:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010779c:	c9                   	leave  
8010779d:	c3                   	ret    
8010779e:	66 90                	xchg   %ax,%ax

801077a0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801077a0:	55                   	push   %ebp
801077a1:	89 e5                	mov    %esp,%ebp
801077a3:	57                   	push   %edi
801077a4:	56                   	push   %esi
801077a5:	53                   	push   %ebx
801077a6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801077a9:	e8 02 ff ff ff       	call   801076b0 <setupkvm>
801077ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
801077b1:	85 c0                	test   %eax,%eax
801077b3:	0f 84 bd 00 00 00    	je     80107876 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801077b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801077bc:	85 c9                	test   %ecx,%ecx
801077be:	0f 84 b2 00 00 00    	je     80107876 <copyuvm+0xd6>
801077c4:	31 f6                	xor    %esi,%esi
801077c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077cd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801077d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801077d3:	89 f0                	mov    %esi,%eax
801077d5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801077d8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801077db:	a8 01                	test   $0x1,%al
801077dd:	75 11                	jne    801077f0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801077df:	83 ec 0c             	sub    $0xc,%esp
801077e2:	68 80 83 10 80       	push   $0x80108380
801077e7:	e8 94 8b ff ff       	call   80100380 <panic>
801077ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801077f0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801077f7:	c1 ea 0a             	shr    $0xa,%edx
801077fa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107800:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107807:	85 c0                	test   %eax,%eax
80107809:	74 d4                	je     801077df <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010780b:	8b 00                	mov    (%eax),%eax
8010780d:	a8 01                	test   $0x1,%al
8010780f:	0f 84 9f 00 00 00    	je     801078b4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107815:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107817:	25 ff 0f 00 00       	and    $0xfff,%eax
8010781c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010781f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107825:	e8 76 ae ff ff       	call   801026a0 <kalloc>
8010782a:	89 c3                	mov    %eax,%ebx
8010782c:	85 c0                	test   %eax,%eax
8010782e:	74 64                	je     80107894 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107830:	83 ec 04             	sub    $0x4,%esp
80107833:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107839:	68 00 10 00 00       	push   $0x1000
8010783e:	57                   	push   %edi
8010783f:	50                   	push   %eax
80107840:	e8 2b d5 ff ff       	call   80104d70 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107845:	58                   	pop    %eax
80107846:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010784c:	5a                   	pop    %edx
8010784d:	ff 75 e4             	push   -0x1c(%ebp)
80107850:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107855:	89 f2                	mov    %esi,%edx
80107857:	50                   	push   %eax
80107858:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010785b:	e8 60 f8 ff ff       	call   801070c0 <mappages>
80107860:	83 c4 10             	add    $0x10,%esp
80107863:	85 c0                	test   %eax,%eax
80107865:	78 21                	js     80107888 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107867:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010786d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107870:	0f 87 5a ff ff ff    	ja     801077d0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107876:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107879:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010787c:	5b                   	pop    %ebx
8010787d:	5e                   	pop    %esi
8010787e:	5f                   	pop    %edi
8010787f:	5d                   	pop    %ebp
80107880:	c3                   	ret    
80107881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107888:	83 ec 0c             	sub    $0xc,%esp
8010788b:	53                   	push   %ebx
8010788c:	e8 4f ac ff ff       	call   801024e0 <kfree>
      goto bad;
80107891:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107894:	83 ec 0c             	sub    $0xc,%esp
80107897:	ff 75 e0             	push   -0x20(%ebp)
8010789a:	e8 91 fd ff ff       	call   80107630 <freevm>
  return 0;
8010789f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801078a6:	83 c4 10             	add    $0x10,%esp
}
801078a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078af:	5b                   	pop    %ebx
801078b0:	5e                   	pop    %esi
801078b1:	5f                   	pop    %edi
801078b2:	5d                   	pop    %ebp
801078b3:	c3                   	ret    
      panic("copyuvm: page not present");
801078b4:	83 ec 0c             	sub    $0xc,%esp
801078b7:	68 9a 83 10 80       	push   $0x8010839a
801078bc:	e8 bf 8a ff ff       	call   80100380 <panic>
801078c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078cf:	90                   	nop

801078d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801078d0:	55                   	push   %ebp
801078d1:	89 e5                	mov    %esp,%ebp
801078d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801078d6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801078d9:	89 c1                	mov    %eax,%ecx
801078db:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801078de:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801078e1:	f6 c2 01             	test   $0x1,%dl
801078e4:	0f 84 00 01 00 00    	je     801079ea <uva2ka.cold>
  return &pgtab[PTX(va)];
801078ea:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078ed:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801078f3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801078f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801078f9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107900:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107902:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107907:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010790a:	05 00 00 00 80       	add    $0x80000000,%eax
8010790f:	83 fa 05             	cmp    $0x5,%edx
80107912:	ba 00 00 00 00       	mov    $0x0,%edx
80107917:	0f 45 c2             	cmovne %edx,%eax
}
8010791a:	c3                   	ret    
8010791b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010791f:	90                   	nop

80107920 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107920:	55                   	push   %ebp
80107921:	89 e5                	mov    %esp,%ebp
80107923:	57                   	push   %edi
80107924:	56                   	push   %esi
80107925:	53                   	push   %ebx
80107926:	83 ec 0c             	sub    $0xc,%esp
80107929:	8b 75 14             	mov    0x14(%ebp),%esi
8010792c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010792f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107932:	85 f6                	test   %esi,%esi
80107934:	75 51                	jne    80107987 <copyout+0x67>
80107936:	e9 a5 00 00 00       	jmp    801079e0 <copyout+0xc0>
8010793b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010793f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107940:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107946:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010794c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107952:	74 75                	je     801079c9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107954:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107956:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107959:	29 c3                	sub    %eax,%ebx
8010795b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107961:	39 f3                	cmp    %esi,%ebx
80107963:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107966:	29 f8                	sub    %edi,%eax
80107968:	83 ec 04             	sub    $0x4,%esp
8010796b:	01 c1                	add    %eax,%ecx
8010796d:	53                   	push   %ebx
8010796e:	52                   	push   %edx
8010796f:	51                   	push   %ecx
80107970:	e8 fb d3 ff ff       	call   80104d70 <memmove>
    len -= n;
    buf += n;
80107975:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107978:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010797e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107981:	01 da                	add    %ebx,%edx
  while(len > 0){
80107983:	29 de                	sub    %ebx,%esi
80107985:	74 59                	je     801079e0 <copyout+0xc0>
  if(*pde & PTE_P){
80107987:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010798a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010798c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010798e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107991:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107997:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010799a:	f6 c1 01             	test   $0x1,%cl
8010799d:	0f 84 4e 00 00 00    	je     801079f1 <copyout.cold>
  return &pgtab[PTX(va)];
801079a3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079a5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801079ab:	c1 eb 0c             	shr    $0xc,%ebx
801079ae:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801079b4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801079bb:	89 d9                	mov    %ebx,%ecx
801079bd:	83 e1 05             	and    $0x5,%ecx
801079c0:	83 f9 05             	cmp    $0x5,%ecx
801079c3:	0f 84 77 ff ff ff    	je     80107940 <copyout+0x20>
  }
  return 0;
}
801079c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079d1:	5b                   	pop    %ebx
801079d2:	5e                   	pop    %esi
801079d3:	5f                   	pop    %edi
801079d4:	5d                   	pop    %ebp
801079d5:	c3                   	ret    
801079d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079dd:	8d 76 00             	lea    0x0(%esi),%esi
801079e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079e3:	31 c0                	xor    %eax,%eax
}
801079e5:	5b                   	pop    %ebx
801079e6:	5e                   	pop    %esi
801079e7:	5f                   	pop    %edi
801079e8:	5d                   	pop    %ebp
801079e9:	c3                   	ret    

801079ea <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801079ea:	a1 00 00 00 00       	mov    0x0,%eax
801079ef:	0f 0b                	ud2    

801079f1 <copyout.cold>:
801079f1:	a1 00 00 00 00       	mov    0x0,%eax
801079f6:	0f 0b                	ud2    

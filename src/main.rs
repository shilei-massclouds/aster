#![no_std]
#![no_main]
#![feature(allocator_api)]

extern crate alloc;

mod arch;
mod boot;
mod console;
mod mm;
pub mod sync;

use core::panic::PanicInfo;

#[panic_handler]
pub fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

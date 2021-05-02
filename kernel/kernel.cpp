extern "C"

#include "tty.hpp"

using namespace term;

void kernel_main(void)
{
    terminal terminal;

    terminal.initialize();

    terminal.writestring("Hewwo, kernel World!\nHave a great day!!\n\n- Emily.");
}

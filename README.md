# ATM-in-VHDL
ATM for Basys3 Artix-7 FPGA Board in VHDL

Design a bank machine for cash withdrawals in EURO.
* It is assumed that the maximum amount that can be withdrawn once is up to 1000 euro.
* Initially, the card is identified and the operation is selected.
* There will be at least 4 different cards / accounts and at least 4 different operations will be implemented.
* The slot machine has a home where a certain amount (number of different banknotes) is initially entered.
* In the case of a cash release request, the amount is entered, the amount of the requested amount is checked, the types of issued banknotes are displayed and the account is updated. 
* Then issue the card, the amount, and eventually the receipt.

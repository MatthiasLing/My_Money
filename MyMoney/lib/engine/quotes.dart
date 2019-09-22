import 'dart:math';

String getQuote() {
  if (quotes == null) {
    return 'No loaded quotes, how about you put some in?';
  }
  Random rando = new Random();
  int max = quotes.length;
  return quotes[rando.nextInt(max)];
}

List<String> quotes = [
  '“Never spend your money before you have earned it.”\n—Thomas Jefferson',
  '“It’s good to have money and the things that money can buy, but it’s good, too, to check up once in a while and make sure that you haven’t lost the things that money can’t buy.”\n—George Lorimer',
  '“There is a gigantic difference between earning a great deal of money and being rich.”\n—Marlene Dietrich',
  '“Money is usually attracted, not pursued.”\n—Jim Rohn',
  '“If we command our wealth, we shall be rich and free. If our wealth commands us, we are poor indeed.”\n—Edmund Burke',
  '“A simple fact that is hard to learn is that the time to save money is when you have some.”\n—Joe Moore',
  '“Don’t tell me where your priorities are. Show me where you spend your money and I’ll tell you what they are.”'
      '\n—James W. Frick',
  '“If you would be wealthy, think of saving as well as getting.”\n—Benjamin Franklin',
  '“Many folks think they aren’t good at earning money, when what they don’t know is how to use it.”\n—Frank A. Clark',
  '“Many people take no care of their money till they come nearly to the end of it, and others do just the same with their time.”\n—Johann Wolfgang von Goethe'
];

let a = 24 * 60;

console.log(a);

let n = parseInt(a);
n = isNaN(n) ? 30 : n;
n = (n < 1) ? 1 : n;


console.log(n);
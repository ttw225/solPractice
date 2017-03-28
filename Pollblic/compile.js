var fs = require('fs');
var solc = require('solc');
var Poll = fs.readFileSync('./Poll.sol', 'utf-8');
var Index = fs.readFileSync('./Index.sol', 'utf-8');
//console.log(input);
var input = {
	'Poll.sol' : Poll,
	'Index.sol' : Index
}
var output = solc.compile({sources: input}, 1); // 1 activates the optimiser
//console.log(output);
for (var contractName in output.contracts) {
	// code and ABI that are needed by web3
	//console.log(contractName + ': ' + output.contracts[contractName].bytecode);
	fs.writeFileSync('./' + contractName.split('.')[0] + '.bytecode', '0x' + output.contracts[contractName].bytecode);
	fs.writeFileSync('./' + contractName.split('.')[0] + '.abi', output.contracts[contractName].interface);
	//console.log(contractName + '; ' + JSON.parse(output.contracts[contractName].interface));
}
const Web3 = require('web3');
const web3http = new Web3('http://localhost:7545');
const web3ws = new Web3('ws://localhost:7545');
const forumAddress = '0xf575fDe0DDe4ac300971e038b8f5C27d417a200A';
const ABILogTypes=[
	{"indexed": false,"internalType": "string","name": "answer","type": "string"}
]
const forumABI = [
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "string",
				"name": "answer",
				"type": "string"
			}
		],
		"name": "answerAccepted",
		"type": "event"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address",
				"name": "_participant",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "_question",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_answer",
				"type": "string"
			}
		],
		"name": "acceptAnswer",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "string",
				"name": "_question",
				"type": "string"
			}
		],
		"name": "addBounty",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address",
				"name": "_participant",
				"type": "address"
			}
		],
		"name": "addOperator",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address",
				"name": "_newOwner",
				"type": "address"
			}
		],
		"name": "changeOwner",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "destroy",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address",
				"name": "_participant",
				"type": "address"
			},
			{
				"internalType": "uint16",
				"name": "_reputation",
				"type": "uint16"
			}
		],
		"name": "downVote",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address",
				"name": "_participant",
				"type": "address"
			}
		],
		"name": "kick",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "operators",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "participantReputation",
		"outputs": [
			{
				"internalType": "int32",
				"name": "",
				"type": "int32"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"name": "questionBounty",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address",
				"name": "_participant",
				"type": "address"
			}
		],
		"name": "removeOperator",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address",
				"name": "_participant",
				"type": "address"
			},
			{
				"internalType": "uint16",
				"name": "_reputation",
				"type": "uint16"
			}
		],
		"name": "upVote",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	}
]

async function run() {
  const accounts = await web3http.eth.getAccounts();
	
	const forumContract = new web3http.eth.Contract(forumABI, forumAddress);
	
	const subscription = web3ws.eth.subscribe('logs', {fromBlock: '0x0',address: forumAddress})
		.on("data", function(log){
			var decoded=web3ws.eth.abi.decodeParameters(ABILogTypes, log.data);  
			console.log(`Accepted answer: ${decoded[0]}`);
		});
	
	var owner = await forumContract.methods.owner().call();
	console.log(`Contract owner is ${owner}`);
	
	console.log(`Upvoting ${accounts[1]} with 1`);
	await forumContract.methods.upVote(accounts[1], 1)
		.send({from: owner});
		console.log(`Accepting answer from ${accounts[1]}`);
		await forumContract.methods.acceptAnswer(accounts[1],"Question","Great answer")
		.send({from: owner});
	
	console.log(`looking up reputation off ${accounts[1]}`);
	await forumContract.methods.participantReputation(accounts[1]).call()
		.then((result) => {``
			console.log(`${accounts[1]} has a reputation off ${result}`);
		});
	
	subscription.unsubscribe(function(error, success){
		if(success) {
			console.log('Successfully unsubscribed!');
		}
	});
}

run();


let ipfs;
const Buffer = window.buffer.Buffer;

async function init() {
  ipfs = await window.Ipfs.create();
}

async function search() {
  const hash = document.getElementById('ipfsHashInput').value;
  const chunks = [];
  for await (const chunk of ipfs.cat(hash)) {
    chunks.push(chunk)
  }
  log(Buffer.concat(chunks).toString());
}

async function addFile() {
  let file = document.getElementById('fileInput').files;

  for await (const result of ipfs.add(file)) {
    log(`New file uploaded at hash: ${result.path}`);
  }
}

function log(str) {
  document.getElementById("log").innerHTML += '<p>' + str + '</p>';
}

init();
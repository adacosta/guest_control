import Amber from 'amber';

document.addEventListener("DOMContentLoaded", function(){
  // Handler when the DOM is fully loaded
  let socket = new Amber.Socket('/devices');
  socket.connect().then((m) => {console.log(m)});

  let channel = socket.channel('remote_credential_id:<%= remote_credential.id%>');
  channel.join();

  channel.push('message_new', { message: 'devices are the bomb diggity!' });
});
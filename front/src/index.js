const fetchApi = async () => {
  return fetch(`https://$FRONT_API_HOST`)
    .then(response => response.json())
    .catch(error => error);
};

const init = async () => {
  const data = await fetchApi();

  document.querySelector('#app').innerHTML = `
    <h1>Docker Starter Frontend</h1>
    <p>This is the frontend of the Docker Starter application.</p>
    <pre>${JSON.stringify(data, null, 2)}</pre>
  `;
};

init();

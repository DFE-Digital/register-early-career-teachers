document.addEventListener('DOMContentLoaded', () => {
  const buttons = document.querySelectorAll('.populate-find-ect-form-button');

  if (!buttons.length) {
    return;
  }

  const setInputValue = (labelText, value) => {
    const label = Array.from(document.querySelectorAll('label')).find(lbl => lbl.textContent.trim() === labelText);

    if (label) {
      document.getElementById(label.htmlFor).value = value;
    }
  };

  buttons.forEach((button) => {
    button.addEventListener('click', () => {
      const trn = button.dataset.trn;
      const dob = button.dataset.dob;
      const nationalInsuranceNumber = button.dataset.nationalInsuranceNumber;

      setInputValue('Teacher reference number (TRN)', trn);

      if(dob) {
        const [day, month, year] = dob.split('/');
        setInputValue('Day', day);
        setInputValue('Month', month);
        setInputValue('Year', year);
      }

      if(nationalInsuranceNumber) {
        setInputValue('National Insurance Number', nationalInsuranceNumber);
      }
    });
  });
});

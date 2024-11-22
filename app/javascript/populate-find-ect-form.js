document.addEventListener('DOMContentLoaded', () => {
  const buttons = document.querySelectorAll('.populate-find-ect-form-button');

  if (!buttons.length) {
    return;
  }

  const setInputValue = (name, value) => {
    const input = document.querySelector(`input[name="${name}"]`);
    if (input) {
      input.value = value;
    }
  };

  buttons.forEach((button) => {
    button.addEventListener('click', () => {
      const trn = button.dataset.trn;
      const dob = button.dataset.dob;
      const nationalInsuranceNumber = button.dataset.nationalInsuranceNumber;

      setInputValue('find_ect[trn]', trn);

      if(dob) {
        const [day, month, year] = dob.split('/');
        setInputValue('find_ect[date_of_birth(3i)]', day);
        setInputValue('find_ect[date_of_birth(2i)]', month);
        setInputValue('find_ect[date_of_birth(1i)]', year);
      }

      if(nationalInsuranceNumber) {
        setInputValue('national_insurance_number[national_insurance_number]', nationalInsuranceNumber);
      }
    });
  });
});

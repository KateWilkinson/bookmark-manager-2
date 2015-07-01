feature 'User sign up' do

  scenario 'users/new page loads correctly' do
    visit '/users/new'
    expect(page.status_code).to eq(200)
  end

  scenario 'I can sign up as a new user' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, alice@example.com')
    expect(User.first.email).to eq('alice@example.com')
  end

  scenario 'With a password that does not match' do
    expect { sign_up(password_confirmation: 'wrong')}.not_to change(User, :count)
  end

  def sign_up(email: 'alice@example.com',
              password: 'oranges!',
              password_confirmation: 'oranges!')
    visit '/users/new'
    fill_in :email,    with: email
    fill_in :password, with: password
    fill_in :password_confirmation, with: password_confirmation
    click_button 'Sign up'
  end
end

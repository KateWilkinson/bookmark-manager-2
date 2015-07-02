require './spec/factory/user.rb'

feature 'User sign up' do

  scenario 'users/new page loads correctly' do
    visit '/users/new'
    expect(page.status_code).to eq(200)
  end

  scenario 'I can sign up as a new user' do
    user = build :user
    expect { sign_up(user) }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, hello@email.com')
    expect(User.first.email).to eq('hello@email.com')
  end

  scenario 'With a password that does not match' do
    user = build(:user, password_confirmation: 'wrong')
    expect { sign_up(user) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content('Password does not match the confirmation')
  end

  scenario 'I cannot sign up with an existing  email' do
    user = create :user
    sign_up(user)
    expect { sign_up(user) }.to change(User, :count).by(0)
    expect(page).to have_content('Email is already taken')
  end
end

feature 'User sign in' do
  let (:user) do
    User.create(email: 'user@example.com',
                password: 'secret1234',
                password_confirmation: 'secret1234')
  end

  scenario 'with correct credentials'do
    sign_in(user)
    expect(page).to have_content "Welcome, #{user.email}"
  end

end

feature 'User sign out' do

  let(:user)do
    User.create(email:'test@test.com',
                password: 'test',
                password_confirmation: 'test')
  end

  scenario 'while being signed in' do
    sign_in(user)
    click_button 'Sign out'
    expect(page).to have_content('Goodbye!')
    expect(page).not_to have_content('Welcome, test@test.com')
  end

end

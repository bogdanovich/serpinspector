shared_context 'login' do
  # logging in
  def login(user)
    visit root_path
    fill_in 'name',     with: user.name
    fill_in 'password', with: 'test'
    click_button 'Login'
  end
end
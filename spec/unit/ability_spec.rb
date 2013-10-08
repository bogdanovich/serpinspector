require 'spec_helper'

describe 'CanCan test' do
  before(:all) do
    @admin        = FactoryGirl.create(:admin)
    @user         = FactoryGirl.create(:user)
    @another_user = FactoryGirl.create(:user)
    
    @admin_project        = @admin.projects.new
    @user_project         = @user.projects.new
    @another_user_project = @another_user.projects.new

    @admin_report_group        = @admin.report_groups.new
    @user_report_group         = @user.report_groups.new
    @another_user_report_group = @another_user.report_groups.new

    @admin_ability = Ability.new(@admin)
    @user_ability  = Ability.new(@user)
  end

  describe 'User abilities' do
    describe 'Project permissions' do
      specify { expect( @user_ability.can?(   :destroy, @user_project)).to  eq true         }
      specify { expect( @user_ability.cannot?(:destroy, @admin_project)).to eq true         }
      specify { expect( @user_ability.cannot?(:destroy, @another_user_project)).to eq true  }

      specify { expect( @user_ability.can?(   :edit,    @user_project)).to eq true          }
      specify { expect( @user_ability.cannot?(:edit,    @another_user_project)).to eq true  }
      specify { expect( @user_ability.cannot?(:edit,    @admin_project)).to eq true         }

      specify { expect( @user_ability.can?(   :update,  @user_project)).to eq true          }
      specify { expect( @user_ability.cannot?(:update,  @another_user_project)).to eq true  }
      specify { expect( @user_ability.cannot?(:update,  @admin_project)).to eq true         }

      specify { expect( @user_ability.can?(   :read,    @user_project)).to eq true          }
      specify { expect( @user_ability.cannot?(:read,    @another_user_project)).to eq true  }
      specify { expect( @user_ability.cannot?(:read,    @admin_project)).to eq true         }

      specify { expect( @user_ability.can?( :create,    @user_project)).to eq true          }
      specify { expect( @user_ability.cannot?(:create,  @another_user_project)).to eq true  }
      specify { expect( @user_ability.cannot?(:create,  @admin_project)).to eq true         }

      specify { expect( @user_ability.can?(   :manage,  @user_project)).to eq true          }
      specify { expect( @user_ability.cannot?(:manage,  @another_user_project)).to eq true  }
      specify { expect( @user_ability.cannot?(:manage,  @admin_project)).to eq true         } 
    end

    describe 'Report Group premissions' do
      specify { expect( @user_ability.can?(   :destroy, @user_report_group)).to  eq true        }
      specify { expect( @user_ability.cannot?(:destroy, @admin_report_group)).to eq true        }
      specify { expect( @user_ability.cannot?(:destroy, @another_user_report_group)).to eq true }

      specify { expect( @user_ability.cannot?(:edit,    @user_report_group)).to eq true         }
      specify { expect( @user_ability.cannot?(:edit,    @another_user_report_group)).to eq true }
      specify { expect( @user_ability.cannot?(:edit,    @admin_report_group)).to eq true        }

      specify { expect( @user_ability.cannot?(:update,  @user_report_group)).to eq true         }
      specify { expect( @user_ability.cannot?(:update,  @another_user_report_group)).to eq true }
      specify { expect( @user_ability.cannot?(:update,  @admin_report_group)).to eq true        }

      specify { expect( @user_ability.can?(   :read,      @user_report_group)).to eq true       }
      specify { expect( @user_ability.cannot?(:read,    @another_user_report_group)).to eq true }
      specify { expect( @user_ability.cannot?(:read,    @admin_report_group)).to eq true        }

      specify { expect( @user_ability.cannot?(:create,    @user_report_group)).to eq true       }
      specify { expect( @user_ability.cannot?(:create,  @another_user_report_group)).to eq true }
      specify { expect( @user_ability.cannot?(:create,  @admin_report_group)).to eq true        }

      specify { expect( @user_ability.cannot?(:manage,  @user_report_group)).to eq true         }
      specify { expect( @user_ability.cannot?(:manage,  @another_user_report_group)).to eq true }
      specify { expect( @user_ability.cannot?(:manage,  @admin_report_group)).to eq true        } 
    end

    describe 'Users permissions' do
      specify { expect( @user_ability.cannot?(:destroy, @user)).to  eq true         }
      specify { expect( @user_ability.cannot?(:destroy, @admin)).to eq true         }
      specify { expect( @user_ability.cannot?(:destroy, @another_user)).to eq true  }

      specify { expect( @user_ability.cannot?(:create,    @user)).to eq true        }
      specify { expect( @user_ability.cannot?(:create,  @another_user)).to eq true  }
      specify { expect( @user_ability.cannot?(:create,  @admin_user)).to eq true    }
      
      specify { expect( @user_ability.can?(   :edit,      @user)).to eq true        }
      specify { expect( @user_ability.cannot?(:edit,    @another_user)).to eq true  }
      specify { expect( @user_ability.cannot?(:edit,    @admin)).to eq true         }

      specify { expect( @user_ability.can?(   :update,    @user)).to eq true        }
      specify { expect( @user_ability.cannot?(:update,  @another_user)).to eq true  }
      specify { expect( @user_ability.cannot?(:update,  @admin)).to eq true         }

      specify { expect( @user_ability.can?(   :read,      @user)).to eq true        }
      specify { expect( @user_ability.cannot?(:read,    @another_user)).to eq true  }
      specify { expect( @user_ability.cannot?(:read,    @admin)).to eq true         }

      specify { expect( @user_ability.cannot?(:manage,    @user)).to eq true        }
      specify { expect( @user_ability.cannot?(:manage,  @another_user)).to eq true  }
      specify { expect( @user_ability.cannot?(:manage,  @admin_user)).to eq true    } 

      specify { expect( @user_ability.cannot?(:update_name,  @user)).to eq true     }
      specify { expect( @user_ability.cannot?(:udate_role,   @user)).to eq true     }
    end

    describe 'Search Engines Premissions' do
      specify { expect( @user_ability.cannot?(:destroy, SearchEngine)).to  eq true  }
      specify { expect( @user_ability.cannot?(:edit,    SearchEngine)).to eq true   }
      specify { expect( @user_ability.cannot?(:update,  SearchEngine)).to eq true   }
      specify { expect( @user_ability.cannot?(:create,  SearchEngine)).to eq true   }
      specify { expect( @user_ability.can?(   :read,    SearchEngine)).to eq true   }
    end

    describe 'Settings Premissions' do
      specify { expect( @user_ability.cannot?(:destroy, SettingsForm)).to  eq true  }
      specify { expect( @user_ability.cannot?(:edit,    SettingsForm)).to eq true   }
      specify { expect( @user_ability.cannot?(:update,  SettingsForm)).to eq true   }
      specify { expect( @user_ability.cannot?(:create,  SettingsForm)).to eq true   }
      specify { expect( @user_ability.can?(   :read,    SettingsForm)).to eq true   }
    end

    describe 'LogViewer Premissions' do
      specify { expect( @user_ability.cannot?(:destroy, LogViewer)).to  eq true     }
      specify { expect( @user_ability.cannot?(:edit,    LogViewer)).to eq true      }
      specify { expect( @user_ability.cannot?(:update,  LogViewer)).to eq true      }
      specify { expect( @user_ability.cannot?(:create,  LogViewer)).to eq true      }
      specify { expect( @user_ability.cannot?(:read,    LogViewer)).to eq true      }
      specify { expect( @user_ability.cannot?(:manage,  LogViewer)).to eq true      }
    end
    
  end
    
end

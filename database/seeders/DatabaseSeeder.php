<?php

namespace Database\Seeders;

use App\Models\Account;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    public function run(): void
    {
        $user = User::factory()->create([
            'name' => 'admin',
            'email' => 'admin@23p4.local',
            'password' => bcrypt('password'),
        ]);

        $account = Account::create([
            'name' => 'Default Account',
            'plan' => 'free',
        ]);

        $account->users()->attach($user, ['role' => 'owner']);
    }
}

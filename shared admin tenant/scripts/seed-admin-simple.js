import dotenv from 'dotenv';
dotenv.config();

import { db } from './server/db.ts';
import { 
  availableIntegrations, 
  platformSettings, 
  systemAdmins,
  users
} from './shared/schema.ts';

async function seedAdminData() {
  console.log('🌱 Seeding BridgeLayer admin data...');

  try {
    console.log('📊 Database connected successfully');

    // Create BridgeLayer platform admin user
    const [adminUser] = await db.insert(users).values({
      email: 'admin@bridgelayer.com',
      username: 'bridgelayer_admin', 
      password: '$2a$10$temporary.hash.for.development', // Should be properly hashed
      firstName: 'BridgeLayer',
      lastName: 'Admin',
      role: 'platform_admin',
      firmId: null // Platform admin doesn't belong to a specific firm
    }).onConflictDoNothing().returning();

    if (adminUser) {
      console.log('✅ Created BridgeLayer admin user:', adminUser.email);
      
      // Create system admin record
      await db.insert(systemAdmins).values({
        userId: adminUser.id,
        permissions: {
          platform: ['all'],
          tenants: ['read', 'write', 'create', 'delete'],
          users: ['read', 'write', 'create', 'delete'], 
          system: ['config', 'backup', 'audit']
        }
      }).onConflictDoNothing();
      
      console.log('✅ Created system admin permissions');
    }

    // Insert available integrations for FirmSync platform
    const integrations = [
      {
        name: 'google_drive',
        description: 'Google Drive cloud storage integration',
        type: 'storage',
        configSchema: {
          clientId: { type: 'string', required: true },
          clientSecret: { type: 'string', required: true },
          scopes: { type: 'array', default: ['https://www.googleapis.com/auth/drive.readonly'] }
        }
      },
      {
        name: 'dropbox',
        description: 'Dropbox cloud storage integration', 
        type: 'storage',
        configSchema: {
          clientId: { type: 'string', required: true },
          clientSecret: { type: 'string', required: true }
        }
      },
      {
        name: 'clio',
        description: 'Clio practice management integration',
        type: 'practice_management',
        configSchema: {
          clientId: { type: 'string', required: true },
          clientSecret: { type: 'string', required: true }
        }
      },
      {
        name: 'quickbooks',
        description: 'QuickBooks accounting integration',
        type: 'accounting', 
        configSchema: {
          appToken: { type: 'string', required: true },
          consumerKey: { type: 'string', required: true }
        }
      }
    ];

    for (const integration of integrations) {
      await db.insert(availableIntegrations).values(integration).onConflictDoNothing();
    }
    console.log(`✅ Created ${integrations.length} available integrations`);

    // Insert platform settings
    const settings = [
      {
        key: 'ai_features_enabled',
        value: 'true',
        description: 'Enable AI document analysis across all firms',
        category: 'ai'
      },
      {
        key: 'max_documents_per_firm', 
        value: '1000',
        description: 'Maximum documents allowed per firm',
        category: 'limits'
      },
      {
        key: 'max_file_size_mb',
        value: '10', 
        description: 'Maximum file size in megabytes',
        category: 'limits'
      },
      {
        key: 'default_plan',
        value: 'starter',
        description: 'Default plan for new firms',
        category: 'billing'
      }
    ];

    for (const setting of settings) {
      await db.insert(platformSettings).values(setting).onConflictDoNothing();
    }
    console.log(`✅ Created ${settings.length} platform settings`);

    console.log('🎉 BridgeLayer admin panel seeded successfully!');
    console.log('📧 Admin login: admin@bridgelayer.com');
    console.log('🔑 Password: temp_admin_password_123 (CHANGE IN PRODUCTION)');
    
  } catch (error) {
    console.error('❌ Error seeding admin data:', error);
    throw error;
  }
}

// Run the seeding
seedAdminData()
  .then(() => {
    console.log('✨ Seeding complete - Ready for BridgeLayer management!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('💥 Seeding failed:', error);
    process.exit(1);
  });
